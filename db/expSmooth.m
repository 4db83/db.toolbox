function Sx = expSmooth(xx,alpha,init)
% F: EWMA smoother with parameter lambda. 
% CALL AS: ewma_x = ewma(x,lambda,init).
% ======================================================================================================
% This is the EWMA volatility form, where lambda is the weight on lagged unobserved series, and
% the time off-set is such that both series are lagged (time t-1).
% ------------------------------------------------------------------------------------------------------
%		THE FORM IS AS IN THE EXPONENTIAL SMOOTHING LITERATURE:
%		defined so that weigth alpha is on the current value of the observed series x(t). 
%		THEN THE FORM IS THEN:
%				Sx(t) = alpha*x(t) + (1-alpha)*Sx(t-1) 
%		where Sx(t) is the smoothed series of x at time (t).
% ------------------------------------------------------------------------------------------------------
% 	INPUT  
%		xx:				(Tx1) vector of data to be filtered.
% 	alpha:		smoothing parameter: weight of the most recent observed series x(t)
% 	init:			(Optional) initial conditon to start the Sx smoothed series from.
%                 	
% 	OUTPUT       
%	  ewma_x:		(Tx1) vector of EWMA smoothed/filtered data.
% ======================================================================================================
% 	NOTES :   Simple exponential smoothing. See Rob Hyndman book for instance.
% ------------------------------------------------------------------------------------------------------
% Created :		16.08.2017.
% Modified:		16.08.2017.
% Copyleft:		Daniel Buncic.
% ------------------------------------------------------------------------------------------------------

[TT,Nc] = size(xx);
Inan		= anynan(xx);
Sx			= nan(TT,1);
% remove nans at the beginning of the data series
X	= xx(~Inan,:);

% if not supplied take the average of the first 4 observations
if nargin < 3
	init = mean(X(1:4));
end

% THIS USES (t-1) OBSERVED SERIES X TO MAKE UNOBSERVED SERIES
% filter parameters A(L)Sx(t) = B(L)x(t)
A = [1 -(1-alpha)];			% A is AR part [1-(1-alpha)*L]
B = alpha;							% B is MA part (alpha)
% filter now: [1-(1-alpha)*L]Sx(t) = alpha*x(t)
Sx_tmp = filter(B,A,X,init);

% now return EWMA(x) with NANs at the beginning.
Sx(findfirstnonan(xx):TT,:) = Sx_tmp;








end











































% CHECK WITH LOOP

% sX = zeros(size(X));
% sX(1) = init;

% % for ii = 2:length(X)
% % 	sX(ii) = lambda*sX(ii-1) + (1-lambda)*X(ii-1);
% % end

% % alpha = 1-lambda;
% % for ii = 2:length(X)
% % 	sX(ii) = alpha*X(ii) + (1-alpha)*sX(ii-1);
% % end
% % 
% % 
% % ewma_x = filter([alpha],[1 -(1-alpha)],X,init);
% % 
% % [ewma_x sX]
% % 
% % plot([ewma_x sX])
% % 




