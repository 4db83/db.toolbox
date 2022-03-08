function nss = nss_smoother_funct(b,L,tau)
%{F: Nelson-Siegel-Svensson model for the YIELDS.
%========================================================================================
% 	USGAGE		nss = nss_smoother_funct(b,L,tau)
%---------------------------------------------------------------------------------------
% 	INPUT  
%			 b:			(Tx4) BETA0	BETA1	BETA2	BETA3 
%			 L:			(Tx2) LAMBDA1 LAMBDA2 
%		 tau:			(Kx1) vector of Maturirites, where 1/4 = 3M or 1Q, 1/12 = 1M, etc and 30 is 30 Years.
%                 	
% 	OUTPUT       
%		 nss:			(TxK) matrix of zero-coupn yields at time T with maturity tau.
%========================================================================================
% 	NOTES :   if only beta0-bet2 and lambda 1 is given, use Siegel only model
%----------------------------------------------------------------------------------------
% Created :		10.06.2014.
% Modified:		10.06.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

% 
% input : beta and lambda paramters and a vector of maturities generall (1/4:1/4:30)' for quarterly
% maturities
% output: zero coupon yields, or yield curve.
% where b = BETA and L = TAU
%[BETA0	BETA1	BETA2	BETA3	TAU1	TAU2]

%b = b(isnan(b)==0);

% check if there are any nans in b as we are taking them from GSW.
if sum(isnan(b))==1
		% this is the nelson-siegel model
    nss =  b(1) + b(2)*(1-exp(-tau./L(1)))./(tau./L(1)) + ...
                  b(3)*((1-exp(-tau./L(1)))./(tau./L(1))-exp(-tau./L(1)));
else
		% this is the nelson-siegel-svensson model
    nss =  b(1) + b(2)*(1-exp(-tau./L(1)))./(tau./L(1)) + ...
                  b(3)*((1-exp(-tau./L(1)))./(tau./L(1))-exp(-tau./L(1))) + ... 
                  b(4)*((1-exp(-tau./L(2)))./(tau./L(2))-exp(-tau./L(2)));
end;



        
