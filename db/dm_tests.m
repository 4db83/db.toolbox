function [DM,CW,dm_t,cw_t] = dm_tests(y,yhat_1,yhat_2,h,prnt)
%{F: Perform standard DM and CW tests of out-of-sample predictability
%========================================================================================
% Performs the Clark and West (2007) test to compare forecasts from nested models.
%
% INPUT
%
% 	y:     			n-vector of actual values
% 	yhat_1: 		n-vector of forecasts for restricted model
% 	yhat_2: 		n-vector of forecasts for unrestricted model
%
% OUTPUT
%
% MSPE_adjusted = Clark and West (2007) statistic
% p_value       = corresponding p-value
%
% Reference
%
% T.E. Clark and K.D. West (2007). "Approximately Normal Tests
% for Equal Predictive Accuracy in Nested Models." Journal of
% Econometrics 138, 291-311
%========================================================================================
% 	NOTES :   this is a heavily modified version of the Perform_CW.m file of Neeley et al.
%----------------------------------------------------------------------------------------
% Created :		05.08.2013.
% Modified:		21.05.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

% CHECK THAT THE FORECAST HORIZON H = 1; 
SetDefaultValue(4,'h',1);
SetDefaultValue(5,'prnt',0);

% if nargin < 5
% 	if (nargin < 4) || isempty(h)
% 		h = 1;
% 	end;
% 	prnt = 0;																			%	default printint is off.
% end;
T = size(y,1);

% COMPUTE FORECAST ERRORS FOR THE TWO MODELS THAT ARE COMPARED
fe_1        = y - yhat_1;
fe_2        = y - yhat_2;
dm_t				= fe_1.^2 - fe_2.^2;								% standard dm_t variable
adjfctr_t		= (yhat_1 - yhat_2).^2;							% CW adjustment factor see page 294.
cw_t				= dm_t + adjfctr_t;									% cw_t see page 294. 

% SET UP AS A REGRSSION PROBLEM WITH ONLY CONSTANT AS REGRESSOR AS SUGGEST BY CW PAGE 294.
Cnst				= ones(T,1);												% constant

%olscw	= fullols(cw_t,Cnst,[],1)

if h == 1 		% One Step Ahead
	dm_stderr = sqrt(var(dm_t)/T);								% FOR DM using standard se formula
	cw_stderr = sqrt(var(cw_t)/T);								% FOR CW using standard se formula
else % multiple steps ahead (h>1)  USE Long-run VARIANCE computation
	dm_stderr = sqrt(LRV(dm_t)/T);								% FOR DM using LRV with default Bartlet Kernel and Newy West ROT
	cw_stderr = sqrt(LRV(cw_t)/T);								% FOR CW using LRV with default Bartlet Kernel and Newy West ROT
end;

% (STANDARD) DM TEST
dm_hat 			= mean(dm_t);
dm_tstat  	=	dm_hat/dm_stderr;
dm_p_value	= 1-normcdf(dm_tstat,0,1);

% CW TEST
cw_hat 			= mean(cw_t);
cw_tstat  	=	cw_hat/cw_stderr;
cw_p_value	= 1-normcdf(cw_tstat,0,1);

DM.mean			= dm_hat;
DM.stderr		= dm_stderr;
DM.tstat		= dm_tstat;
DM.pval			= dm_p_value;

CW.mean			= cw_hat;
CW.stderr		= cw_stderr;
CW.tstat		= cw_tstat;
CW.pval			= cw_p_value;

if prnt == 1
sep(84)
% % 	prnt1.fmt			= char('%12.6f');
% %  	prnt1.cnames	= char(fieldnames(DM));
% % 	prnt1.rnames	= char('Forecast Test','DM (standard)','CW (DM-Adjs)');
% % 	myprint( [struct2array(DM);struct2array(CW)],prnt1);
	prnt1.fmt			= '%12.6f';
	prnt1.width		= 84;
 	prnt1.cnames	= fieldnames(DM);
	prnt1.rnames	= {'Forecast Test';'DM (standard)';'CW (DM-Adjs)'};
	myprint( [struct2array(DM); ...
						struct2array(CW)],prnt1);
sep(84,'=')
end;

























%% EOF