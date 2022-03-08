function w = forecast_combine_gridsearch(y,x,Ngrd)
% does simple grid search based forecast combination
% A	= w*f1 + (1-w)*f2 or 
%			(A-f2) = w*(f1-f2)
%				y		 = w*w representation as used above (so relative to forecast 2, f2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% y			=  Fhat.yout.y(1:80) -yC;
% x			= yF-yC;
% Ngrd	= 1e4;

if nargin < 3
	Ngrd = 1e3;
end;

wgrid	= linspace(0,1,Ngrd);
fe2		= zeros(Ngrd,1);
T			= size(y,1);

YY		= repmat(y,1,Ngrd);
XX		= repmat(wgrid,T,1).*repmat(x,1,Ngrd);
FE2		= (YY-XX).^2;
FE_		= mean(FE2);

% find Indicator where minimum
I_min	= find(min(FE_)== FE_);
% return weight w at minimum
w			= wgrid(I_min);

%lsqlin(x,y,[],[],[],[],0,1)
%lsqlin([x1 x2],y,[],[],[1 1;0 0],[1;0],[0;0],[1;1])