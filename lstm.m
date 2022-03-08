function [varargout]= lstm(data_with_dates,decimls,unts,date_format)
% monthly date vector printed nicely
% -------------------------------------------------------------------------------------
% function lstm() returns a string from a numeric data with possibly dates in the first
% column, to make it possible to print dates and numbers side by side, and to have neat
% printing of numeric data with different magnituteds.
% -------------------------------------------------------------------------------------
% 					USAGE:	lst(data_with_dates,decimls,date_format)
% 				CALL AS:  lst([datesvector in datenum format xdata])
% -------------------------------------------------------------------------------------
%  EXTRA CONTROLS:	prnt_format = string, specifies string printing format for numbers.
% 									if_no_dates = indicator, if = 1, then no dates in first colmun of data.
% =====================================================================================
% db (March, 2018).
% -------------------------------------------------------------------------------------

x = data_with_dates;


% set default value for truncation lag to L = 
% SetDefaultValue(2,'if_no_dates',0);
% SetDefaultValue(3,'prnt_format','%14.14f');
SetDefaultValue(2,'decimls',6);
SetDefaultValue(3,'unts',4);
SetDefaultValue(4,'date_format','mmm-yyyy');

prnt_format = ['%' num2str(unts) '.' num2str(decimls) 'f'];

% % if nargin < 2
% % 	if_no_dates = 0;
% % 	prnt_format = '%6.6f';
% % end;
% % 
% % if nargin < 3
% % 	prnt_format = '%6.6f';
% % end;

xout = [datestr(x(:,1), date_format) repmat('    ',size(x,1),1) num2str(x(:,2:end),[prnt_format '  '])];

% return the required string
strng_data		= xout;
% varargout{1}	= strng_data;
if nargout == 0
	disp(strng_data);
else
	varargout{1} = strng_data;
end;

