function  xout = roundup(x,k)
% -------------------------------------------------------------------------------------
% function:	roundup() returns a round output, rounded up at the 'kth' decimal point. 
%						for instance, if x = 3.10, roundup(x,1) would return 3.2, if y = 0.21, 
%						roundup(y,2) returns 0.22. etc.
% -------------------------------------------------------------------------------------
% 					USAGE:	roundup.
% 				CALL AS:  roundup(x,k)
% -------------------------------------------------------------------------------------
%  EXTRA CONTROLS:	prnt_format = string, specifies string printing format for numbers.
% 									if_no_dates = indicator, if = 1, no dates in first colmun of data.
% =====================================================================================
% db (March, 2014).
% -------------------------------------------------------------------------------------

dfl = 10^(k);

xout = ceil(x*dfl)/dfl;