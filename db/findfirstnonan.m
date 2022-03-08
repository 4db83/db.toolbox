function [i1, varargout] = findfirstnonan(data_in,dates_in,display2screen)
% find first row of non-nan entries in a matrix or fts object
% db 
% ---------------------------------------------------------------------------------------------------------
SetDefaultValue(3,'display2screen',0)


% get size of input
[Nr,Nc]		= size(data_in);

if strcmp(class(data_in),'fints')
	dates_		= data_in.dates;
	data_mat	= fts2mat(data_in);
	names_tmp = fieldnames(data_in);
else
	data_mat	= data_in;
	% when no date vector is supplied, make simply another index
	if nargin < 2
		dates_ = (1:Nr)';
	else
		dates_ = dates_in;
	end
end
	

% space allocation
i1 = nan(Nc,1);

% loop over series to find first index
for ff = 1:Nc
	i1(ff) = find(~isnan(data_mat(:,ff)),1,'first');
end

if length(i1) ~= 1
	% now output table as an additiona output argument if wanted
	if strcmp(class(data_in),'fints')
		table_out = table(cellstr(datestr(dates_(i1),'dd-mmm-yyyy')),names_tmp(4:end),i1, ...
								'VariableNames',{'Dates' 'Names' 'Index'});
	else
		if nargin > 1
			table_out = table(cellstr(datestr(dates_(i1),'dd-mmm-yyyy')), 'VariableNames',{'Dates' 'Index'});
		end
	end
else
	table_out = [datestr(dates_(i1)) '  ' num2str(i1)];
end
	
% if nargout == 0
% 	sep(20,'=')

if display2screen
 	disp(table_out);
end

% 	sep(20,'=')
% else
if nargout > 1
 	varargout{1} = table_out;
end



					
					