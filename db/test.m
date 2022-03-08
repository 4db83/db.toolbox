clear all;clc;clf;

x = linspace(0,3,1000)';
w = zeros(size(x));
%Compute the truncated kernel density.

cTR = 2; % Renormalization constant
TR = (abs(x) <= 1);
TRRn = (abs(cTR*x) <= 1);
wTR = w;
wTR(TR) = 1;
wTRRn = w;
wTRRn(TRRn) = 1;
%Compute the Bartlett kernel density.

cBT = 2/3; % Renormalization constant
BT = (abs(x) <= 1);
BTRn = (abs(cBT*x) <= 1);
wBT = w;
wBT(BT) = 1-abs(x(BT));
wBTRn = w;
wBTRn(BTRn) = 1-abs(cBT*x(BTRn));
%Compute the Parzen kernel density.

cPZ = 0.539285; % Renormalization constant
PZ1 = (abs(x) >= 0) & (abs(x) <= 1/2);
PZ2 = (abs(x) >= 1/2) & (abs(x) <= 1);
PZ1Rn = (abs(cPZ*x) >= 0) & (abs(cPZ*x) <= 1/2);
PZ2Rn = (abs(cPZ*x) >= 1/2) & (abs(cPZ*x) <= 1);
wPZ = w;
wPZ(PZ1) = 1-6*x(PZ1).^2+6*abs(x(PZ1)).^3;
wPZ(PZ2) = 2*(1-abs(x(PZ2))).^3;
wPZRn = w;
wPZRn(PZ1Rn) = 1-6*(cPZ*x(PZ1Rn)).^2 ...
    + 6*abs(cPZ*x(PZ1Rn)).^3;
wPZRn(PZ2Rn) = 2*(1-abs(cPZ*x(PZ2Rn))).^3;
%Compute the Tukey-Hanning kernel density.

cTH = 3/4; % Renormalization constant
TH = (abs(x) <= 1);
THRn = (abs(cTH*x) <= 1);
wTH = w;
wTH(TH) = (1+cos(pi*x(TH)))/2;
wTHRn = w;
wTHRn(THRn) = (1+cos(pi*cTH*x(THRn)))/2;
%Compute the quadratic spectral kernel density.

argQS = 6*pi*x/5;
w1 = 3./(argQS.^2);
w2 = (sin(argQS)./argQS)-cos(argQS);
wQS = w1.*w2;
wQS(x == 0) = 1;
wQSRn = wQS; % Renormalization constant = 1
%Plot the kernel densities.

B		= @(z) ((1-z).*(z<1));
QS  = @(z) ( (1-6*z.^2+6*abs(z).^3).*(abs(z)<0.5) + 2*(1-abs(z)).^3.*((abs(z)>0.5).*(abs(z)<1)));
p  =	@(z) ( (1-6*z.^2+6*abs(z).^3).*(abs(z)<0.5) + 2*(1-abs(z)).^3.*((abs(z)>0.5).*(abs(z)<1)));
Z   = @(j,L) (j./(L+1));

PZ  = @(z) ( (1-6*z.^2+6*abs(z).^3).*(abs(z)<0.5) + ... 
							2*(1-abs(z)).^3.*((abs(z)>0.5).*(abs(z)<1)) );

fz = QS(x);
clf
plot(x,[wTR,wBT,wPZ,wTH,wQS],'LineWidth',2)
hold on
plot(x,w,'k','LineWidth',2)
%plot(x,B(x),'--g','LineWidth',2)
plot(x,PZ(x),':k','LineWidth',2)
hold off;
axis([0 3.2 -0.2 1.2])
grid on
title('{\bf HAC Kernels}')
legend({'Truncated','Bartlett','Parzen','Tukey-Hanning',...
    'Quadratic Spectral'})
xlabel('Covariance Lag')
ylabel('Weight')