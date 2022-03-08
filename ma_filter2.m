function x_ma = ma_filter2(x,W)
%{F: Two-Sided MA filter of RV X with MA weiths W.
%========================================================================================
% 
%----------------------------------------------------------------------------------------
% 	USGAGE		x_ma = ma_filter2(x,W)
%---------------------------------------------------------------------------------------
% 	INPUT  
%		x:				(Tx1) vector of data to be MA_filtered.
% 	W:				(N+1x1), vector of smoothing weights that sum to 1.
%							NOTE: W weight vector should be odd, to have a centred two-sided filter.
%                 	
% 	OUTPUT       
%	  x_ma:			(Tx1) vector of MA filtered data.
%========================================================================================
% 	NOTES :   Simple Two-Sided (forward/backward) filter. RV X must be a scalar.
%----------------------------------------------------------------------------------------
% Created :		05.06.2014.
% Modified:		05.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}


N	= length(W);
if mod(N,2)==0
	disp('ERROR: Weight vector should have odd number of entries');
end

if str2num(num2str(sum(W),'%2.8f'))~=1
	disp('ERROR: Weigths need to sum to 1 for two sided filter');
end

pads 	= NaN((N-1)/2,1);
x_ma 	= conv(x,W,'valid'); 
x_ma 	= [pads; x_ma; pads];



