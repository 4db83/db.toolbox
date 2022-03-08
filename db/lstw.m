function []= lstw(data_without_dates,VARnames,decimls,unts)
% -------------------------------------------------------------------------------------
% function	lstw() prints in nice format numerical values out with last column names of VAR. 
% call as:	lstw(datamatrix_without_dates).
% or as			lstw(datamatrix_without_dates,decimals,units).
% =====================================================================================
% db (March, 2014).
% -------------------------------------------------------------------------------------

x = data_without_dates;

if_no_dates = 1;
% set default value for truncation lag to L = 
SetDefaultValue(3,'decimls',4);
SetDefaultValue(4,'unts',2);

prnt_format = ['%' num2str(unts) '.' num2str(decimls) 'f'];

xout = num2str(x,[prnt_format '  ']);
xout = [xout repmat(' ',length(xout),3) char(VARnames)];

% 
% if if_no_dates
% 	xout = [num2str(x(:,1:end),[prnt_format '  '])];
% else
% 	xout = [datestr(x(:,1), date_format) repmat('    ',size(x,1),1) num2str(x(:,2:end),[prnt_format '  '])];
% end;
% % return the required string
% strng_data		= xout;
% % varargout{1}	= strng_data;
disp(' ')
disp(xout);

