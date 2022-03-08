function tech_X = make_technicals(P)
% F: Makes a standard set of techincal indicators.
%-------------------------------------------------------------------------------------------------
% MOMENTUM RULES BASED 260 (12MONTH) AND 130(6MONTH) TRADING DAY RETURNS...
MOM.MOM12		= make_X_MOM(P,260);				% 1 year momentum
MOM.MOM9		= make_X_MOM(P,3*260/4);		% 9 months momentum
MOM.MOM6		= make_X_MOM(P,2*260/4);		% 6 months momentum
MOM.MOM3		= make_X_MOM(P,1*260/4);		% 3 months momentum
%-------------------------------------------------------------------------------------------------
% MA RULES BASED ON [FX,100,50] CROSSINGS WITH MA200.
MA					= make_X_MA(P);
%% -------------------------------------------------------------------------------------------------
% RSI RULE BASED TECHNICALS
RSI.RSI14		= make_X_RSI(P,14);
RSI.RSI20		= make_X_RSI(P,20);

tech_X.MOM	= MOM;
tech_X.MA		= MA ;
tech_X.RSI	= RSI;
