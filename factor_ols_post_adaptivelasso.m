function [full_bhat_out,ols_paL,PCA_out] = factor_ols_post_adaptivelasso(y,X,IC_type,US_rec)
% Function: Computes Full vector of OLS post Lasso estimates of the PCA Factors of X (standardised),
%						using Infomration criteria (DEFAULT AICc) to select the number of relevant factors. 
% --------------------------------------------------------------------------------------------------
% INPUTS
%				y		data matrix (Tx1)
%				X		regressor matrix (Txk) EXCLUDING A CONSTANT IN IT. 
% IC_type		Information criteria to be used in the selection of the best model.
%						DEFAULT is AICc small sample correct AIC
% --------------------------------------------------------------------------------------------------
% db.
% created on 26.03.2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(3,'IC_type',1)
SetDefaultValue(4,'US_rec',[])

% size of data
[T,K] = size(X);
% constant for regression
C =	ones(T,1);

% standardise data
XX = zscore(X);

[w_econ,F_econ,eig_econ,expVar_econ,cumR2_econ] = pca_mfe(XX);

% drop all factors with very small eigenvalues
Xfull_factors = [F_econ(:,1:sum(eig_econ > 1e-6))];

% FIND BEST GAMMA VALUES IN ADAPTIVE LASSO FIRST FOR ALL INFO CRI
[best_g]	= gamma_IC_adaptiveLasso(y,Xfull_factors);

if IC_type == 2 
	IC_sel = best_g.aic;
elseif IC_type == 3
	IC_sel = best_g.bic;
else
	IC_sel = best_g.aicc;
end
	
% ADAPTIVE LASSO GIVEN GAMMA AND INFO.CRITERION
IselX_full = IC_adaptiveLasso(y,Xfull_factors,IC_sel);

if IC_type == 2 
	IselX = IselX_full.aic;
elseif IC_type == 3
	IselX = IselX_full.bic;
else
	IselX = IselX_full.aicc;
end

% OLS POST ADAPTIVE LASSO (INCLUDIGN THE CONSTANT TERM IN IT C)
if ~isempty(US_rec)
	ols_paL		= fullols(y,[C Xfull_factors(:,(IselX))],[],[],US_rec);
	bhat_out	= ols_paL.bhat;
else
	ols_paL		= fastols(y,[C Xfull_factors(:,(IselX))]);
	bhat_out	= ols_paL;
end

PCA_out.weights	= w_econ;
PCA_out.factors = F_econ;
PCA_out.eigvals = eig_econ;
PCA_out.expVar	= expVar_econ;
PCA_out.cumR2		= cumR2_econ;

% make space for full sized Bhat output, including space for intercept term
bhat_tmp = zeros(size(Xfull_factors,2),1);

bhat_tmp(find(IselX)) = bhat_out(2:end);

full_bhat_out = [bhat_out(1);bhat_tmp];








































