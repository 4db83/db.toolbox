function [best_gamma,gamma_grid] = gamma_IC_adaptiveLasso(y,X,gamma_grid,plot_on)
% Function. Finds the best gamma value to be used in AdaptiveLasso IC function, based on info from
%						OLS POST ADAPTIVE LASSO REGRESSIONS.
% --------------------------------------------------------------------------------------------
% INPUT 
% 	y						: dependent data series (does NOT need to be demeaned)
% 	X						: regressors, DO NOT INCLUDE CONSTANT, (do NOT need to be standardised)
% 	gamma_gird	:	grid of gamma values to search over
%									could be set to values such as [.5 to 2] as suggeste & done in Zou.
% 	plot_on			:	indicator, if = 1 plots the AIC, BICs etc for different lambda values.
% 
% OUTPUT
%  best_gamma		: structure, best gamma values for different information criteria.
% ------------------ -------------------------------------------------------------------------
% db 19.03.2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(3,'gamma_grid',[]);
SetDefaultValue(4,'plot_on'		,0);

% C	= ones(size(y));									% constant/intercept term.

if isempty(gamma_grid)
	gmma = [0:.1:2]';
else
	gmma = gamma_grid;
end;

aic_min = zeros(size(gmma));
parfor i = 1:length(gmma)
	[bhat_AL]			= IC_adaptiveLasso(y,X,gmma(i),plot_on)
	% OLS POST ADAPTIVE LASSO (CONSTANT AUTOMATICALLY INCLUDED BY DEFAULT)
	ols_paL_aicc	= fullols(y,X(:,(bhat_AL.aicc)));
	ols_paL_aic		= fullols(y,X(:,(bhat_AL.aic )));
	ols_paL_bic		=	fullols(y,X(:,(bhat_AL.bic )));
	%store the IC values
	aicc_min(i)		= ols_paL_aicc.aicc;
	aic_min(i)		= ols_paL_aic.aic;
	bic_min(i)		= ols_paL_bic.bic;
end

if plot_on;
	plot(gmma,aicc_min);
	hold on;
	plot(gmma,aic_min,'r');
	plot(gmma,bic_min,'k--');
	hold off;
	legend('AICc','AIC','BIC')
end;


best_gamma.aicc = max(gmma((min(aicc_min) == aicc_min))); % use the biggest entry if returns multiple 
best_gamma.aic	= max(gmma((min(aic_min)  == aic_min ))); % use the biggest entry if returns multiple 
best_gamma.bic	= max(gmma((min(bic_min)  == bic_min ))); % use the biggest entry if returns multiple 

%gmma_aicc = gmma(find(min(aicc_min)==aicc_min));