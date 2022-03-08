function [] = myprint2xls(xlsoutname,matx,RowNames,ColNames)

if nargin < 4
	ColNames = {''};
end;

% print matx to xlsoutname file with fidin rnames and colnames

if isstruct(RowNames)
	myprint2xls_struct(xlsoutname,matx,RowNames)
else
	fidin.rnames = RowNames;
	fidin.cnames = ColNames;
	myprint2xls_struct(xlsoutname,matx,fidin)
% 	mxout = [cellstr(fidin.rnames) [cellstr(fidin.cnames)'; num2cell(matx)]];
% 
% xlswrite(xlsoutname,mxout)	
end;

end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call to subfunction
function [] = myprint2xls_struct(xlsoutname,matx,fidin)
% print matx to xlsoutname file with fidin rnames and colnames

CNAMES0 = cellstr(fidin.cnames);
[NR,NC] = size(CNAMES0);

% check the dimension of it so that it prints properly
if NC > NR 
	CNAMES = CNAMES0;
else
	CNAMES = CNAMES0';
end;

tmp1 = [CNAMES; num2cell(matx)];

if length(fidin.rnames) >= size(tmp1,1)
	tmp2 = cellstr(fidin.rnames);
else
	tmp2 = ['{Variable}';cellstr(fidin.rnames)];
end

% mxout = [cellstr(fidin.rnames) [cellstr(fidin.cnames)'; num2cell(matx)]];

mxout = [tmp2 tmp1];
xlswrite(xlsoutname,mxout)	

end