%{ Function: Computes LOESS Non-Parametric mean.
% ______________________________________________________________
%
% DESCRIPTION:
%
% 	Computes LOESS Non-Parametric mean as well as first and 
% 	second derivatives if p>0 and p>=3 respectively, stored in
% 	derivs.        
% ______________________________________________________________
%
% Usage:	[yhat,se,results]=loess(x,xgrid,y,h0,A,p).                                               
% ______________________________________________________________
%
% INPUT:
%		
%       x		= Independent varible.
%    xgrid	= Grid over which to compute the LOESS
%       y		= Dependent variable.                                          
%      h0		= Plug in Bandwidht. Note that it will be automatically
%							adjusted to 'epan' and 'quar' if they are used as options.
%							So only need to put in h0=silverman(x).        
%    	A = String, either 'gaus', 'epan' or 'quar'.
%   	p = Polynomial approximation used. If 0 then equivalent to	
%  			Nadaraya Watson, and no derivatives are computed. If 1
% 			then LOESS and first derivative is stored in derivs. If
% 			3 then second derivatve is stored in derivs as well.
% OUTPUT:
%
% 	 yhat = Estimate of E(y|x).
% 	   se = Standard error of E(y|x).
%
%   and a structure of with the following
%   
%   results.derivs;     = if p>=3 Tx2 vector of first and second derivative estimates.
%   results.Wr;         = Nadaray-Watson weights.
%   results.h;          = Bandwidht used.
%   results.T;          = Sample size.
%   results.K2;         = integral of squred weighting kernel.
%   results.fx0;        = densitiy estimat of conditioning variable.
%
%  
%	
% Notes:-------------------------------------------------------
% 		None.
% ______________________________________________________________
%   
%   		Created by Daniel Buncic on 13/9/2005.
% 			Modified on: 13/09/2005.
% 			Modified on: 25/09/2006.
%				Modified on: 16/06/2008. (vectorised).
%}

function [yhat,se,results]=loess(x,grid,y,h0,A,p)
T		= length(y);
nG	= length(grid);
nX	= length(x);

%% Storage Vectors
yhat		= zeros(nG,1);
dyhat		= zeros(nG,1);
ddyhat	= zeros(nG,1);

%% Selection Vectors
e		= zeros(p+1,1);	e(1)		= 1;
de	= zeros(p+1,1);	de(2)		= 1;
dde	= zeros(p+1,1);	dde(3)	= 1;

% u grid matrix to be evaluated in Kernel
u 	= repmat(x,1,nG) - repmat(grid',nX,1);

% Kernal density functions.
gaus = inline('exp(-0.5*(u./h).^2)./(sqrt(2*pi).*h)','h','u');
epan = inline('3/4*(1-(u./h).^2).*(abs((u./h))<=1)','h','u');
quar = inline('15/16*((1-(u./h).^2)).^2.*(abs((u./h))<=1)','h','u');

if A=='gaus'
	h 	= h0*0.7764/0.7764;
	Kz  = gaus(h,u);
elseif A=='epan'
	h	= h0*1.7188/0.7764;
	Kz  = epan(h,u);
else %% i.e when A=='quar';
	h=h0*2.0362/0.7764;
	Kz  = quar(h,u);
end;

Wr = Kz./repmat(sum(Kz),rows(Kz),1);

%% Computing the LOESS here.
for k = 1:nG
	X=[];wX=[];
	for i=1:p+1
		X =[X (x-grid(k)).^(i-1)];
        wX=[wX Kz(:,k).*(x-grid(k)).^(i-1)];
    end;
    bhat=(wX'*X)\(wX'*y);		% Faster inversion then with inv(.) command.
	yhat(k)=e'*bhat;					% selctor vecotor.
	if p>0
		dyhat(k)  = de'*bhat;		% first derivative estimte.
	end;
	if p>=3
		ddyhat(k) = dde'*bhat;	% second derivative estimate.
	end;
end;

%% First derivative output if p>0.
if p>0
	derivs=dyhat;
	else
	derivs=[NaN];
end;

%% Second derivative output if p>=3.
if p>=3
	derivs=[dyhat ddyhat];
	else
	derivs=dyhat;
end;

%% Computing the standard error of yhat.
if A=='gaus'
	K2=1/(2*sqrt(pi));
	fx0	= mean(gaus(h,u))';
elseif A=='epan'
	K2=3/5;
	fx0	= mean(1/h*epan(h,u))';
else %% i.e when 'quar';
	K2=5/7;
	fx0	= mean(1/h*quar(h,u))';
end;

sig0 = Wr.*(repmat(y,1,rows(grid)) - repmat(yhat',rows(x),1)).^2;
sig  = sum(sig0)';

if sum(fx0==0)~=0;
	a_		= find(fx0==0);
	fx0(a_)	= eps;
end

se=sqrt((K2/(T*h))*sig./fx0);
   
results.derivs	= derivs;
results.Wr			= Wr;
results.h				= h;
results.T				= T;
results.K2			= K2;
results.fx0			= fx0;
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   