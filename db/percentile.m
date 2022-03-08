function pct_x = percentile(x,p)
% FUNCTION: computes the percentils of X. 
% ---------------------------------------------------------------------------------------------------------
%   Examples:
%      pct_x = prctile(x,50); % the median of x
%      pct_x = prctile(x,[2.5 25 50 75 97.5]); % a useful summary of x
% ---------------------------------------------------------------------------------------------------------  
% wrapper to MATLAB prctile file to also be able to input fintial time series objects. 
% ---------------------------------------------------------------------------------------------------------

% check if we are inputing numbers
if ~isnumeric(x)
	% now check if it is a fints ojbect
	if strcmp(class(x),'fints')
		% make a double mat out of it
		xdat		= fts2mat(x);
		xnames	= fieldnames(x);
	else
		dips('in put x is some other class that cannot be processed');
	end;
else
	% else just use x as xdat
	xdat	= x;
end;
% now compute the percentiles
pct_x = prctile(xdat,p);

% FTS = fints(DATES, DATA, DATANAMES, FREQ, DESC) and


end
	
