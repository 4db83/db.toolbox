function filled_data = fillnans(data,method)
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
% REPNAN only works on vectors, so first check if data is a double.

SetDefaultValue(2,'method','previous');

[Nr,Nc]			= size(data);
filled_data = zeros(Nr,Nc);
% % % find first non-nan in all entries, approximately from 1997 on-wards
% I0	= find(~anynan(Pt0),1,'first')
for jj = 1:Nc
	if strcmp(method,'previous')
		% find the first non-nan value and start fill_with_previous from there. 
		Inan	= find(~isnan(data(:,jj)),1,'first');
		tmp_1 = data(1:Inan-1,jj);
		tmp_2 = data(Inan:end,jj);
		filled_data(:,jj) = [tmp_1; fill_with_previous1(tmp_2)];
	else
		filled_data(:,jj) = repnan(data(:,jj),method);
	end
end;



end % EOF MAIN FUNCTION


function aout = fill_with_previous1(data)

if size(data,2)> 1
	disp('	ERROR: data must be a vector')
end

I					= ~isnan(data); % find missing index entry
idx				= cumsum(I);		% sum over them
idx(~idx) = 1; 
tmp_0			= data(I); 
aout			= tmp_0(idx);
end
	
