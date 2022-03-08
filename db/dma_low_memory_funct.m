function [yfit, mse, bhat, pips, xnames, S] = ...
					dma_low_memory_funct(y,x,h,R,Params,Priors,timer_on,fixed_q,always_in,no_constant);
%dma_funct(y,x,h,Alpha,Lamda,Priors,Kappa,fixed_q,always_in,timer_on,no_constant)
%{F: Does DMS/DSM for a given set of Alpha,Lambda/Kappa parameters.
%========================================================================================
% This is a much faster/simpler implementation of the original Koop and Korobilis code
% that does a time varying parameter state-space model with variable selecton at the same
% time. 
%----------------------------------------------------------------------------------------
% 	USGAGE:		[yfit, mse, bhat, pips, xnames, S, beta] = ...
%							dma_funct(y,x,h,Param,Priors,fixed_q,always_in,timer_on,no_constant);
%----------------------------------------------------------------------------------------
% 	INPUT : 
%----------------------------------------------------------------------------------------
%	  y:				(Tx1) vector, dependent variable.
%		x:				(TxK) vector of regressors, including the constant [1 x1 x2 x3 etc]
%		h: 				scalar, forecast horizon.
%
% 	Param:		(3x1 vector) [Lambda Kappa Alpha], DMA parameters with following entries:
%   					Lambda:		scalar, other forgetting factor for variance approximation. 
%   					Alpha:		scalar, model forgetting factor.
%   					Kappa:		scalar, EWMA variance smoothing parameter to model measurement 
%												equation error volatility as a time varying process.
%
%		Priors: 	structure, with priors for mean, variance, Model prob., etc:
%							beta_mean: 	prior for beta parameter, generally set at 0 for simplicity.
%							beta_var:		prior for beta variance P_00, generally set to prop. 1/lambda.
%							H_init:	 		Initial value for the EWMA Variance equation.
%							model_prob: Prior for the model probabilities.
%----------------------------------------------------------------------------------------
%		Optional inputs:
%----------------------------------------------------------------------------------------
%		fixed_q:	scalar, fixed number of models to average over in the aggregating function.
% 
%	always_in:	scalar, indicates which first few variables in the regressor vector (excluding the constant)
%							are always kept in the model. NOTE 3 here would mean regressors X1,X2,X3, out of the
%							total k regressors are always in every model.
%
%	  timer_on:	binary indicator, default = 0, but can be set to 1 if one wants to measure
%							the time it takes to evaluate one model given parameters. 
%
% no_constant: binary indicator, default = 0 (constant is included in the regressor set x).
%							if = 1, the regressor vector consists of x = [x1 x2 x3 etc] only and does
%							NOT contain a vector of ones. Useful when wanting to suppress the constant
%							from the model. NOTE: one needs to make sure that the x data matrix that is supplied
%							does not include a constant (vector of ones) in it.
%----------------------------------------------------------------------------------------
% 	OUTPUT:       
%----------------------------------------------------------------------------------------
%	  yfit:			structure, forecasts from the dma,dms and dmq (best q-models).
%	  mse:			structure, MSEs from the dma,dms and dmq (best q-models).
%	  bhat:			structure, time-varying beta_hats of all models that are fitted (full),
%							the tv_dms, tv_dma and tv_all regressor models.
%		pips:			(TxK) vector of posterior inclusion probabilities.
%		xnames:		(1xK) vector of cell string names of the regressors variables.
%		S:				(MxK) vector of binary indicators that is equal to 1 if a variables is
%							included in a given model. Can be used to trace back which variables belong
%							to which model.
%   beta_tt:	(Mx1) structure of all the filtered beta_t|t for all time periods. These are 
%							needed to construct all the model forecasts.
%========================================================================================
% 	NOTES :   see the Koop and Korobilis (2012) paper for further details. 
%----------------------------------------------------------------------------------------
% Created :		05.08.2013.
% Modified:		21.05.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

%% setting some default values if not set up initially
SetDefaultValue( 7, 'timer_on'		, 0);
SetDefaultValue( 8, 'fixed_q'			, 3);			
SetDefaultValue( 9, 'always_in'		, 0);
SetDefaultValue(10, 'no_constant'	, 0);

% set default timer value
if timer_on == 1; 
	TTT = 5e2; 
else; 
	TTT = timer_on; 
end;

%% ------------------------------------------------------------------------------------------------
% Parameters required for DMA (Params = [Lambda Kappa Alpha])
Lamda		= Params(1);											% forgetting factor for the variance equation P_tt.
Alpha		= Params(2);											% forgetting factor for model updating Probs (not so influential)
Kappa		= Params(3);											% EWMA weighting term

% invert outside loop to save time
inv_Lamda		= 1/Lamda;				

% some anonymous functions 
MSE			= @(y,yhat) (mean((repmat(y,1,size(yhat,2))-yhat).^2)); % Mean square error function
Pr_hat	= @(x,a) (bsxfun(@rdivide,x.^a,sum(x.^a)));						  % Predicted probabilities given alpha at time T.

% preliminary data and model size
[T,K]		= size(x);													% Sample size and dim(X) (set no_constant = 1 if it does not included a constant)
k				= K - ~no_constant;									% full set of regressor without constant.
ks			= K - always_in - ~no_constant;			% No. of Regressors (without constant) that can be selected.
pwst		= powerset(1:ks);										% create the powerset Model Selector indicator

% add a constant and "always in" Selector indicator. 
S				= [true(length(pwst),~no_constant+always_in) pwst];

% check if no_constant+always_in = 0 leading to one row having only 0. 
% then we need to remove first entry
if sum(S(1,:),2) == 0
	S		= S(2:end,:);												% resize the M set if no_constant = 1.
end;
M 	  = size(S,1);												% Total number of models

% check_model_size 
if M ~= (2^ks);	
	disp(' Warning: Model size missmatch');
end;

% PRIORS (initialisation) of mean, variance of the states and model probabilities
b_00 	= Priors.beta_mean;
P_00	= Priors.beta_var;
H_00	= Priors.H_init;
if isempty(Priors.model_prob)
	pi_00	= 1/M;
else
	pi_00 = Priors.model_prob
end;

% -------------------------------------------------------------------------------------------------
% make regressor name and index vector (NOT NEEDED BUT JUST TO CHECK THE REGRESSORS CONVENIENT TO HAVE)
for xi = 0:K;	xnames{xi+1} = ['X' num2str(xi)]; end;
if ~no_constant; xnames{1} = 'C';	xnames(end) = []; else; xnames(1) = []; end;
% -------------------------------------------------------------------------------------------------

%% SPACE ALLOCATION
beta_tt	= cell(M,1);
P				= cell(M,1);
yhat		= NaN(M,T);
uhat		= zeros(M,T);
F				= zeros(M,T);
H				= zeros(M,T);
% model probability space
pitt_1	= zeros(M,T);			% Pr_(t|t-1) forecasting
pitt		= zeros(M,T);			% Pr_(t|t)	 updating
pi_w		= zeros(M,T);			% temporary un-normalised model probablity matrix.

% space allocation for the cells beta and P
for m = 1:M;
	% number of regressors for each of the possible models + 1 (because of constant)
	km					= sum(S(m,:),2);
	beta_tt{m}	= zeros(km,T);
	P{m}				= zeros(km,km,T); 
end;

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
 			pitt_1(:,t) = pi_00;												% prediceted model Probs (pitt(:,t-1).^Alpha)./sum(pitt(:,t-1).^Alpha);
			btt_1		= b_00*ones(km,1);									% \beta_t|t-1 for first period
 			Ptt_1		= P_00*eye(km);											% P_t|t-1 for first period
			H(m,t)	= H_00;															% Volality initialisation for all models for first period
		else % all others as usual
			pitt_1(:,t) =	Pr_hat(pitt(:,t-1),Alpha);		% prediceted model Probs (pitt(:,t-1).^Alpha)./sum(pitt(:,t-1).^Alpha);
			btt_1		= beta_tt{m}(:,t-1);
 			Ptt_1		= P{m}(:,:,t-1)*inv_Lamda;					% MSE (Var of states) approximation
			% EWMA for H_t (subtract 0.02 to avoid having an integrated variance model)
			% This is the original Koop and Korobilis EWMA/IGARCH with 0 intercept version with Integrated Vol.
			H(m,t)	= (1-Kappa)*uhat(m,t-1).^2 + Kappa*H(m,t-1);
			% this below would be a verison that is a GARCH version with non-zero intercept and non-Integrated Vol
			% H(m,t)	= 0.01 + (1-Kappa-0.02)*uhat(m,t-1).^2 + Kappa*H(m,t-1);
		end
		% Forecasting y_t 
		yhat(m,t)	= xtm*btt_1;
		uhat(m,t) = y(t) - yhat(m,t);
		% Forecast error MSE (Var of forecast errors)
		F(m,t)	= xtm*Ptt_1*xtm' + H(m,t);
		% Kalman Gain
		KG			= Ptt_1*xtm'/F(m,t);
	 	% Updating
	 	beta_tt{m}(:,t) = btt_1 + KG*uhat(m,t);
		P{m}(:,:,t)			= Ptt_1 - KG*xtm*Ptt_1;
	end;
	% Forecasting Model Probabilities (eq. 15 in KK) 
	pi_w(:,t)	= pitt_1(:,t).*norm_pdf(y(t),yhat(:,t),F(:,t)); % norm_pdf input is Variance not std.dev.
	% Updating Model Probabilities (eq. 16 in KK)
	pitt(:,t)	= pi_w(:,t)./sum(pi_w(:,t));
	% Timer
	if timer_on 
		if t==10				; mytimer(tt.t0,tt.t00,t,T); end;
		if t==30				; mytimer(tt.t0,tt.t00,t,T); end;
		if mod(t,TTT)==0; mytimer(tt.t0,tt.t00,t,T); end;
	end
end;

% compute the Posterior Inclusion Probabilities (PIPs) of each variable 
% this is done by finiding variable X* in each model and then summing over the model probs in which X* is included. 
pips = zeros(T,ks);		% space allocation
for ii = 1:ks
	pips(:,ii) = sum(pitt(S(:,ii+(1-no_constant)),:))';
end

%% ------------------------------------------------------------------------------------------------
% In-sample forecast from DMA,DMS,DMQ full model TVP. 
% -------------------------------------------------------------------------------------------------
% For SubSet (SS) regression, define the following sum across columns of indicator vector S to find number for regressors in each model
sumS		= sum(S,2);			
% subset is defined as the vector of all possible variables
subset	= min(sumS):max(sumS);

% Use dma_combine_model_forecasts_funct.m function to construct DMA,DMS,DMQ etc forecasts
[yfit_in,mse_in,best,sorts,subset_I] = ...
	dma_combine_model_forecasts_funct(y,yhat,pitt_1,sumS,subset,fixed_q);

% Extract indices and various other quantities
best_q              = best.q;
SI                  = sorts.SI;
pitt_1_s            = sorts.pitt_1; 
best_SS_I           = best.SS_I;
best_SS_I_ew        = best.SS_I_ew;

%% ------------------------------------------------------------------------------------------------
% Full vector of time-varying betas for the full and best models.
% -------------------------------------------------------------------------------------------------
xindx               = (1:K)';					% make regressor index.
% NOTE: this is not directly possible for all other models, due to the averaging nature so would require averaging over the betas. 
% M is the larges or full regressors set model.
%bhat.full           = zeros(K,T,M);		% storage.
bhat.tvp            = beta_tt{M}';		% full model betas correspond to TVP model.
bhat.dms            = zeros(T,K);			% storage.
bhat.dma            = zeros(T,K);			% storage.
bhat.dmq            = zeros(T,K);			% storage.
bhat.dma_ew         = zeros(T,K);			% storage for equal weighting of betas
bhat.dmq_ew         = zeros(T,K);			% storage for equal weighting of betas
bhat.best_subset    = zeros(T,K);			% storage for best subset regression betas
bhat.best_subset_ew = zeros(T,K);			% storage for subset regression betas with equal weighting

% Now loop through time to create all aggregated time varying betes
for t = 1:T
	% create a 3D vector of BEST model betas (with zeros in them)
	for m = 1:M
		bhat.full(xindx(S(m,:)),t,m) = beta_tt{m}(:,t);
	end;
	% best model betas (selecting at each time period the best forecasting beta)
	bhat.dms(t,:)            = bhat.full(:,t,SI(1,t))';
	% DMA averaged model betas 
	bhat.dma(t,:)            = (squeeze(bhat.full(:,t,:))*pitt_1(:,t))';
	% DMQ averaged model betas (only average over the Q best fitting models)
	bhat.dmq(t,:)            = (squeeze(bhat.full(:,t,SI(1:best_q,t)))*reweight(pitt_1_s(1:best_q,t)))';
	% DMA/DMQ with equal weighting
	bhat.dma_ew(t,:)         = mean(squeeze(bhat.full(:,t,:)),2)';
	bhat.dmq_ew(t,:)         = mean(squeeze(bhat.full(:,t,SI(1:best_q,t))),2)';
	% Best Subset regression parameters
	bhat.best_subset(t,:)    = (squeeze(bhat.full(:,t,subset_I{best_SS_I}))*reweight(pitt_1(subset_I{best_SS_I},t)))';
	bhat.best_subset_ew(t,:) = mean(squeeze(bhat.full(:,t,subset_I{best_SS_I_ew})),2)';
end;

%% ------------------------------------------------------------------------------------------------
% Real Out-of-sample (oos) forecasts yhat_T+h|T = x_T*beta_T;
% NOTE: No. of OOS forecasts is P-h+1, where P = T-R, T is total sample size, R = No. of in-sample obsl
% -------------------------------------------------------------------------------------------------
% Compute FULL out-of-sample predicted probabilities for all time periods.
piTh_T0		= Pr_hat(pitt,Alpha);			% Rule of thumb, simple forecasting rule, \pi_t|t^alpha/normalistion.

% adjust the size of the x_T regressors set and Prob_pred by dropping the first h observations.
x_TT			= x(R+h:T,:);							% oos x_T (Drop the R in-sample observations)
yTh_T			= y(R+h:T,:);							% oos y_T+h (actual observed) (Drop the R in-sample observations).
% Predicted Probs are KEY KK use updated not predicted probs
piTh_T		= piTh_T0(:,R:T-h);				% oos probs use Rule of Thumb forecasts with alpha piTh_T0(:,R:T-h).)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piTh_T		= pitt(:,R:T-h);					% oos probs use RW forecasts, ie time T values for T+h piTh_T0(:,R:T-h).)
%piTh_T		= pitt(:,R+h:T);					% using FUTURE updated probabilities ie., pi_t|t.
%piTh_T		= piTh_T0(:,R+h:T);				% using forecasted FUTURE updated probabilities ie., pi_t|t.

