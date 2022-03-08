function [] = print2xls(matx,xlsname,VarNameString,isDateinC1,datefrmat)
% Call as:	print2xls(matx,xlsname,VarNameString,isDateinC1,datefrmat)
% --------------------------------------------------------------------------------------------------
% function: print matrix with dates in first column to xls in appropriate format.
% INPUT:	
% 		matx						= TxN matrix with first entry containing date as datenum.
% 		xlsname					= string with .xls as aoutput name.
% 		VarNameString		= variables names as strigns {'aa','BB',etc}. 
% 		isDateinC1			= indicator, if 0, then no date in column 1, default 0.
% 		datefrmat				= string of date format, default is 'dd.mm.yyyy'.
% --------------------------------------------------------------------------------------------------
% db
% --------------------------------------------------------------------------------------------------

xls_outname = inputname(1);

SetDefaultValue(2,'xlsname'				,xls_outname)
SetDefaultValue(3,'VarNameString'	,[])
SetDefaultValue(4,'isDateinC1'		,0)
SetDefaultValue(5,'datefrmat'			,0);
% SetDefaultValue(5,'datefrmat'			,'dd-mmm-yyyy');

% mod the format of the date string showing
if ~isstring(datefrmat)
	if datefrmat == 0;				datefrmat = 'dd.mm.yyyy';
		elseif	datefrmat == 1; datefrmat = 'mmm-yyyy';
		elseif	datefrmat == 2; datefrmat = 'yyyy:QQ'; 
		elseif	datefrmat == 3; datefrmat = 'dd-mm-yyyy';
	end
end

if istimetable(matx)
		% variable names
		fldnams			= matx.Properties.VariableNames;
		% data matrix
		data2write	= matx.Variables;
		% dates
		date_strng	= datestr(matx.Properties.RowTimes,datefrmat);
		% now write to excel
 		xlswrite(xlsname,['dates', fldnams],				'Sheet1','A1');		% variable names
		xlswrite(xlsname,prntstrng2xls(date_strng),	'Sheet1','A2');		% print dates as string
		xlswrite(xlsname,data2write,								'Sheet1','B2');		% data
	else

	% IF THE INPUT IS THE STANDARD DATA STRUCTURE THAT I USE
	if isstruct(matx)||isa(matx,'fints')
		fldnams		= fieldnames(matx);
		fld_data	= fldnams(find(strcmp(fldnams,'data')));
		fld_dates	= fldnams(find(strcmp(fldnams,'dates')));
		% call to lstd with dates function
		date_strng	= datestr(matx.(char(fld_dates)),datefrmat);
		% lstd([x.(char(fld_dates)) x.(char(fld_data))],[],prnt_format);
		if isa(matx,'fints')
			xlswrite(xlsname,cellstr(prntstrng2xls(fldnams(4:end)')),'Sheet1','A1');	% variable names
			xlswrite(xlsname,cellstr(prntstrng2xls(date_strng)),'Sheet1','A2');				% print dates as string
			xlswrite(xlsname,fts2mat(matx),'Sheet1','B2');														% data
		else
			xlswrite(xlsname,cellstr(prntstrng2xls(matx.names')),'Sheet1','A1');
			xlswrite(xlsname,cellstr(prntstrng2xls(date_strng)),'Sheet1','A2');
			xlswrite(xlsname,matx.(char(fld_data)),'Sheet1','B2');
		end
	else 

		% xlswrite(xls_out_name,cellstr(prntstrng2xls(strng)),'Sheet1','A2');
		date_as_strng = datestr(matx(:,1),datefrmat);
		[T,K] = size(matx);

		if isempty(VarNameString); VarNameString = repmat(' ',K,1); end
		% if isempty(VarNameString); VarNameString = cell(K,1); end;

		% adjust to correct dimension for printing to xls.
		[Nr,Nc] = size(VarNameString);
		if Nr < Nc
			VarNameString = VarNameString';
		end

		if isDateinC1==1
			xlswrite(xlsname,cellstr(prntstrng2xls(VarNameString')),'Sheet1','A1');
			xlswrite(xlsname,cellstr(prntstrng2xls(date_as_strng)),'Sheet1','A2');
			xlswrite(xlsname,matx(:,2:end),'Sheet1','B2');
			xlswrite(xlsname,{'Dates'},'Sheet1','A1');
		else
% 			xlswrite(xlsname,cellstr(prntstrng2xls(VarNameString')),'Sheet1','A1');
			xlswrite(xlsname,cellstr(VarNameString'),'Sheet1','A1');
			xlswrite(xlsname,matx,'Sheet1','A2');
		end

	end

end



