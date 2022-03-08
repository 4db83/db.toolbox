function [yhat, uhat, beta, P, H] = tvp_ewma(y,x,Params,Priors)
% Simple Time-varying parameter regression model with EWMA type heteroskedastic
% variance for the measurement equation.
% -------------------------------------------------------------------------------------
% Model is as follows:
% 
% 	y(t)		= beta(t)*x(t)	+ h(t)*u(t), u(t)~N(0,1);
% 	beta(t)	= beta(t-1)		  + q(t)*e(t), e(t)~N(0,1);
%  
% where h(t) is the time varying standard deviation of the measurement equation.
% and q(t) is the time varying standard deviation of the state equation 
% which is modelled as an EWMA process of the form
% H(t) = C + (1-kappa-0.02)*u(t-1).^2 + kappa*H(t-1).
% Here we do not impose the unit root restriction on EWMA volatiliy, but rather assume
% that that it is persistent with degree .98 and it has a non-zero intercept. 
% -------------------------------------------------------------------------------------
% Daniel Buncic 26.11.2013.
% -------------------------------------------------------------------------------------

% Parameters (Params = [Lambda Kappa Alpha]) TVP EWMA with foregetting factors for variance approximation.
% Lamda		= Params.Lamda;		% forgetting factor for the variance equation P_tt.
% Kappa		= Params.Kappa;		% EWMA weighting term

% Parameters required for TVP (Params = [Lambda Kappa Alpha]) TVP EWMA with foregetting factors for variance approximation.
Lamda		= Params(1);			% forgetting factor for the variance equation P_tt.
Kappa		= Params(2);			% EWMA weighting term

% invert outside loop to save time
inv_Lamda		= 1/Lamda;				

[T,k]		= size(x);


% -------------------------------------------------------------------------------------
% space allocation and predefinitions
% -------------------------------------------------------------------------------------
P				= zeros(k,k,T); 
beta		= zeros(k,T);		
yhat		= zeros(T,1);
uhat		= zeros(T,1);
H				= zeros(T,1);						
I				= eye(k);								% define Identity matrix ones.

% -------------------------------------------------------------------------------------
% Initialisation/Priors of mean and variance of the states and H volatiliy.
% These Initialisation/Priors need to be matched to the Koop & Korbilis code 
% to enusre that they give the exact same results.
% -------------------------------------------------------------------------------------
b_00 	= Priors.beta_mean;
P_00	= Priors.beta_var;
H_00	= Priors.H_init;

% -------------------------------------------------------------------------------------
% Main Kalman Filter (loop over time).
% -------------------------------------------------------------------------------------
for t = 1:T
	% prediction of states (where btt_1 means beta_t|t-1 and Ptt_1 means P_t|t-1)
	if t == 1		% for the first observation
		btt_1		= b_00*ones(k,1);
		Ptt_1		= P_00*eye(k);
		H(t) 		= H_00;
	else				% for t > 2.
		btt_1		= beta(:,t-1);
		Ptt_1		= P(: ,:,t-1)*inv_Lamda;		% MSE (Var of states) approximation
		% EWMA for H_t (subtract 0.02 to avoid having an integrated model
% 		H(t)		= 0.01 + (1-Kappa-0.02)*uhat(t-1).^2 + Kappa*H(t-1);	% this is more like a non-integrated GARCH(1,1)
		H(t)		= (1-Kappa)*uhat(t-1).^2 + Kappa*H(t-1);								% this is the original form
		%H(t)			= 3.0278e-04;		% fix the variance to be non-time varying value for simplicity.
	end
	% precompute xt for speed
	xt				= x(t,:);	
	% forecasting y_t+1|t, u_t+1|t
	yhat(t)		= xt*btt_1;
	uhat(t)		= y(t) - yhat(t);
	% Kalman Gain
	KG				= Ptt_1*xt'/(xt*Ptt_1*xt' + H(t));
	% Updating
	beta(:,t)	= btt_1 + KG*uhat(t);
	P(:,:,t)	= (I	  - KG*xt)*Ptt_1;
% KGout(:,t)= KG;
end

beta = beta';
