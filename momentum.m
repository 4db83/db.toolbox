function [S,PP_n] = momentum(P,n);
%{F: Make momentum technical indicator.
%     S = 1 if P_t >= P_{t-n}
%========================================================================================
% 	USGAGE		S = momentum(P,n);
%---------------------------------------------------------------------------------------
% 	INPUT  
%		data:			(Tx1) data of asset prices (use non-logged values so that PP_1 when logged is like a long return.)
%		   n:			scalar, number of periods to comput momentum over.
%                 	
% 	OUTPUT       
%			 S:			(Tx1) inidcator, = 1 if momentum state.
%		PP_1:			(Tx1) ratio showing how big the momentum is. 
%========================================================================================
% 	NOTES :   NONE:
%----------------------------------------------------------------------------------------
% Created :		10.06.2014.
% Modified:		10.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}


P_n		= lag(P,n);
PP_n	= P./P_n;
% BUY SIGNAL = 1, SELL SIGNAL = -1
S				= PP_n >= 1;														% MOMENTUM INDICATOR OVER LAST N PERIODS.
%S				= double(S);
%S(S==0) = -1;
S				= [NaN(n,1);S(n+1:end)];

