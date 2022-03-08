function [Iselx,bhat_lasso,Xsel,misc_out] = IC_Lasso(y,X,plot_on)
% Function. Finds Information criteria based 'BEST LAMBDA' value by either 
% Using AIC, AICc, or BIC.
% INPUT 
% 	y				: dependent data series (does NOT need to be demeaned)
% 	X				: regressors, DO NOT INCLUDE CONSTANT, (do NOT need to be standardised)
% 	gamma_	:	gamma parameter in adaptiveLasso function. Default is 1, but
% 						could be set to values such as [.5 to 2] as suggeste & done in Zou.
% 	plot_on	:	indicator, if = 1 plots the AIC, BICs etc for different lambda values.
% 
% OUTPUT
 
% 
% db 19.03.2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(3,'plot_on',0);

[T,Fk]	= size(X);
% do temp Lasso to get max Lambda value
[~,aout_tmp]	= lasso(X,y);
max_lambda		= max(aout_tmp.Lambda);

% now do the lasso on a finer lambda grid with max_lambda as upper bound
lambda				= linspace(0,max_lambda,1e3)';
[bhatL, outL] = lasso(X,y,'Lambda',lambda);

% number of non-zero LASSO parameter estimates
K			= sum(bhatL'~=0,2);
K0		= sum(K~=0);
bhat0	= bhatL(:,1:K0)';

% LASSO INFO CRITERIA BASED ON ZOU ET AL. (2007,Annals)
mseL = outL.MSE'./outL.MSE(1);
lasso_aic0	= T*(mseL)		+ 2*K;
lasso_bic0	= T*(mseL)		+ K*log(T);
lasso_aicc0	= lasso_aic0	+ 2*K.*(K+1)./(T-K-1);

% trim out those entries that correspond to a constant only model
lasso_aic		= lasso_aic0(1:K0);
lasso_bic		= lasso_bic0(1:K0);
lasso_aicc	= lasso_aicc0(1:K0);
lambda_out	= outL.Lambda(1:K0)';

% store the full info criteria function
full_IC.aic 		= lasso_aic;
full_IC.bic 		= lasso_bic;
full_IC.aicc 		= lasso_aicc;
full_IC.lambda 	= lambda_out;

% strore the minimum values of the IC
min_IC.aic	=  min(lasso_aic) ; 
min_IC.bic  =  min(lasso_bic) ; 
min_IC.aicc =  min(lasso_aicc);

% find minimum info criteria values
Imin.aic		= find(lasso_aic	== min_IC.aic	);
Imin.bic		= find(lasso_bic	== min_IC.bic );
Imin.aicc		= find(lasso_aicc == min_IC.aicc);

% minimum lambdas are:
lambda_min.aic	= lambda_out(Imin.aic);
lambda_min.bic	= lambda_out(Imin.bic);
lambda_min.aicc = lambda_out(Imin.aicc);

if plot_on
	% plotting of the ICs to figure what Lambda to use.
	plot(lambda_out,lasso_aic ,'b');hold on;
	plot(lambda_out,lasso_bic ,'r');
	plot(lambda_out,lasso_aicc,'g');
	Leg(1) = vline(lambda_min.aic ,'b--');
	Leg(2) = vline(lambda_min.bic ,'r--');
	Leg(3) = vline(lambda_min.aicc,'g--');
	xlim([0 max_lambda]);
	legend(Leg,'Min(AIC)','Min(BIC)','Min(AICc)');
	hold off;
end;

% bhat Lasso at IC optimised lambda values
bhat_lasso.aic	= bhat0(Imin.aic,:)';
bhat_lasso.bic	= bhat0(Imin.bic,:)';
bhat_lasso.aicc = bhat0(Imin.aicc,:)';

% indicators to extrac non-zero Lasso coefficients
Iselx.aic				=	bhat_lasso.aic	~= 0;
Iselx.bic				= bhat_lasso.bic	~= 0;
Iselx.aicc			= bhat_lasso.aicc ~= 0;

% which regressors are selected
Xsel.aic				= find(Iselx.aic);
Xsel.bic				= find(Iselx.bic);
Xsel.aicc				= find(Iselx.aicc);

% store all other values in structure file
misc_out.infoL			= outL;
misc_out.min_IC			= min_IC;
misc_out.lambda_min = lambda_min;
misc_out.full_IC		= full_IC;















%EOF
