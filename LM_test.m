function [F, Chi2] = LM_test(olsout_retricted, olsout_unrestricted)
% function: do an LM test of a restricted to unrestricted model.
% OLS on linear model is the linear restricted model (input 1)
% OLS on polynomial regression is the unrestricted non-linear model. 
% 
% Returns structures for the F version (better small sample properties), and the Chi2-version. 
%
% ------------------------------------------------------------------------------------------------------
% Code follows van Dijk et al. (2002) 'STAR Models: A survey of recent developments', Econometric Reviews
% on page 13. 
% db (01.08.2017).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% remap the input models
lin		= olsout_retricted;
poly3 = olsout_unrestricted;

No_restrictsions	= poly3.k - lin.k;
unrestricted_DF		= poly3.DF;

% Chi2 version of LM_3 test
Chi2.stat	= lin.N*(lin.sse - poly3.sse)/lin.sse;
Chi2.pval	= chi2cdf(Chi2.stat, No_restrictsions, 'upper');
% [Chi2_lm3 chi2_pval]

F.stat	= (lin.sse - poly3.sse)/poly3.sse * (unrestricted_DF / No_restrictsions);
F.pval	= fcdf(F.stat, No_restrictsions, unrestricted_DF,'upper');

% [F_lm3 F_pval]


end
