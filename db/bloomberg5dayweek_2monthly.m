function agg_data = bloomberg5dayweek_2monthly(dates_go,x_go)
%{F: Aggregates 5 day week daily data to end of period Monthly data and monthly .			
%-------------------------------------------------------------------------------
% USAGE :	agg_data = bloomberg5dayweek_2monthly(dates_go,x_go)
%-------------------------------------------------------------------------------
% INPUT:	dates_go	:	(Tx1) matlab numerical date vector (datenum)
%					x_go		 	: (Txk) data matrix
%-------------------------------------------------------------------------------
% OUTPUT: agg_data  : (3x1) structure with elements:
%											.dates (full matlab datevector)
%											.ave (Txk) data vector with monthely averages.
% 										.eop (Txk) data vector with end-of-period entries.
%-------------------------------------------------------------------------------
% NOTES :		None.
%-------------------------------------------------------------------------------
% Created by 
% Daniel Buncic:	12.08.2014.
%-----------------------------------------------------------------------------%}

[dFTS]         = fints(dates_go,x_go);
aveFTS         = fts2mat(tomonthly(dFTS,'BusDays',0,'CalcMethod','SimpAvg'),1); 
eopFTS         = fts2mat(tomonthly(dFTS,'BusDays',0,'CalcMethod','Nearest'),1);

agg_data.dates = aveFTS(:,1);
agg_data.ave   = aveFTS(:,2:end);
agg_data.eop   = eopFTS(:,2:end);

