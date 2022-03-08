function RSIn= RSIn(P,n);
%{F: Make Relative Strength Index (RSI) (continous RV)
%========================================================================================
% 	USGAGE		RSIn= rsi(P,n);
%---------------------------------------------------------------------------------------
% 	INPUT  
%			 P:			(Tx1 asset Pricde data (use non-logged values)
%		   n:			scalar, number of periods to comput RSI over.
%                 	
% 	OUTPUT       
%		RSIn:			(Tx1) coninuous RSI variable
%========================================================================================
% 	NOTES :   NONE:
%----------------------------------------------------------------------------------------
% Created :		10.06.2014.
% Modified:		10.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

% construct growth rate.
dFX		=	 delta(P);
UC		=	 dFX.*(dFX > 0);
DC		= -dFX.*(dFX < 0);
% compute the denominator of the fraction first
DENOM = 1 + ma_filter(DC,n)./ma_filter(UC,n);
% output the RSI with smoothing widht n
RSIn	= 100 - 100./DENOM;


