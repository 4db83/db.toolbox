function [all_duplicates, index_dublicates] = find_all_duplicates(vector_in) 
% return indicator vector of same dimension as vector_in which is equal to one for all
% dublicate entries. 
% db: 20.05.2020.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~, nC] = size(vector_in);

if nC > 1
	error('----------- INPUT DATA MUST BE A COLUMN VECTOR ----------------')
end

	[~,II]		= unique(vector_in,'first');
	II2				= (not(ismember(1:numel(vector_in),II)))';
	tmp_ds		= vector_in(II2);
	index_dublicates	= strcompm(vector_in, tmp_ds);
	all_duplicates		= vector_in(index_dublicates==1);

end