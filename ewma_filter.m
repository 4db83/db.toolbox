function x_ewma = ewma_filter(x,lambda,init)
%{F: EWMA filter of RV X with smoother parameter lambda.
%========================================================================================
% 
%----------------------------------------------------------------------------------------
% 	USGAGE		ewma_x = ewma_filter(x,lambda,init)
%---------------------------------------------------------------------------------------
% 	INPUT  
%		x:				(Tx1) vector of data to be MA_filtered.
% 	lambda:		smoothing parameter, generally set between .8 and .97 or so.
% 	init:			(Optional) initial conditon to start the ewma_x smoothed series from.
%                 	
% 	OUTPUT       
%	  x_ewma:		(Tx1) vector of EWMA smoothed/filtered data.
%========================================================================================
% 	NOTES :   Simple EWMA Smoother/filter. RV X must be a scalar.
%----------------------------------------------------------------------------------------
% Created :		05.06.2014.
% Modified:		05.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}


if nargin < 3
	init = nanmean(x(1:4));
end;

A				= [1 -lambda];
B				= [0 (1-lambda)];

x_ewma	= filter(B,A,x,init);





