function strout = prntstrng2xls(strng)
%{F: Add ' in front of number string to be displayed correctly in Excel
%===============================================================================
% Makes it easy to view strings in excel which are actually numbers without 
% converting them to numbers`
%-------------------------------------------------------------------------------
% 	USGAGE:	strout = prntstrng2xls(strng)
%   TO WRITE TO XLS: xlswrite(xls_out_name,cellstr(prntstrng2xls(strng)),'Sheet1','A2');
%-------------------------------------------------------------------------------
% 	INPUT : 
%	  x			 =    (Txk) vector or strings
%                 
% 	OUTPUT:       
%	  strout  =   same string but now as a cellstr with ' infront of the vector.
%===============================================================================
% 	NOTES :     USE WITH xlswrite(xls_out_name,cellstr(strng),'Sheet1','A2');
%-------------------------------------------------------------------------------
% Created :		05.06.2013.
% Modified:		05.06.2013.
% Copyleft:		Daniel Buncic.
%------------------------------------------------------------------------------%}

strx    = [repmat('''',size(strng,1),1) strng];
strout  = cellstr(strx);