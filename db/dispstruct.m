function [] = dispstruct(xstr,fmmt)

% print structure entries to screen
% print structure entries to screen
x_mat = struct2mat(xstr)';
[T,k]	= size(x_mat);

if nargin < 2
	fmmt = '%14.6f';
end;

if k == 1
	myp.rnames	= char('Entry', char(fieldnames(xstr)));			
	myp.cnames	= char('Xmat');
	myp.fmt			= fmmt;
	myprint(x_mat,myp);
else
	myp.cnames	= char(char(fieldnames(xstr)));			
%	myp.rnames	= char('Entry', 'Xmat');
	myp.fmt			= fmmt;
	myprint(x_mat',myp);
end