% storage
% No. of effective OOS observations is then (P-h+1) = (T-R-h+1), where P+R=T, R = No. of IS. 
Noos			= T-R-h+1;		 
beta_TT		= cell(M,1);							% filtered beta coefficients up to time t, ie. b_T|T
yhat_oo		= zeros(M,Noos);					% oos prediced (cut to dimension of oos y_T+h)

% yhat_oo_full = zeros(M,(T-1));		% oos prediced (cut to dimension of oos y_T+h)

% Loop through all possible models to construct oos-forecasts yhat_oo.
for m = 1:M;		% do not use parfor here as it screews up the model orders.
	beta_TT{m}		= beta_tt{m}(:,R:T-h)';
	yhat_oo(m,:)	= sum(x_TT(:,S(m,:)).*beta_TT{m,:},2); % x_T*b_T|T = yhat_T+h|T for each model
	
	% constructs oos forecasts going beyond the y series, thus truely T+h periods into the future
	% to construct model averaged forecasts use trimc(piTh_T0,0,1);
	% yhat_oo_full(m,:)	= sum(trimr(xtt(:,S(m,:)),h,0).*beta{m}(:,1:end-1)',2); % x_T*b_T|T = yhat_T+h|T for each model
end

% -------------------------------------------------------------------------------------------------
% To construct Real Time forecast when we have not observed the variable to be
% forecasted yet yTh_T, to combine the forecasts, simply call the function 
% dma_combine_model_forecasts_funct(0,yhat_oo(:,end),piTh_T(:,end),sumS,subset,fixed_q);
% -------------------------------------------------------------------------------------------------
% Use dma_combine_model_forecasts_funct.m function to construct DMA,DMS,DMQ etc forecasts
[yfit_oo,mse_oo,best_oo,sorts_oo,subset_I_oo] = ...
	dma_combine_model_forecasts_funct(yTh_T,yhat_oo,piTh_T,sumS,subset,fixed_q);

% MSE of the in-sample and out-of-sample fits
mse.in = mse_in;
mse.oo = mse_oo;

% forecasts of in and out-of sample fits
yfit.in = yfit_in;
yfit.oo = yfit_oo;


