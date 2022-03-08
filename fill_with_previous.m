function aout = fill_with_previous(data)
%{F: Fills matrix with NANs with previous values.
%========================================================================================
% 	USGAGE		aout = fill_with_previous(data)
%---------------------------------------------------------------------------------------
% 	INPUT  
%		data:			(Txk) data vector with missing values.
%                 	
% 	OUTPUT       
%	  aout:			(Txk) data vector with missing values replaced with previous time entries.
%========================================================================================
% 	NOTES :   NONE:
%----------------------------------------------------------------------------------------
% Created :		05.06.2014.
% Modified:		05.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

% % if nargin < 2
% % 	missingvalue = 'NaN';
% % end;

if sum(sum(isnan(data))) == 0
	disp('	ERROR:	WHEN CALLING FILL_WITH_PREVIOUS missing values must be NaN.')
	disp('					OR --> there are NO MISSING VALUES')
end

I					= ~isnan(data);		% find missing index entry
idx				= cumsum(I);			% sum over them
idx(~idx) = 1; 

[T,k]			= size(I);

mm = mean(mean(idx,2)./idx(:,1));

if mm == 1 % do all at once if they have the same missing date entry
	I			= I(:,1);
	idx		= idx(:,1);
	tmp_0	= data(I,:); 
	aout	= tmp_0(idx,:);
else % otherwise loop through each individually column vector (series)
	for i=1:k
    X(:,i)	= fill_with_previous1(data(:,i));
	end;
	aout = X;
end;

%% Subfunction call for single vector input only. 
function aout = fill_with_previous1(data)

if size(data,2)> 1
	disp('	ERROR: data must be a vector')
end

I					= ~isnan(data); % find missing index entry
idx				= cumsum(I);		% sum over them
idx(~idx) = 1; 
tmp_0			= data(I); 
aout			= tmp_0(idx);

