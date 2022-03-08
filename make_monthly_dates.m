function m_dates = make_monthly_dates(beg_Year,beg_Month,end_Year,end_Month)
% ------------------------------------------------------------------------------------------------------
% FUNCTION: makes a monthly date vector.
% ------------------------------------------------------------------------------------------------------
% CALL AS: 
%			m_dates = make_monthly_dates(beg_Year,beg_Month,end_Year,end_Month)
% ------------------------------------------------------------------------------------------------------
% INPUT: 
% beg_Year			= beginning year as number, ie. 1947.
% beg_Quarter		= beginning month as number, ie., 3.
% end_Year			= beginning year as number, ie. 2010.
% end_Quarter		= beginning month as number, ie., 11.
% 
% OUTPUT:
% m_dates				= a monthly date vector, that is:
%									M1 = 1st January
%									M2 = 1st February. etc.
% ------------------------------------------------------------------------------------------------------
% db (01.03.2018)
% ------------------------------------------------------------------------------------------------------

% make the monthly date vector
dates_tmp = bsxfun(@(Month,Year) datenum(Year,Month,1),(1:1:12).',beg_Year:end_Year);
m_date0		= dates_tmp(:);

% return the monthly date vector
m_dates = m_date0(beg_Month:end-(12-end_Month));

