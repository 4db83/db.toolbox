function [yfit, mse, bhat, pips, xnames, S] = dms_dma(y,x,Alpha,Lambda,Kappa,drop_constant_only_model,no_constant,timer_on)
%{F: Does DMS/DSM for a given set of Alpha,Lambda/Kappa parameters.
%========================================================================================
% This is a much faster/simpler implementation of the original Koop and Korobilis code
% that does a time varying parameter state-space model with variable selecton at the same
% time. 
%----------------------------------------------------------------------------------------
% 	USGAGE:		[yfit, mse, bhat, pips, xnames, S] = dms_dma(y,x,Alpha,Lambda,Kappa,drop_constant_only_model,no_constant,timer_on)
%----------------------------------------------------------------------------------------
% 	INPUT : 
%	  y:				(Tx1) vector, dependent variable.
%		x:				(TxK) vector of regressors, including the constant [1 x1 x2 x3 etc]
%   Alpha:		scalar, model foregetting factor.
%   Lambda:		scalar, other foregetting factor for variance approximation. 
%   Kappa:		scalar, EWMA variance smoothing parameter to model measurement equation 
%							error volatility as a time varying process.
%
%		drop_constant_only_model:
%							binary indicator, default = 0 (do not drop constant only
%							model). if = 1, the trivial model with a constant only is dropped from all
%							evaluation/averaging. This is important when forecasting multiple periods
%							ahead with the direct forecasting method.
%		no_constant:
%							binary indicator, default = 0 (constant is included in the regressor set x).
%							if = 1, the regressor vector consists of x = [x1 x2 x3 etc] only and does
%							NOT contain a vector of ones. Useful when wanting to surpress the constant
%							from the measurement equation of the space model. 
%	  timer_on:	binary indicator, default = 0, but can be set to 1 if one wants to measure
%							the time it takes to evaluate one model given parameters. 
%                 
% 	OUTPUT:       
%	  yfit:			structure, forecasts from the dma,dms and dmq (best q-models).
%	  mse:			structure, MSEs from the dma,dms and dmq (best q-models).
%	  bhat:			structure, time-varying beta_hats of all models that are fitted (full),
%							the tv_dms, tv_dma and tv_all regressor models.
%		pips:			(TxK) vector of posterior inclusion probabilities.
%		xnames:		(1xK) vector of cell string names of the regressors variables.
%		S:				(MxK) vector of binary indicators that is equal to 1 if a variables is
%							included in a given model. Can be used to trace back which variables belong
%							to which model.
%========================================================================================
% 	NOTES :   see the Koop and Korobilis (2012) paper for further details. 
%----------------------------------------------------------------------------------------
% Created :		05.12.2013.
% Modified:		20.01.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

%% setting some default values if not set up initially
SetDefaultValue(5, 'Kappa', 0.94);
SetDefaultValue(6, 'drop_constant_only_model', 0);
SetDefaultValue(7, 'no_constant', 0);
SetDefaultValue(8, 'timer_on', 0);

%% intialisation of variance of measurement error volatiliyt u(t)
% fitols = fastols(y,x);
% init_H = fitols.sig2
init_H = 0.1;

%% preliminary data and model size
[T,K]	= size(x);													% Sample size and dim(X) (set no_constant = 1 if it does not included a constant)
k			= K - (1 - no_constant);						% No. of Regressors (without constant)
S 	  = powerset(1:k);										% create the powerset Model Selector

if no_constant
	S		= S((1 + no_constant):end,:);				% resize the set if no_constant = 1.
else
	S		= [true(length(S),1) S];						% else add constant indicator
end
M 	  = length(S);												% Total number of models

% check_model_size 
if ~M == (2^k - no_constant);	disp(' Warning: modelsizes missmatch'); end;

% PRIORS (initialisation) of mean, variance of the states and model probabilities
b_00	= 0;
P_00	= 1/Lambda;	
pi_00	= 1/M;

% make regressor name vector.
xnames = cell(1,K);
if ~no_constant; xnames{1} = 'C'; end;
for xi = (2 - no_constant):K;
	xnames{xi} = ['X' num2str(xi - (1 - no_constant))];
end;

%% print names of different model variables 
% for m = 1:M
% 		xnames(S(m,:))
% end;

%% space allocation
beta 	= cell(M,1);
P			= cell(M,1);
yhat 	= zeros(M,T);
uhat 	= zeros(M,T);
F			= zeros(M,T);
H			= zeros(M,T);
% model probability space
pitt_1= zeros(M,T);			% Pr_(t|t-1) forecasting
pitt	= zeros(M,T);			% Pr_(t|t)	 updating

% space allocation for the cells beta and P
for m = 1:M;
	% number of regressors for each of the possible models + 1 (because of constant)
	km			= sum(S(m,:),2);
	beta{m} = zeros(km,T);
	P{m}		= zeros(km,km,T); 
end;

indx = (1:K)';

%% Main time loop
tt = timer_init;	% for the timer
for t = 1:T;
	% Model Loop 
	for m = 1:M;
		% make selected regressors vector for Model(m)
		xtm = x(t,S(m,:));
		km  = length(xtm);
		% Prediction of states (where btt_1 means beta_t|t-1 and Ptt_1 means P_t|t-1)
		if t==1
 			% first observation only
 			btt_1	= b_00*ones(km,1);
 			Ptt_1	= P_00*eye(km);
			pitt_1(:,t) = pi_00;
		else % all others as usual
 			btt_1	= beta{m}(:,t-1);
 			Ptt_1	= P{m}(:,:,t-1)/Lambda;	% MSE (Var of states) approximation
			pitt_1(:,t) = (pitt(:,t-1).^Alpha)./sum(pitt(:,t-1).^Alpha);
 		end
		% Forecasting y_t
		yhat(m,t)	= xtm*btt_1;
		uhat(m,t) = y(t) - yhat(m,t);
		% EWMA for H_t (subtract 0.03 to avoid having integrated variance model)
	 	if t==1;
			H(m,t)	= init_H;
		else        	
			H(m,t)	= 0.01 + (1-Kappa-0.02)*uhat(m,t-1).^2 + Kappa*H(m,t-1);
% 			H(m,t)	= (1-Kappa)*uhat(m,t-1).^2 + Kappa*H(m,t-1);
 		end;
% 	H(m,t) = 1;
		% Forecast error MSE (Var of forecast errors)
		F(m,t)	= xtm*Ptt_1*xtm' + H(m,t);
		% Kalman Gain
		KG			= Ptt_1*xtm'/F(m,t);
	 	% Updating
	 	beta{m}(:,t) = btt_1 + KG*uhat(m,t);
		P{m}(:,:,t)	 = Ptt_1 - KG*xtm*Ptt_1;
	end;
	% Forecasting Model Probabilities (eq. 15 in KK)
	pi_w(:,t)	= pitt_1(:,t).*norm_pdf(y(t),yhat(:,t),F(:,t)); % norm_pdf input is Variance not std.dev.
	% Updating Model Probabilities (eq. 16 in KK)
	pitt(:,t)	= pi_w(:,t)./sum(pi_w(:,t));
	% Timer
	if timer_on 
		if t==10				; mytimer(tt.t0,tt.t00,t,T); end;
		if mod(t,100)==0; mytimer(tt.t0,tt.t00,t,T); end;
	end
end;

if drop_constant_only_model == 1
	if no_constant 
		disp(' Error: you are trying to drop a constant in a no constant model');
		disp(' Results are not valid because you have dropped the first regressors result');
	end
	yhat		= yhat(2:end,:);
	pitt_1	= pitt_1(2:end,:);	
	pitt_1  = reweight(pitt_1);	
end;

%% DMA forecasts based on Predicted Probabilities (eq. below eq. 16 in KK)
yfit.dma = sum(pitt_1.*yhat)';

% Forecasts based on the full regressor set (simply a TVP model, no variable selection)
yfit.tvp = yhat(M,:)';

% DMS forecasts based on BEST of the Predicted Probabilities
[pitt_1_s, SI] = sort(pitt_1,'descend');	% SI is the sort index.
% [sort_p, SI] = sort(pitt,'descend');		% This is what Koop and Korobilis are using current probs no predicted.

% sort the forecasts yhat in each time period according to Pr_t|t-1 (ie. SI index)
for t = 1:T;
	yhat_sort(:,t) = yhat(SI(:,t),t);
end;
yfit.dms	= yhat_sort(1,:)';

% DMQ forecast averaging over the q BEST models, q is found by min(MSE) for q=2:M so here we do not fix q, but use number of averaging models that gives best forecast. 
Q		= size(yhat,1); % all possible models is M, but use Q here as we may drop the constant only model
mse_dmq	= nan(Q,1);
for q = 2:Q
	yhat_dmq	= sum(reweight(pitt_1_s(1:q,:)).*yhat_sort(1:q,:))';
	mse_dmq(q,1)= mean((y - yhat_dmq).^2);
end

% find the best fitting q averaged model and its forecast
best_q		= find(min(mse_dmq)==mse_dmq);
yfit.dmq	= sum(reweight(pitt_1_s(1:best_q,:)).*yhat_sort(1:best_q,:))';

% Store/compute MSEs of different models % struct2mat(mse)'
mse.dma = mean((y-yfit.dma).^2);                                                  
mse.dms = mean((y-yfit.dms).^2);
mse.dmq = min(mse_dmq); 
mse.tvp = mean((y-yfit.tvp).^2);

%% compute the Posterior Inclusion Probabilities (PIPs) of each variable 
% this is done by finiding variable X* in each model and then summing over the model probs in which X* is included. 
pips = zeros(T,k);		% space allocation
pitt = pitt';
for ii = 1:k
	pips(:,ii) = sum(pitt(:,S(:,ii+(1-no_constant))),2);	
end

%% create a vector of timevarying betas for the full and best models.
% for all other models this is not directly possible due to the averaging nature so would require averaging over the betas. 
MM = M-drop_constant_only_model;				% number of models when the constant only model is dropped.
bhat.tvp	= beta{M}';
bhat.dms	= zeros(T,K);							% storage.
bhat.dma	= zeros(T,K);							% storage.
bhat.full	= zeros(K,T,MM);					% storage.

for t = 1:T
	% create a 3D vector of BEST model betas (with zeros in them)
	for m = 1:MM
		mm = m+drop_constant_only_model;
		bhat.full(indx(S(mm,:)),t,m) = beta{mm}(:,t);
	end;
	% best model betas (selecting at each time period the best forecasting beta)
	bhat.tv_dms(t,:)	= bhat.full(:,t,SI(1,t))';
	% DMA averaged model betas 
	bhat.tv_dma(t,:)	=	squeeze(bhat.full(:,t,:))*pitt_1(:,t);
end;

