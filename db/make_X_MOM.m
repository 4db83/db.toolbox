function XMOMs = make_X_MOM(P,Tdays)
%{F: Make X vector of TECHNICAL MA REGRESSORS:
%========================================================================================
% 	USGAGE		XMOMs = make_X_MOM(P,Tdays)
%---------------------------------------------------------------------------------------
% 		INPUT  
%					P:	(Tx1 asset Price data (use non-logged values)
% 	smthers:	scalar, number of peridos to compute the MOMENTUM indicator over, 
%							common ones are 6,9 and 12 Monhts
%                 	
% 	 OUTPUT       
%			 XMAs:	structure with:
%     	 .I:	(Tx1) matrix of buy indicators (1,0).
%							[MOMn]:
%    		.IX:	(Tx2) matrix of buy/sell indicators with interaction terms.
%							[MOM12Mb MOM12Ms]:	
%========================================================================================
% 	NOTES :   NONE:
%----------------------------------------------------------------------------------------
% Created :		16.06.2014.
% Modified:		16.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

% MAKE MOMENTUM RULES based on 6/12 MONTHS RULE.
[MOMn, Pn]	= momentum(P,Tdays);							% 12	MONTH MOMENTUM, YEAR IS 260 TRADING DAYS, 

% BUY MOM Interaction Term (increase with size of deviation)
MOM12Mb			=	MOMn.*log(Pn);	

% SELL MOM Interaction Term (increase with size of deviation)
MOM12Ms			=	(1-MOMn).*log(Pn);	

% MA BASED BUY/SELL INDICATORS AS IN NEELEY ET AL. (2014)
XMOMs.I			= MOMn;
% MA BASED BUY/SELL INTERACTION TERMS WITH INDICATORS, IE. MA20050.*(MA50-MA200)
XMOMs.IX		= [MOM12Mb MOM12Ms];	


