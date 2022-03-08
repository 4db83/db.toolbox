function XRSI = make_X_RSI(P,n,bound)
%{F: Make X vector of TECHNICAL RSI REGRESSORS:
%========================================================================================
% 	USGAGE		X_RSI = make_X_RSI(P,n,bound)
%---------------------------------------------------------------------------------------
% 	INPUT  
%			 P:			(Tx1 asset Price data (use non-logged values)
%		   n:			scalar, number of periods to comput RSI over.
%  bound:			(2x1) vector of Lower and upper bounds that generate the buy/sell triggers.
%                 	
% 	OUTPUT       
%		XRSI:			structure with:
%		.RSI:			(Tx1) vector of RSI(n)
%     .I:			(Tx2) matrix of buy and sell indicators (1 and -1)
%    .IX:			(Tx2) matrix of buy and sell indicators with interaction terms.
%		
%							where entries are: X_RIS = 
% [RSI (RSI==1 if > UB) (RSI==-1 if > LB) RSI*(RSI==1 if > UB) RSI*(RSI==-1 if > LB) ]
% 						last two terms are interaction terms.
%========================================================================================
% 	NOTES :   NONE:
%----------------------------------------------------------------------------------------
% Created :		13.06.2014.
% Modified:		13.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

if nargin < 3 
	% SET SOME DEFAULT VALUES
	LB = 30;	% lower buy trigger when oversold condition holds.
	UB = 70;	% upper sell trigger when overbought condition holds.
else
	LB = bound(1);
	UB = bound(2);
end;
	
% RSI Indicators (0,1)
xRSIn			=	 RSIn(P,n);
xRSIn_B		=  double(xRSIn > UB);			% BUY		SIGNAL
xRSIn_S		= -double(xRSIn < LB);			% SELL	SIGNAL

%XRSI = [xRSIn xRSIn_B xRSIn_S xRSIn_B.*xRSIn xRSIn_S.*xRSIn];
XRSI.RSI	= xRSIn;
XRSI.I		= [xRSIn_B xRSIn_S];
XRSI.IX		= [xRSIn_B.*xRSIn xRSIn_S.*xRSIn];