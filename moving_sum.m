function mvng_sum = moving_sum(x,n)
%{F: One-Sided MOVING SUM of random variable X with lenght n.
% computed as (with n = 4) Y(t) = X(t) + X(t-1) + X(t-2) + X(t-3)
% NOTE: This can be used to compute a rolling window sum for instance, with fixed window
%				size of n observations (ie., average at point t to t-n+1)
%				The recmean(.) function, computes the expanding window mean, increasing window 
%				size. 
%				THIS IS THE SAME WAY FORMULATED AS MA_FILTER FUNCTION, SO MA_FILTER(X,1) GIVES X BACK, SAME HERE, TO
%				COMPUTE THE MOVING SUM OVER TIME t AND t-1, need to put in MOVING_SUM(X,2)!
%========================================================================================
% 	USGAGE		mvng_sum = moving_sum(x,n)
%---------------------------------------------------------------------------------------
% 	INPUT  
%		x:				(Tx1) vector of data to be MA_filtered.
% 	n:				scalar OR vector of MA terms, ie., [1,5,22] for HAR jump factors.
%                 	
% 	OUTPUT       
%	  mvng_sum:	(Txk) vector of moving sums
%----------------------------------------------------------------------------------------
% Created :		12.07.2016.
% Modified:		12.07.2016.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}


% size of the dimension of the lag factor. could be a scalar or a (kx1) vector with elemetns say [0 5 22] to
% make the HAR type sums as opposed to averages. 
dim_n		= length(n);

% make the lag matrix
x_mlag	= [x mlag(x,n(dim_n))];

% now loop over all the input hh values that are required. 
for i = 1:dim_n
	% NOTE n(i) HAS THE NUMBER OF ADJACENT PERIODS, NOT THE LAGS, SO n=1 MEANS X(t), n=2 MEANS X(t)+X(t-1), 
	% n=2 MEANS X(t)+X(t-1), n=3 MEANS X(t)+X(t-1)+X(t-1), ETC.
	h_end = n(i);
	mvng_sum(:,i) = sum(x_mlag(:,1:h_end),2);
end



end 