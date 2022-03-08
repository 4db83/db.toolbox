function [] = printfts2xls(fts_object,dirname,xlsname,datefrmat)
% Call as:	printfts2xls(fts_object,dirname,xlsname,datefrmat)
% --------------------------------------------------------------------------------------------------
% function: prints financial times series object to xls.

% default output name if not supplied
xls_outname = inputname(1);

% other default values
% SetDefaultValue(2,'dirname'			,xls_outname);
SetDefaultValue(3,'xlsname'			,xls_outname);
SetDefaultValue(4,'datefrmat'		,'dd-mmm-yyyy');

if nargin < 2
	xlsname_out = xlsname;
else
	% output name including the directory of interest
	xlsname_out = [dirname './' xlsname];
end

names_0 = fieldnames(fts_object);
names		= [{'dates'};names_0(3:end)];
%%
matx		= fts2mat(fts_object);
dates		= fts_object.dates;

% xlswrite(xls_out_name,cellstr(prntstrng2xls(strng)),'Sheet1','A2');
date_as_strng = datestr(dates,datefrmat);

%% now write to file
xlswrite(xlsname_out,cellstr(names')											,'Sheet1','A1');
xlswrite(xlsname_out,cellstr(prntstrng2xls(date_as_strng)),'Sheet1','A2');
xlswrite(xlsname_out,m2xdate(dates)												,'Sheet1','B2');	% excel format date
xlswrite(xlsname_out,matx																	,'Sheet1','C2');
