function [yhat, uhat, beta, P] = tvp_homo(y,x,lambda,var_H)
% Simple Time-varying parameter regression model with EWMA type heteroskedastic
% variance for the measurement equation.
% Model is as follows:
%
%		y(t)	= beta(t)*x(t)	+ h(t)*u(t), u(t)~N(0,1);
%		beta(t)	= beta(t-1)		+ q(t)*e(t), e(t)~N(0,1);
%
% where h(t) is the time varying standard deviation of the measurement equation.
% and q(t) is the time varying standard deviation of the state equation 
% which is modelled as an EWMA process of the form
% H(t) = C + (1-kappa-0.02)*u(t-1).^2 + kappa*H(t-1).
% Here we do not impose the unit root restriction on EWMA volatiliy, but rather assume
% that that it is persistent with degree .98 and it has a non-zero intercept. 
%-------------------------------------------------------------------------------------
% Daniel Buncic 26.11.2013.
%-------------------------------------------------------------------------------------

[T,k]	= size(x);

if nargin < 4
	var_H = 0.1;
end;

% space allocation and initial conditons for the state means and variances
P	= zeros(k,k,T); 
beta= zeros(k,T);		
KG	= zeros(k,T);		
yhat= zeros(T,1);
uhat= zeros(T,1);
I	= eye(k);			% for fast updating of P_tt

% volatility is time invariant and fixed.
H	= var_H*ones(T,1);		% volatility of state equaiton.



% Initialisation: unconditonal mean and variance of the states (stationary states)
b_00		= zeros(k,1);
P_00		= 1*eye(k)/lambda;	
KG1			= P_00*x(1,:)'/(x(1,:)*P_00*x(1,:)' + H(1));
yhat(1)		= x(1,:)*b_00;
uhat(1)		= y(1) - yhat(1);
beta(:,1)	= b_00 + KG1*uhat(1);
P(:,:,1)	= P_00 - KG1*x(1,:)*P_00;

for t = 2:T;
	% prediction of states (where btt_1 means beta_t|t-1 and Ptt_1 means P_t|t-1)
	btt_1	= beta(:  ,t-1);
	Ptt_1	= P(:,:,t-1)/lambda;	% MSE (Var of states) approximation
	% forecasting y_t+h
	yhat(t) = x(t,:)*btt_1;
	uhat(t) = y(t) - yhat(t);
	% EWMA for H_t (subtract 0.03 to avoid having an integrated model
	%H(t)	= 0.01 + (1-kappa-0.02)*uhat(t-1).^2 + kappa*H(t-1);
	%H(t) = 1;
	% Kalman Gain
	KG = Ptt_1*x(t,:)'/(x(t,:)*Ptt_1*x(t,:)' + H(t));
	% Updating
	beta(:,t)	= btt_1 + KG*uhat(t);
	P(:,:,t)	= (I - KG*x(t,:))*Ptt_1;
end;





