function varargout = printstruct(X,fmt,displayname)
% Simply call as: printstruct(nameofstructure)
% If you want to change the printing format adjust fmt and if you want a different name to display, 
% change the display name
% 
% ie. printstruct(nameofstructure,%2.3f,'this is')
%
% Function: print output from structure to screen
% db
% --------------------------------------------------------------------------------------------------
SetDefaultValue(2,'fmt','%8.8f');

% get name of input as string
names_str = inputname(1);

% get structure inputs.
m1 = fieldnames(X);
a1 = struct2array(X)';

xout = [ repmat('  ',size(a1)) char(m1) repmat(' :   ',size(a1)) num2str(a1,fmt)];

[Xr,Xc] = size(xout);

C = ' ';
str_out = [repmat(C,1,Xc-size(names_str,2)-1) names_str];


sep(40)
if nargin < 3
	disp(str_out)
else
	disp(displayname)
end

sep(40)
disp(xout)
sep(40)


if nargout > 0
	varargout{1}  = xout;
end	


