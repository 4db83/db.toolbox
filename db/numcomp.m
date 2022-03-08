function [Ind,Indx,Imat,unmatched_Indx]= numcomp(longnum,shortnum)
%{F: Extractes an Indicator vector from two number vectors.						
%-------------------------------------------------------------------------------
% This improves on matlabs ismember functions as it includes Indx entry as well.
%-------------------------------------------------------------------------------
% usage :	[Ind,Indx,Imat,unmatched_Indx]= numcomp(longnum,shortnum)
%-------------------------------------------------------------------------------
% input : longnum     = (Tx1) num string array.
%        	shortnum    = (Kx1) num  string array with K <= T.
%-------------------------------------------------------------------------------
% output: Ind         = (Tx1) logical indicator array with 1 (TRUE) so that:
%												longnum(Ind) = shortnum.
%
%					Indx				= (Tx1) row index so that (Tx1) NAN(Indx)=shortnum puts all
%												the matched shortnum entries into the corresponding rows
%												of the longnum entries, with NANs everywhereelse.
%					Imat				= (TxK) full matrix of indicators.
%			 unmatched_indx = vector of all entries that are in shornum but that were not
%												found in longnum.
%-------------------------------------------------------------------------------
% Example:		
% %match the short date numbers to the long ones.
% [Ind,Indx]= numcomp(dates5,datesxls);
%
% %create NAN vector and match non-nan entries to big dates set.
% gold_nan				= nan(size(x0));
% gold_nan(Indx,:)= x0;						 % match longnum entries with shortnum
% gold_fill				= fill_with_previous(gold_nan);. % fill nans with previous
%-------------------------------------------------------------------------------
% Created by 
% Daniel Buncic:	26.07.2008.
% Last Modified: 	19.08.2008.
% Last Modified: 	10.08.2014.
%-----------------------------------------------------------------------------%}
% UNIQUNESS CHECK
check_unique = (length(unique(shortnum))==length(shortnum))*(length(unique(longnum))==length(longnum));
if ~check_unique 
	fprintf('-----------------------------------------------------------------\n')
	fprintf('ERROR: MULTIPLE SAME VALUE ENTRIES IN EITHER LONG OR SHORT VECTOR\n')
	fprintf('-----------------------------------------------------------------\n')
end

rows_long		= size(longnum,1);
rows_short	= size(shortnum,1);
long_index	= (1:rows_long)';
short_index = (1:rows_short)';

% FUll matrix of indicators
Imat				= nan(rows_long,rows_short);

% loop throught to find matching entries.
% NOTE: Alternatively, use ismember(A,B), but this does 
for i = 1:rows(shortnum)
	tmp0			= longnum==shortnum(i);
	Imat(:,i) = tmp0;
end;

% MATCHED ENTRIES 
Ind  = sum(Imat,2)==1;								% LOGICAL INDICATORS
Indx = selif(long_index,Ind==1);			% ROW/INDEX ENTRY

% UNMATCHED ENTRIES
Iunmatched = sum(Imat)==0;
if sum(Iunmatched)~=0
	disp('NOTE: UNMATCHED ENTRIES IN SHORT VECTOR. THESE ARE COLLECTED IN unmatched_Indx)')
end;
unmatched_Indx = short_index(Iunmatched);

