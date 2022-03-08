function ewma_x = ewma(xx,lambda,init)
% F: EWMA smoother with parameter lambda. 
% CALL AS: ewma_x = ewma(x,lambda,init).
% ======================================================================================================
% This is the EWMA volatility form, where lambda is the weight on lagged unobserved series, and
% the time off-set is such that both series are lagged (time t-1).
% ------------------------------------------------------------------------------------------------------
%		THE FORM IS:
%		Let h(t) be the unobserved volatilit (or log-vola) and e2 is the squared residual. The EWMA vola
%		estimate is thend computed as (same as IGARCH(1,1) with zero intercept:
%				h(t) = lambda*h(t-1) + (1-lambda)*e2(t-1).
% ------------------------------------------------------------------------------------------------------
% 	INPUT  
%		x:				(Tx1) vector of data to be filtered.
% 	lambda:		smoothing parameter, generally set between .8, .94 and .97 or so (RiskMetrics)
% 	init:			(Optional) initial conditon to start the ewma_x smoothed series from.
%                 	
% 	OUTPUT       
%	  ewma_x:		(Tx1) vector of EWMA smoothed/filtered data.
% ======================================================================================================
% 	NOTES :   Simple EWMA function. x must be a scalar. See expSmooth for alternative.
% ------------------------------------------------------------------------------------------------------
% Created :		16.08.2017.
% Modified:		16.08.2017.
% Copyleft:		Daniel Buncic.
% ------------------------------------------------------------------------------------------------------

[TT,Nc] = size(xx);
Inan		= anynan(xx);
ewma_x	= nan(TT,1);
% remove nans at the beginning of the data series
X	= xx(~Inan,:);

% if not supplied take the average of the first 4 observations
if nargin < 3
	init = mean(X(1:4));
end

% THIS USES (t-1) OBSERVED SERIES X TO MAKE UNOBSERVED SERIES
% filter parameters A(L)h(t) = B(L)e2(t). to have weight (1-lambda) on e2(t-1), => set B(L)=[0 (1-lambda)].
A	= [1 -lambda];			% A is AR part (1-Lambda*L)
B	= [0 (1-lambda)];		% B is MA part (0 (1-Lambda)*L)
% filter now: [1-lambda*L]h(t) = (1-lambda)*e2(t-1)
ewma_x_tmp = filter(B,A,X,init);

% now return EWMA(x) with NANs at the beginning.
ewma_x(findfirstnonan(xx):TT,:) = ewma_x_tmp;








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




