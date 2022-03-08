function [strng_data] = nst(data_with_dates,prnt_format)
%--------------------------------------------------------------------------------------
% function nst() short version of num2str
%--------------------------------------------------------------------------------------
%						USAGE:	nst(data_with_dates).
%--------------------------------------------------------------------------------------
%	 EXTRA CONTROLS:	prnt_format = string, specifies string printing format for numbers.
%										if_no_dates = indicator, if = 1, no dates in first colmun of data.
%======================================================================================
% db (March, 2014).
%--------------------------------------------------------------------------------------

x = data_with_dates;


if nargin < 2
	prnt_format = '%2.4f';
end;

xout = [num2str(x,[prnt_format '  '])];

% return the required string
strng_data = xout;

