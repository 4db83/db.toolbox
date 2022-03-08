function [LRV_L, LRV_all, KWout, LOPTS] = LRV_1(x,L,prnt)
%{F: Computes the (UNIVARIATE) Long-Run Variance (LRV) WITHOUT PRE-WHITENING of vector X.
% INPUTS: 	
%						X: 	(Tx1) series whose long-run variance is needed.
%						L: 	scalar, optional for specific bandwidth.
%				 prnt:	indicator, if 1, then some summary output is printed.
% OUTPUTS: 		
%			  LRV_L:	scalar, default LRV with either fixed L or ROT L of Newey & West (1994) and Bartlet Kernel.
% 							
%			LRV_all: 	structure, all computed LRV combinations using ARMA(1,1),AR(1), QS,Bartlet (NO PW)
%			data driven truncation lags and also QS and Bartlet rule of thumb results.
% 		  KWout:	(Tx1) vector of used Kernel weights.
% 		  LOPTS:	ARMA fitting optimization output.
% ---------------------------------------------------------------------------------------
% NO PRE-WHITENING DONE HERE. ONLY COMPUTE AR(1) AND ARMA(1,1) MODELS TO GET DATA DRIVEN TRUNCATION
% LAGS AS IN ANDREWS FOR QS AND BARTLETT KERNELS
%========================================================================================
% 	NOTES :   	see also LRVwPW.m function. DOES ONLY Univariate MODELS.
%========================================================================================
% Created :			02.07.2014.
% Modified:			06.11.2015.
% Copyleft:			Daniel Buncic.
%----------------------------------------------------------------------------------------%}

% Data size
T  = size(x,1);
% NEWEY AND WEST 1994 Rule of Thumb truncation lag L. for BARTLET
L_B_rot						= ceil(4*(T/100)^(2/9));		% use ceil instead of floor to be more conservative
% if no user supplied L is given, USE Rule of thumber for Bartlet of Newey & West (1994) ceil(4*(T/100)^(2/9))
SetDefaultValue(2, 'L',L_B_rot);
SetDefaultValue(3, 'prnt',0);

% ----------------------------------------------------------------------------------------
% the default value for L is set below in line 93
% SetDefaultValue(2, 'L',Lopt.QS_ar1);
% ----------------------------------------------------------------------------------------

% % %	BARTLETT
% % B  = @(z) ((1-z).*(z<1));
% % % PARZAN`
% % PZ  = @(z) ( (1-6*z.^2+6*abs(z).^3).*(abs(z)<0.5) + ... 
% % 							2*(1-abs(z)).^3.*((abs(z)>0.5).*(abs(z)<1)) );
% % 
						
%	BARTLETT
B	 = @(z) ((1-z).*(z<1));
% PARZAN`
PZ = @(z) ( (1-6*z.^2+6*abs(z).^3).*(abs(z)<0.5) + ... 
						 (2*(1-abs(z)).^3)		 .*((abs(z)>0.5).*(abs(z)<1)) );
%	QUADRATIC SPECTRAL					
%QSa = 25/12./(pi^2*z.^2);
%QSb = sin(6*pi*z/5)./(6*pi*z/5)-cos(6*pi*z/5);
QS = @(z) ( (25/12./(pi^2*z.^2)).*(sin(6*pi*z/5)./(6*pi*z/5)-cos(6*pi*z/5)) );
% DANIEL
D  = @(z) (sin(pi*z)./(pi*z));
% TUKEY-HANNING 
TK = @(z) ((1+cos(pi*z))/2.*(abs(z)<1));
% WEIGHTING STRCTURE
Z  = @(j,L) (j./(L+1));

% compute the Phi_n(1) Phi_n(2) terms for AR(1) and ARMA(1,1) models..
Phi1_ar1		= @(a) ( (4*a^2)/( (1-a^2)^2 ) );
Phi2_ar1		= @(a) ( (4*a^2)/( (1-a)^4   ) );

Phi1_arma11 = @(a,b) ( (4*(1+a*b)^2*(a+b)^2)/( (1-a^2)^2*(1+b)^4) );
Phi2_arma11	= @(a,b) ( (4*(1+a*b)^2*(a+b)^2)/( (1-a)^4  *(1+b)^4) );

