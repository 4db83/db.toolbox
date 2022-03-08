function x_ma = ma_filter(x,n)
%{F: One-Sided equally weighted MA filter of random variable X with MA lenght n.
% computed as (with n = 4) Y(t) = 1/4X(t) + 1/4X(t-1) + 1/4X(t-2) + 1/4X(t-3)
% NOTE: This can be used to compute a rolling window mean for instance, with fixed window
%				size of n observations (ie., average at point t to t-n+1)
%				The recmean(.) function, computes the expanding window mean, increasing window 
%				size. 
%========================================================================================
% 	USGAGE		x_ma = ma_filter(x,n)
%---------------------------------------------------------------------------------------
% 	INPUT  
%		x:				(Txk) vector of data to be MA_filtered.
% 	n:				scalar, number of MA terms, ie., 50, 100, 200 etc.                	
%                 	
% 	OUTPUT       
%	  x_ma:			(Txk) vector of MA filtered data.
%========================================================================================
% 	NOTES :   Simple equal weighted One-Sided filter. RV X can be a vector so same MA filter 
%							is appled to each column entry.
%----------------------------------------------------------------------------------------
% Created :		05.06.2014.
% Modified:		05.06.2014.
% Modified:		20.03.2017.
% NOW HANDLES ALSO FINANCIAL TIME SERIES OBJECTS
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

if strcmp(class(x),'fints')
	% MAKE A DOUBLE MAT OUT OF IT
	xdat		= fts2mat(x);
	xnames	= fieldnames(x);
else
	% ELSE JUST USE X AS XDAT
	xdat	= x;
end

% NOW USE THE STANDARD FILTER
b 		= ones(1,n)/n;
[T,k] = size(xdat);
% x_ma 	= conv(x,b,'valid'); 
x_ma 	= filter(b,1,xdat); 							% better coz handels matrix inputs and not only vectors.
x_ma 	= [NaN(n-1,k); x_ma(n:end,:)];

if strcmp(class(x),'fints')
	x_ma_fts = fints(x.dates, x_ma, xnames(4:end));
	x_ma = x_ma_fts;
end


