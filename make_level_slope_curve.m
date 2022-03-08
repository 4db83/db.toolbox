function LSC = make_level_slope_curve(yields)
%{F: Make empirical level, slope and cruvature factors as in Diebold et al.(2006, p.319).
%     Level       = (y(3)+y(24)+y(120))/3
%     Slope       = (y(3)-y(120))
%     Curvature   = 2*y(24)-y(3)-y(120).
%========================================================================================
% 	USGAGE		LSC = make_level_slope_curve(yields)
%---------------------------------------------------------------------------------------
% 	INPUT  
%		data:			(Tx3) data zero coupon yield vector with maturities of [3M 2Y 10Y].
%                 	
% 	OUTPUT       
%	  aout:			(Tx3) vector empiricla [Level Slope Curvature].
%========================================================================================
% 	NOTES :   NONE:
%----------------------------------------------------------------------------------------
% Created :		05.06.2014.
% Modified:		05.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}


Level     = mean(yields,2);
Slope     = yields(:,1) - yields(:,3);
Curvature = 2*yields(:,2) - yields(:,1) - yields(:,3);

LSC =  [Level Slope Curvature];