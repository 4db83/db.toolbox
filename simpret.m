function dY=simpret(Y,k)
%Function: Compute the kth simple return in Y(t) as [Y(t)/Y(t-k) - 1].
%______________________________________________________________
%
%DESCRIPTION:
%
%	Computes	the kth period simple return in Y(t) as: as [Y(t)/Y(t-k) - 1].
%						alternative to continously compounded returns. 
%						do not log the series.
%______________________________________________________________
%
% USAGE:	dy = simplret(Y,k).
%______________________________________________________________
%
% INPUT:
%		
%     Y = dependent variable  (Txn).                                     
%    	k = order of change to be computed.al for the
%  
%OUTPUT:
%
%	   dY = (Txn) vector of k period simple return in Y(t), with NaNs in
%         first k lagged postions, so needs to be trimmed.
%	
% NOTES:-------------------------------------------------------
%		NONE.
%______________________________________________________________
%   
%   		Created by Daniel Buncic on 29/8/2005.
% 			Modified on: 29/8/2005.
%______________________________________________________________


if nargin < 2;
  k = 1;
end

dY  = Y./lag(Y,k) - 1;

end
