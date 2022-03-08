function [cw_mu,cw_stderr,cw_tstat,cw_pval] = clarkwest_test(y,CW,h); 
%{F: Performs standard CW or DM tests of out-of-sample predictability
% INPUT EITHER A CW OR DM SEQUENCE TO BE PASSED IN
%========================================================================================
% Performs the Clark and West (2007) test to compare forecasts from nested models.
%
% INPUT
%
% 	y:     			n-vector of actual out-of-sample values
%		CW:					STRUCTURE OF CW SEQUENCES.
%		h:					forecast horizon that is considerd
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
% 	NOTES :   this is a modified version of the dm_tests.m function that I wrote
%							here the input is a CW structure, ie. with CW.rw CW.model1 CW.model2 etc. 
%							where the CW sequence is: e1^2 - e2^2 + (yhat1 - yhat2).^2
%----------------------------------------------------------------------------------------
% Created :		05.08.2013.
% Modified:		21.05.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

% prepare output.
T				= size(y,1);
fnames	= fieldnames(CW);

for i = 1:length(fnames)
	check0 = getfield(CW,fnames{i});
	
	% check if the entry has only zeros in it. 
	if (sum(check0==0)==T)
		cw_mu.(fnames{i})			= nan;
		cw_stderr.(fnames{i})	= nan;
		cw_tstat.(fnames{i})	= nan;
		cw_pval.(fnames{i})		= nan;
	else
		
		mu_tmp			= mean(CW.(fnames{i}));
		stderr_tmp	= sqrt(var(CW.(fnames{i}))/T);
	
		% for forecast horizons bigger than 1 step ahead, use LRVwithPrewhitening
		if h > 1;
			stderr_tmp	= sqrt(LRVwPW(CW.(fnames{i}))/T);
		end;
		
		tstat_tmp		= mu_tmp/stderr_tmp;
		pvalue_tmp	= 1 - normcdf(tstat_tmp,0,1);
		
		% compute in structure again
		cw_mu.(fnames{i})			= mu_tmp;
		cw_stderr.(fnames{i})	= stderr_tmp;
		cw_tstat.(fnames{i})	= tstat_tmp;
		cw_pval.(fnames{i})		= pvalue_tmp;
	end;
end;


