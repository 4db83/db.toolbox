function [matchd_data,I5,IX5,UM_IX5] = match_series2_basedates(base_dates_LONG,series_2b_matched_SHORT)
% Function:	uses the dates from the series_2b_matched [date data] vector and matches these 
% dates to the base_dates vector. 
% CALL AS: [matchd_data] = match_series2_basedates(base_dates,series_2b_matched)
% 
% OR			[matchd_data,I5,IX5,UM_IX5] = match_series2_basedates(base_dates,series_2b_matched).
%
% NOTE: length(base_dates) > length(series_2b_matched_dates) for this to work properly as we 
% loop for each date entry in the series_2b_matched_dates dates and check if it is in the
% base_dates series. To ensure this, I first remove all nan entries of column to of the 
% series_2b_matched. 
% -------------------------------------------------------------------------------------------
% BUT THIS DOES NOT GUARANTEE IT OF COURSE SO BE CAREFUL CREATING THE BASE AND THE 
% SERIES_2B_MATCHED DATE VECTORS.
% -------------------------------------------------------------------------------------------
% RETURNS:  
%		matchd_data		= (Tb x 1) vector of matched data to the base_dates with nan entries 
%										when no corresponding date in the series_2b_matched_dates exists.
%		I5						= (Tb x 1) Indicator = 1 if series_2b_matched_dates == base_dates(t).
%		IX5						= (Tb x 1) row inidcator for which I5 == 1. (ie. IX5 = find(I5)).
%		UM_IX5				= vector of rows of series_2b_matched dates that ARE NOT IN base_dates.
%										If perfect match. UM_IX5 is empty.
%		matchd_dates	= (Tb x 1) vector of the matched dates with the nan entries in between, to
%										show the relation to the original date series that was put in.
% -------------------------------------------------------------------------------------------
% INPUT:		
%		base_dates				= (Tb x 1) vector of base dates in matlab num format.
%		series_2b_matched = (Tm x k) matrix, with the first column being DATES in MATLAB NUM
%												format and the 2 to kth columns being the actual data. 
%												NOTE: I use the second column's nan entries to remove any nans
%												from the entire series_2b_matched matrix.
% 
% -------------------------------------------------------------------------------------------
% DB. 25.05.2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rename the series_2b_matched to something shorter.
s2bm	= series_2b_matched_SHORT;

% FIRST REMOVE ANY NAN ROW ENTRIES IN ENTIRE series_2b_matched MATRIX (NAN DETERMINANT IN COLUMN 2)
if size(s2bm,2) > 1
	s2bm	= delif(s2bm,anynan(s2bm(:,2)));
end;

% CHECK THAT length(base_dates) > length(series_2b_matched)
if length(base_dates_LONG) < length(s2bm); 
	disp(' ERROR: length(base_dates) < length(dates_2b_matched) ');
end;

% MATCH THE DATES NOW
[I5,IX5,~,UM_IX5]	= match_vectors(base_dates_LONG,s2bm(:,1));		% Unumatched series are: UM_IX5

% UNMATCHED DATES: dates that are in short dates vector but NOT in the long base_dates. 
if ~isempty(UM_IX5)
	sep(110)
	fprintf(' There are %d unmatched entries: data in SHORT(2ND) vector but not in LONG(1ST) (base_dates)\n', length(UM_IX5))
	sep(110)
	fprintf('Date					Value \n')
	sep(110)
	%disp([lst(s2bm(UM_IX5,:))])
	lstd(s2bm(UM_IX5,:),[],'%2.4f');
	sep(110)
end;

% TO CREATE OUTPUT MATRIX WITH NAN ENTRIES IN UN-AVAILABLE DATES
xnan	= nan(rows(base_dates_LONG),cols(s2bm));
% REMOVE EXTRA ROW ENTRIES THAT ARE IN S2BM BUT NOT IN THE BASE DATES VECTOR.
s2bm(UM_IX5,:)	= [];
% PUT THE S2BM (ie, dates and VIX data) back in the right row (date) locations in Xnan.
xnan(IX5,:)			= s2bm;
% RETURN THE BASE_DATES MATCHED DATES SERIES WITH NANS EVERYWHERE ELSE.
matchd_data			= xnan(:,2:end);
% THIS IS NOT RETURNED OUT OF THE FUNCTION, AND IS JUST FOR CHECKING.
matchd_dates		= xnan(:,1);

























%EOF