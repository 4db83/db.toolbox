function nss = ns_yields_funct(b,L,tau)
%{F: Nelson-Siegel function to compute the YIELDS from the factor loadings.
%========================================================================================
% 	USGAGE		nss = ns_yields_funct(b,L,tau)
%---------------------------------------------------------------------------------------
% 	INPUT  
%			 b:			(Tx3) BETA0	BETA1	BETA2
%			 L:			(Tx1) LAMBDA1 
%		 tau:			(Kx1) vector of Maturirites, where 1/4 = 3M or 1Q, 1/12 = 1M, etc and 30 is 30 Years.
%                 	
% 	OUTPUT       
%		 nss:			(TxK) matrix of zero-coupn yields at time T with maturity tau.
%========================================================================================
% 	NOTES :   NONE
%----------------------------------------------------------------------------------------
% Created :		10.06.2014.
% Modified:		10.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}


% this is the nelson-siegel model
nss =  b(1) + b(2)*(1-exp(-tau./L(1)))./(tau./L(1)) + ...
              b(3)*((1-exp(-tau./L(1)))./(tau./L(1))-exp(-tau./L(1)));
