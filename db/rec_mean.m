function rec_x = rec_mean(x)
% F: COMPUTE THE RECURSIVE MEAN OF X, WHICH CAN BE A MATRIX.

[T,k] = size(x);

CX		= nancumsum(x);
TX		= (1:T)';

rec_x = CX./repmat(TX,1,k);