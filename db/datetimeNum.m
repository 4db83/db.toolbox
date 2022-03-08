function datetime_output = datetimeNum(date_num_input)
% faster call conversion between most common datenum conversions to datetime. 
% here we can use a datenum vector of dates as inputs and create a datetime vector for the
% timetable class without the minute hour sec time stame. So
% INPUT:	date_num
% OUTPUT: datetime_Rowtimes 
% ---------------------------------------------------------------------------------------------
% NOTE: 
%	datestr uses dd-mmm-yyyy (or dd-mm-yyyy) to convert dates of the form '01-Jun-2016' to
%	datenum. If MM (or MMM) is used instead, it will throw and error as it thinks its minutes. 
% datetime uses the format dd-MMM-yyy for Month, while mmm would be for miuntes, so the other
% way around. PAY ATTENTION HERE.

datetime_output = datetime( datestr( date_num_input ) ,'InputFormat','dd-MMM-yyyy' ) ;