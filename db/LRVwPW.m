function [LRV_AR1_pw_QS_AR1_rule,			LRV_AR1_pw_full, ... 
					LRV_ARMA11_pw_QS_AR1_rule,	LRV_ARMA11_pw_full,		uhat] = LRVwPW(X,c,p,q)
%{F: Computes the Long-Run Variance (LRV) with a PRE-WHITENED vector X. USES AR(1) AS PRE-WHITENING 
%		 model as the default and the QS AR(1) data driven bandwidth of Andrews to select the truncation
%		 lag.
% INPUTS: 	
%						X: 	(Tx1) series whose long-run variance is needed.
%						c: 	scalar, = 1 if constant is to be included, 0 otherwise.
%						p:	scalar, AR(p) order, default is 1.
%						q:	scalar, MA(q) order, default is 1.
% OUTPUTS: 		
%			LRV_AR1_pw_QS_AR1_rule:
%					scalar, long-run variance with AR(1) pre-whitening and QS with data driven bandwidth of
%					Andrews using an AR(1) as approximating model for QS kernel based residuals.
% 
%			LRV_AR1_pw_full:
%					Give the corresponding full results for all possible data driven bandwidht, including the
%					rule of thumb for QS and Bartlet kernels
% ---------------------------------------------------------------------------------------
%			LRV_ARMA11_pw_QS_AR1_rule: 
%					scalar, long-run variance with ARMA(1,1) pre-whitening and QS with data driven bandwidth of
%					Andrews using an ARMA(1,1) as approximating model for QS kernel based residuals.
%			LRV_ARMA11_pw_full:
%					Give the corresponding full results for all possible data driven bandwidht, including the
%					rule of thumb for QS and Bartlet kernels
% ---------------------------------------------------------------------------------------
%			HAVE TO BE CAREFUL HERE WHEN FITTING ARMA(1,1) MODELS AS THERE CAN
%			BE A ROOT CANCELLATION PROBLEM IN THE AR AND MA TERMS WHICH MAY RENDER THE ESTIMATES HIGHLY
%			UNRELIABLE AND THUS ALSO WHEN 'RECOLOURING' WHEN TAKING THE B(L)/A(L) RATIOS.
% ---------------------------------------------------------------------------------------
%			uhat:
%					Returns the residuals (ie., the prewhitened series from the ARMA(1,1) and AR(1) regressions)
% ---------------------------------------------------------------------------------------
% DEFAULT PRE-WHITENIGN MODEL IS AN ARMA(1,1) WHICH SEEMS TO WORK WELL IN PRACTICE EVEN IF 
% TRUE DGP IS SOMETHING ELSE.
%========================================================================================
% 	NOTES :   	see also Matlabs HAC.m function. DOES ONLY Univariate MODELS.
%========================================================================================
% Created :		 	02.07.2014.
% Modified:		 	06.11.2015.
% Copyleft:		 	Daniel Buncic.
%----------------------------------------------------------------------------------------%}

% SPECIFY DEFAUL VALUES
SetDefaultValue(2,'c', 1);
SetDefaultValue(3,'p', 1);
SetDefaultValue(4,'q', 1);
% ---------------------------------------------------------------------------------------

if p == 0;
	pL = [];
else
	pL = 1:p;
end;
if q == 0;
	qL = [];
else
	qL = 1:q;
end;

% ---------------------------------------------------------------------------------------

% fit specific arma model to X and then compute LRV on fitted residuals uhat
% default is ARMA(1,1) with intercept because default values for c,p,q are 1 above.
[arma11_p,~,uhat_arma11] = armax_est(X,c,pL,qL);
% LRV OF PRE-WHITENED SERIES
[~,LRV_all_arma11_pw]	= LRV(uhat_arma11);
aL					= [1 -arma11_p((c+1):p+c)'  ];
bL					= [1  arma11_p((c+1+p):end)'];
%	RECOLOR AGAIN TO COMPUTE LRV
LRV_hat_arma11_pw			= struct2array(LRV_all_arma11_pw).*(sum(bL)/sum(aL))^2;
% ---------------------------------------------------------------------------------------

% ---------------------------------------------------------------------------------------
% NOW USE AR(1) with intercept AS THE PRE-WHITENING MODEL
[ar1_p,~,uhat_ar1]	= armax_est(X,c,pL,0);
% LRV OF PRE-WHITENED SERIES
[~,LRV_all_ar1_pw]	= LRV(uhat_ar1);
aL	= [1 -ar1_p((c+1):p+c)'  ];
%	RECOLOR AGAIN TO COMPUTE LRV
LRV_hat_ar1_pw			= struct2array(LRV_all_ar1_pw).*(1/sum(aL))^2;

% ---------------------------------------------------------------------------------------
% store the residuals from the ARMA models, which are used as the pre-whitened series.
uhat.arma11 = uhat_arma11;
uhat.ar1		= uhat_ar1;

% SEND TO OUTPUT STRUCTURE FOR ARMA11-PRE-WHITENED RESULTS WITH ALL ANDREWS BASED DATA DRIVEN
% TRUNCATION LAGS
LRV_ARMA11_pw_full.QS_ar1			= LRV_hat_arma11_pw(1);
LRV_ARMA11_pw_full.QS_arma11	= LRV_hat_arma11_pw(2);
LRV_ARMA11_pw_full.QS_RoT			= LRV_hat_arma11_pw(3);
LRV_ARMA11_pw_full.B_ar1			= LRV_hat_arma11_pw(4);
LRV_ARMA11_pw_full.B_arma11		= LRV_hat_arma11_pw(5);
LRV_ARMA11_pw_full.B_RoT			= LRV_hat_arma11_pw(6);
% ---------------------------------------------------------------------------------------
% ONLY FOR QS AR(1) DATA DRIVEN TRUNCATION LAG.
LRV_ARMA11_pw_QS_AR1_rule			= LRV_ARMA11_pw_full.QS_ar1;

% SEND TO OUTPUT STRUCTURE FOR ARMA11-PRE-WHITENED RESULTS WITH ALL ANDREWS BASED DATA DRIVEN
% TRUNCATION LAGS
LRV_AR1_pw_full.QS_ar1				= LRV_hat_ar1_pw(1);
LRV_AR1_pw_full.QS_arma11			= LRV_hat_ar1_pw(2);
LRV_AR1_pw_full.QS_RoT				= LRV_hat_ar1_pw(3);
LRV_AR1_pw_full.B_ar1					= LRV_hat_ar1_pw(4);
LRV_AR1_pw_full.B_arma11			= LRV_hat_ar1_pw(5);
LRV_AR1_pw_full.B_RoT					= LRV_hat_ar1_pw(6);
% ---------------------------------------------------------------------------------------
% ONLY FOR QS AR(1) DATA DRIVEN TRUNCATION LAG.
LRV_AR1_pw_QS_AR1_rule				= LRV_AR1_pw_full.QS_ar1;


