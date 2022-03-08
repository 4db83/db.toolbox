function [] = prntlst(data_with_dates_in_first_colmn,xls_out_name,date_format)
% prints matrix with [dates data] to excel file with name xls_out_name.
% dates is in datenum format. Date formatting is 
%			Call as:	prntlst(data,'xout.xls','date_format')
%
%			last two arguments are optional.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(2, 'xls_out_name'	, 'aout.xls');
SetDefaultValue(3, 'date_format'	, 'dd.mm.yyyy');

date_strn = datestr(data_with_dates_in_first_colmn(:,1), date_format);

xlswrite(xls_out_name,cellstr(prntstrng2xls(date_strn))				,'Sheet1','A1');
xlswrite(xls_out_name,data_with_dates_in_first_colmn(:,2:end)	,'Sheet1','B1');