% inline LRV function handle, 
% input x = data, L = Trucnation Lag, K = Kernel handle, either B or QS.
KW					= @(x,L,K) ([0; K(Z((1:L)',L))]);
inLRV				= @(x,L,K) (var(x)*(1 + 2*[0; K(Z((1:L)',L))]'*autocorr(x,L)));

% fit arma(1,1) to x to get sturcture for Truncation Parameter
init_pars		= arma11_inits_F(x);
arma11_p		= armax_est(x,1,1,1,[],init_pars(end,:));
a						= arma11_p(2);
b						= arma11_p(3);

% fit ar(1) to x to get sturcture for Truncation Parameter
ar1_p	= armax_est(x,1,1,0);
ar1		= ar1_p(2);

% NEWEY AND WEST 1994 Rule of Thumb truncation lag L. for Quadratic Spectral (see table II)
L_QS_rot					= ceil(4*(T/100)^(2/25));		% use ceil instead of floor to be more conservative

% Optimal Trunctions Lag (Lopt) for the above Phi's and the two Kernels B and QS
Lopt.QS_ar1			= ceil(1.3221*(Phi2_ar1(ar1)*T)^(1/5));				% QS ARMA(1,1) for x_t
Lopt.QS_arma11	= ceil(1.3221*(Phi2_arma11(a,b)*T)^(1/5));		% QS AR(1) for x_t
Lopt.QS_rot			= L_QS_rot; % Rule of thumb
Lopt.B_ar1			= ceil(1.1447*(Phi1_ar1(ar1)*T)^(1/3));				% Bartlet ARMA(1,1) for x_t
Lopt.B_arma11		= ceil(1.1447*(Phi1_arma11(a,b)*T)^(1/3));		% Bartlet ARMA(1,1) for x_t
Lopt.B_rot			= L_B_rot; % rule of thumb

% replcace too big estimates of the trucntation parameter. occurs when ARMA estimated very imprecsiely
if (Lopt.QS_arma11	> T*2/3)	;Lopt.QS_arma11 = ceil(T*2/3);end;
if (Lopt.QS_ar1			> T*2/3)	;Lopt.QS_ar1		= ceil(T*2/3);end;
if (Lopt.B_arma11		> T*2/3)	;Lopt.B_arma11	= ceil(T*2/3);end;
if (Lopt.B_ar1			> T*2/3)	;Lopt.B_ar1			= ceil(T*2/3);end;

LOPTS = [Lopt.QS_ar1 Lopt.QS_arma11	Lopt.B_ar1 Lopt.B_arma11];

lngrvar = inLRV(x,Lopt.QS_ar1,QS);

lrvars.QS_ar1			= inLRV(x,Lopt.QS_ar1		,QS);
lrvars.QS_arma11	= inLRV(x,Lopt.QS_arma11,QS);

lrvars.QS_RoT			= inLRV(x,L_QS_rot,QS);

lrvars.B_ar1			= inLRV(x,Lopt.B_ar1		,B);
lrvars.B_arma11		= inLRV(x,Lopt.B_arma11	,B);

% NEWEY AND WEST 1994 Rule of Thumb truncation lag L. for BARTLET
lrvars.B_RoT			= inLRV(x,L_B_rot,B);

% % % if no user supplied L is given, USE Rule of thumber for Bartlet of Newey & West (1994) ceil(4*(T/100)^(2/9))
% % SetDefaultValue(2, 'L',L_B_rot);

% pass back a strcture of Bandwidths
LOPTS = Lopt;

% return default LRV with either fixed L or ROT L of Newey & West (1994) and Bartlet Kernel.
LRV_L = inLRV(x,L,B);

% LRVRS = [lrvars.QS_ar1 lrvars.QS_arma11 lrvars.B_ar1 lrvars.B_arma11];
% [[lrvars.QS_ar1; lrvars.QS_arma11] [lrvars.B_ar1; lrvars.B_arma11]]
% lrvars
LRV_print = reshape(struct2array(lrvars),3,2);

if prnt == 1;
sep(50)
	prnt1.fmt			= '%16.4f';
	prnt1.cnames	= {'QS' 'Bartlett'};
	prnt1.rnames	= {'Process:','AR(1)','ARMA(1,1)','RoT'};
	myprint( LRV_print ,prnt1);
sep(50)
end;

LRV_QS	= lngrvar;
LRV_all = lrvars;
KWout		= KW(x,L,QS);
	
function [pars] = arma11_inits_F(x,ar_iters)
SetDefaultValue(2, 'ar_iters',5);

y		= x(2:end);
T		= size(y,1);
X		= [ones(T,1) x(1:end-1)];

tmp_		= fastols_F(y,X);
bhat_iters	= [];
U			= tmp_.u;

for JJ = 2:ar_iters;
	olstmp     = @(ii,y,X,U) ( fastols_F(y(ii:end),[X(ii:end,:) U(1:end-1)]) );
	tmp_       = olstmp(JJ,y,X,U);
	U          = tmp_.u;
	bhat_iters = [bhat_iters; tmp_.bhat'];
end;

pars = bhat_iters;

function olsout = fastols_F(y,x)
% F: fit beta_hat and se(beta_hat) only

[nobs, nvar] = size(x);   %[nobs2 junk] = size(y);
xpx    = x'*x;
beta   = xpx\(x'*y);        
% beta = x\y; is much much slower!!!
u      = y-x*beta;
se     = sqrt(diag(inv(xpx)*(u'*u/(nobs-nvar)))); 

olsout.bhat = beta;     % fitted regression parameters.
olsout.u    = u;        % residuals
olsout.sse  = u'*u;     % Sum of Squared errors
olsout.se   = se;       % standard error of beta_hat
olsout.N		= nobs;     % sample size
olsout.k		= nvar; 		% number of variables plus constant.	
olsout.xpx  = xpx;			% x'x
olsout.y    = y;
