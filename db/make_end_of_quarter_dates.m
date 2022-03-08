function dates_eoq = make_end_of_quarter_dates(dates_in, last_quarter)
% FUNCTION: converts quarter dates to end of quarter from beginning of quarter
% ------------------------------------------------------------------------------------------------------
% CALL AS:
%			dates_eoq = make_end_of_quarter_dates(dates_in, last_quarter);
% ------------------------------------------------------------------------------------------------------
% INPUT: 
% dates_in			= datenum of dates into the function
% last_quarter	= last_quarter of the dates_in datestring, ie. 1, 2, 3 or 4. This is needed so that the 
%									last quarter is appropriately added to the series.
%									If not supplied, taken from the last quarter from the dates_in vector.
% 
% OUTPUT:
% dates_eoq			= datenum vector of quarterly dates that has converted from FRED 01-Jan-2000 (2000:Q1)
%									date format to the more common 31-Mar-2000 (2000:Q1) date format. 
% ------------------------------------------------------------------------------------------------------
% db (21.02.2018)
% ------------------------------------------------------------------------------------------------------

% END OF QUARTER DATES (THIS SHIFTS BY ONE DAY BACK)
dates_eoq_tmp = dates_in - 1;

% getting a default values if last_quarter is not supplied. 
quarter_tmp = datestr(dates_in(end),'qq');
quarter			= str2double(quarter_tmp(2));

% setting the default value
SetDefaultValue(2,'last_quarter',quarter)

switch(last_quarter)
	case 1
		month = '31-Mar';
	case 2 
		month = '30-Jun';
	case 3
		month = '30-Sep';
	case 4 
		month = '31-Dec';
end

% the very last entry only
last_eoq_entry	= (datenum([month datestr(dates_in(end),'yyyy')]));
% return value is the combined value
dates_eoq				= [dates_eoq_tmp(2:end); last_eoq_entry];

