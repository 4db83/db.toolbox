function [xx_norm1, norm1ofxx] =matrixnorm1(xx)
%{F: Computes the 1-norm of the columsn of a matrix and normalises a matrix to have 1-norm columsn
%===============================================================================
% Returns a normalised matrix with column norm = 1 and the norms of original xx matrix
%-------------------------------------------------------------------------------
% 	USGAGE:	[xx_norm1, norm1ofxx] =matnorm1(xx);
%-------------------------------------------------------------------------------
% 	INPUT : 
%	xx			   =  (TxN) matrix 
%                 
% 	OUTPUT:       
%	xx_norm1		=  (TxN) matrix xx with column norm = 1.
%	norm1ofxx	=  (1xN) matrix with the column norms of xx.
%
%===============================================================================
% 	NOTES :		To be used in conjunction with cond(xx) to see what the condition 
%              number of a matrix is.
%-------------------------------------------------------------------------------
% Created :		17.06.2013.
% Modified:		17.06.2013.
% Copyleft:		Daniel Buncic.
%------------------------------------------------------------------------------%}

[NR, NC]    = size(xx);

norm1ofxx   = sqrt(sum(xx.^2));              % column norms/lenght of the matrix xx.
xx_norm1    = xx./repmat(norm1ofxx,NR,1);    % normalised matrix with column norm = 1.
