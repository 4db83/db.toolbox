function [selF] = R2_sel_factors(Y,PCA_factors,nF_max)
% Functions:	R2_sel_factors(Y,PCA_factors,nF_max)
% 
% Computes number of factors based on squared correlations between factors and Yt and then sorts according to 
%	highest to lowest correlations and then loops throught to find corresponding best
%	fitting models based on AIC, AICc and BIC.
%
% db 21.04.2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % R = 120;
% % Y = Yt(2:R);
% % [~,Ft]	= pca(zscore(SWt));   	% SW data 
% % F = Ft(1:R-1,:);
% 

F				= PCA_factors;
[T,NF]	= size(F);

% DEFAULT MAX NUMBER OF FACTORS TO CONSIDER IS THE FULL SET THAT IS PASSED IN.
SetDefaultValue(3,'nF_max',NF);

% COMPUTE THE CORRELATIONS FIRST
corr_yF = abs(corr(Y,F))';
% plot(corr_yF.^2);
corr2		= corr_yF.^2;

% STORAGE ALLOCATION
AIC_i		= nan(nF_max,1);
AICc_i	= nan(nF_max,1);
BIC_i		= nan(nF_max,1);

% SORT THE SQUARED CORRELATIONS
[~,Ic]	= sort(corr2,'descend');

for jj = 1:nF_max
	ols_tmp			= fullols(Y,F(:,Ic(1:jj)));
	AIC_i(jj)		= ols_tmp.aic;
	AICc_i(jj)	= ols_tmp.aicc;
	BIC_i(jj)		= ols_tmp.bic;
end

selF.aic	= Ic(1:find(AIC_i == min(AIC_i )));
selF.aicc = Ic(1:find(AICc_i== min(AICc_i)));
selF.bic	= Ic(1:find(BIC_i == min(BIC_i )));


% % selF.aicc
% % sum(corr2(selF.aicc))
% % 
% % plot(AICc_i)