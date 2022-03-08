function filled_fts = fillnans_fts(fints_data,method)
% Function
% x = repnan(x,method) specifies a method for replacing data with NaNs. 
% Methods are: 
%			'nearest', 
%			'linear', 
%			'spline', 
%			'pchip', 
%			'cubic',
%			'v5cubic', 
%			'next',					replaces NaNs with the next non-NaN value in x
%			'previous'.			replaces NaNs with the previous non-NaN value in x.  
% Default is 'linear'.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(2,'method','previous');

% get fieldnames
names0	= fieldnames(fints_data);
% get dates first
dates0	= fints_data.dates;
% datamat 
matx0		= fts2mat(fints_data);
[Nr,Nc] = size(matx0);

% fill the nans in the matrix first
no_nan_matx = fillnans(matx0,method);

% make an fints strcuture again. 
filled_fts	= fints(dates0,no_nan_matx,names0(end-Nc+1:end),'d');

