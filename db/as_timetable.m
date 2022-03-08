function aout = as_timetable(FredData,Varnames)
% Convert data from [date data] format to matlab timetable (tt), compatible with Fred.Data structure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT: 
%   FredData:   
%     - A data scructure in Fred format FredData.Data = [datenum data] (Txn) matrix.
%       If FredData is a data matrix instead, the first column must be a datevector in datenum format.
%   Varnames: 
%     - A cell structure with varnames. These must be supplied, otherwise Var1 Var2 etc will be used. 
%             
% OUTPUT:
%   Timetable of data.
% 
% USAGE:  
%   simply call as: tt = as_timetable([dates Data], Varnames) or 
%   or with Fred as (first get Fred data): fd= getFredData('A939RX0Q048SBEA', '1947-01-01', '2021-12-31');
%   then conver to timetable: tt = as_timetable(fd, Varnames);
%
% COMMENTS: 
%   Add extra variables to tt by simply calling: tt.NewVariableName = Newvariable_data
%   Use syncronize to merge two or more timeframes with different date lengths.
%     ie., tt_new = synchronize(tt1,tt2);
%
% ---------------------------------------------------------------------------------------------------
% db (created):
%   - 25.01.2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isfield(FredData, 'Data')
  data_in = FredData.Data;
else
  data_in = FredData;
end

k = size(data_in,2);

if nargin < 2
  Varnames = [repmat('X_',k-1,1) num2str((1:k-1)')];
end

aout = array2timetable(data_in(:,2:end), ...
                       'RowTimes',datetime(data_in(:,1),'ConvertFrom','datenum'), ...
                       'VariableNames', cellstr(Varnames));












%EOF 