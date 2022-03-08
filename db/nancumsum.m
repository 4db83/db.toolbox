function CS_out = nancumsum(x)
% Function: compute cumsum with nan entries at the beginning, replacing the nans
% after at the end of the funciton call
% db 1.4.2015. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% get size of input
[T,k] = size(x);
% make space for output
store_tmp	= [];

% loop through columsn of x if > 1.
for i = 1:k
	% find nan entries
	Ix			= anynan(x(:,i));
	% first nan entry
	N_Ix		= sum(Ix);

	% Check if contiguous entry in nans.
	checkI	= sum(Ix(1:N_Ix)) == N_Ix;
	if ~checkI; error('Non-contiguous vector with NaN'); end;

	% make cumsum without nans.
	cs1			= cumsum(x(N_Ix+1:end,i));
	% replace nans in front
	store_tmp	= [store_tmp [nan(N_Ix,1);cs1]];
end

CS_out = store_tmp;

