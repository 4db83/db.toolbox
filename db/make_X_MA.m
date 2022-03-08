function XMAs = make_X_MA(P,smthers)
%{F: Make X vector of TECHNICAL MA REGRESSORS:
%========================================================================================
% 	USGAGE		X_MAs = make_X_MA(P,smthers)
%---------------------------------------------------------------------------------------
% 		INPUT  
%					P:	(Tx1 asset Price data (use non-logged values)
% 	smthers:	(3x1) vector of MA smoothers (length of MA to average over).
%                 	
% 	 OUTPUT       
%			 XMAs:	structure with:
%     	 .I:	(Tx3) matrix of buy indicators (1,0) for 3 different MA crossovers.
%							[MA200FX MA20050 MA200100]:
%    		.IX:	(Tx6) matrix of buy indicators with interaction terms.
%							[MA200FXb MA20050b MA200100b MA200FXs MA20050s MA200100s]:	
%========================================================================================
% 	NOTES :   NONE:
%----------------------------------------------------------------------------------------
% Created :		13.06.2014.
% Modified:		13.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

if nargin < 2 
	% SET SOME DEFAULT VALUES
	n50		=	50;																						% fast MA
	n100	= 100;																					% medium MA
	n200	= 200;																					% slow MA
else
	n50		=	smthers(1);																		% fast MA
	n100	= smthers(2);																		% medium MA
	n200	= smthers(3);																		% slow MA
end;
	
% create MA filters
MA200     = ma_filter(P,n200);
MA100     = ma_filter(P,n100);
MA50      = ma_filter(P,n50 );

% MA Indicators (0,1) BUY SIGNAL OF SHORT MA PENETRATES TROUGH LONG MA.
MA200FX   = P			> MA200;															% MA200 > FX spot price series.
MA20050   = MA50	> MA200;															% MA200 > MA50	
MA200100  = MA100	> MA200;															% MA200 > MA100

% BUY MA Interaction Term (increase with size of deviation)
MA200FXb  = 	MA200FX 	.*(P		- MA200);	
MA20050b  = 	MA20050 	.*(MA50	- MA200);
MA200100b = 	MA200100	.*(MA100- MA200);

% SELL MA Interaction Term (increase with size of deviation)
MA200FXs  = (1-MA200FX) .*(P		- MA200);	
MA20050s  = (1-MA20050) .*(MA50	- MA200);
MA200100s = (1-MA200100).*(MA100- MA200);

% MA BASED BUY/SELL INDICATORS AS IN NEELEY ET AL. (2014)
XMAs.I		= [MA200FX MA20050 MA200100];		
% MA BASED BUY/SELL INTERACTION TERMS WITH INDICATORS, IE. MA20050.*(MA50-MA200)
XMAs.IX		= [MA200FXb MA20050b MA200100b MA200FXs MA20050s MA200100s];	














