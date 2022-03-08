function [IselX,bhat_lasso,misc_out] = adaptiveLasso_lambda_IC(y,X,gamma_,N_lambda,plot_on)
% Function. Finds Information criteria based 'BEST LAMBDA' value by either 
% Using AIC, AICc, or BIC. and stores all intermediate results.
% NOTE:		It automatically recenters y and standardizes X.
% --------------------------------------------------------------------------------------------
% INPUT 
% 	y				: dependent data series (does NOT need to be demeaned)
% 	X				: regressors, DO NOT INCLUDE CONSTANT, (do NOT need to be standardised)
% 	gamma_	:	gamma parameter in adaptiveLasso function. Default is 1, but
% 						could be set to values such as [.5 to 2] as suggeste & done in Zou.
%		N_lambda:	Number of Lambda grid points to use in the search for best Lambda. Default 100.
% 	plot_on	:	indicator, if = 1 plots the AIC, BICs etc for different lambda values.
% 
% OUTPUT
%		Iselx		: Indicator, with 1 for all those regressors (excluding constant of course) that are
%							select by adaptiveLasso.
% bhat_lasso: beta parameter estimates from Lasso procedure (will need to add standard errors later)
%	misc_out	: collection of ouputs of all parts that are computed, inlcuding MSEs as well as full
%							set of Lambda and MSE,BIC,AIC mappings.
% --------------------------------------------------------------------------------------------
% db 
%	created		: 19.03.2015
% modfified :	28.03.2015.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(3,'gamma_'		,1);
SetDefaultValue(4,'N_lambda'	,1e2);
SetDefaultValue(5,'plot_on'		,0);

[T,Fk]	= size(X);
% do temp adaptiveLasso to get max Lambda value
[bhatL, outL]	= adaptiveLasso(y,X,[],gamma_);
max_lambda		= max(outL.Lambda);

% If Lambda grid is too coarse, do the lasso on a finer lambda grid with max_lambda as upper bound
if N_lambda > 1e2;
	lambda				= linspace(0,max_lambda,N_lambda)';
	[bhatL, outL] = adaptiveLasso(y,X,lambda,gamma_);
end;

% number of non-zero LASSO parameter estimates
K			= sum(bhatL'~=0,2);
K0		= sum(K~=0);
bhat0	= bhatL(:,1:K0)';

% LASSO INFO CRITERIA BASED ON ZOU ET AL. (2007,Annals)
mseL				= outL.MSE'./outL.MSE(1);
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

% store the minimum values of the IC
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
	plot(lambda_out,lasso_aic ,'g');hold on;
	plot(lambda_out,lasso_bic ,'r');
	plot(lambda_out,lasso_aicc,'b:');
	Leg(1) = vline(lambda_min.aic ,'g-');
	Leg(2) = vline(lambda_min.bic ,'r--');
	Leg(3) = vline(lambda_min.aicc,'b:');
	xlim([0 max_lambda]);
	legend(Leg,'Min(AIC)','Min(BIC)','Min(AICc)');
	hold off;
end;

% bhat Lasso at IC optimised lambda values
bhat_lasso.aic	= bhat0(Imin.aic,:)';
bhat_lasso.bic	= bhat0(Imin.bic,:)';
bhat_lasso.aicc = bhat0(Imin.aicc,:)';

% indicators to extrac non-zero Lasso coefficients
IselX.aic				=	bhat_lasso.aic	~= 0;
IselX.bic				= bhat_lasso.bic	~= 0;
IselX.aicc			= bhat_lasso.aicc ~= 0;

% % which regressors are selected (REDUNDENT DO NOT PARSE OUT ANYMORE)
% Xsel.aic				= find(Iselx.aic);
% Xsel.bic				= find(Iselx.bic);
% Xsel.aicc				= find(Iselx.aicc);

% store all other values in structure file
misc_out.infoL			= outL;
misc_out.min_IC			= min_IC;
misc_out.lambda_min = lambda_min;
misc_out.full_IC		= full_IC;















%EOF
