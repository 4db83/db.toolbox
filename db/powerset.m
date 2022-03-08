function [indx] = powerset(theSet)

% create binary of all model sets
bin_ind = dec2bin(0:1:2^numel(theSet)-1);

%convert binary to double index
indx = (double(bin_ind)-48)==1;

end
