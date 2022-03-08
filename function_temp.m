function x_ma = ma_filter1(x,n)
%{F: Does DMS/DSM for a given set of Alpha,Lambda/Kappa parameters.
%========================================================================================
% This is a much faster/simpler implementation of the original Koop and Korobilis code
% that does a time varying parameter state-space model with variable selecton at the same
% time. 
%----------------------------------------------------------------------------------------
% 	USGAGE		[yfit, mse, bhat, pips, xnames, S] = dms_dma(y,x,Alpha,Lambda,Kappa,drop_constant_only_model,no_constant,timer_on)
%---------------------------------------------------------------------------------------
% 	INPUT  
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
% 	OUTPUT       
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


strx    = [repmat('''',size(strng,1),1) strng];
strout  = cellstr(strx);