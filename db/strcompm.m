function [Ind, indmatrix]= strcompm(longstr,shortstr)
%{F: Extractes an Indicator vector from two cell vectors.						
%-------------------------------------------------------------------------------
% This improves on matlabs strcomp functions as it includes the loop already.
%-------------------------------------------------------------------------------
% usage :	[Ind indmatrix] = strcompm(longstr,shortstr);
%-------------------------------------------------------------------------------
% input : longstr     = (Tx1) cell string array.
%        	shortstr    = (Kx1) cell string array with K <= T.
%-------------------------------------------------------------------------------
% output: Ind         = (Tx1) logical indicator array with 1 for everu entry 
%                       where shortstr(i) is equal to longstr.
%						indmatrix	= (TxK) indicator matrix.
%-------------------------------------------------------------------------------
% notes :		None.
%-------------------------------------------------------------------------------
% Created by 
% Daniel Buncic:	26.07.2008.
% Last Modified: 	19.08.2008.
%-----------------------------------------------------------------------------%}

tmp_0	= zeros(rows(longstr),rows(shortstr));

for i = 1:rows(shortstr)
	tmp_0(:,i) = strcmp(longstr,shortstr(i));
end

Ind = sum(tmp_0,2);

indmatrix = tmp_0;