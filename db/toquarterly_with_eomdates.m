function fts_quarterly = toquarterly_with_eomdates(ftsa, varargin)
% convert to quarterly frequency with end of month dates

% call to normal toquarterly function. 
fts_tmp = toquarterly(ftsa, varargin{:});

% now convert to end of month dates of the months corresponding to the quarters. 
eom_dates				= eomdate(fts_tmp.dates);
var_names_tmp		= fieldnames(fts_tmp);
var_names				= var_names_tmp(4:end);

fts_quarterly		= fints(eom_dates,fts2mat(fts_tmp),var_names);

