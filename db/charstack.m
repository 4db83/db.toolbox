function charout= charstack(strname,k)
% 
% creates a stacked vector of chars with strname as the name up to k subindices.
% to be used in the print command so that one does not need to manually create the 
% names with the different sub_indices.

%k = 104;
%strname = 'alphas_'

cn = [];
for i = 1:k
	aa = [strname num2str(i)];
	cn = char(cn,aa);
end;
charout = cn(2:end,:);
