function [att,Ptt] = kalmanfilter(y,DD,M,H,CC,Phi,Q,R,a1,P1) 
%{ CALL AS: [att,Ptt] = kalmanfilter(y,DD,M,H,CC,Phi,Q,R,a1,P1) 
% Kalman Filter for multivariate states (alphas) general notation as in HARVEY 1992.
% State space model is:
% 		Observed:	y_t		= DD + M*alpha_t	 + e_t;		Var(e_t) = H.
% 		State:		alpha_t = CC + Phi*alpha_t-1 + R*n_t;	Var(n_t) = Q.
% 	
% where [e_t; n_t]  ~ MNorm([0; 0],[H 0; 0 Q];
% a1 and P1 are the initial values of the states and its Variance/Covariance matrix.
% If states are stationary, can initize at uncondtional mean of alpha_t, that is, the 
% AR(1) unconditonal mean of inv(I-Phi)*C and its variance inv(I-PhixPhi)vec(R*QR') or vec(Q).
%
% NOTE ON INITIALIZATION:
% DK use a_t = E(alpha_t|Y_{t-1}) and P_t = V(alpha_t|Y_{t-1}), but for the initialization
% they define a_1 = E(alpha_1) and P_1 = V(alpha_t), ie., unconditionally. 
% For the first time t=1 iteration the following are used:
% 						att_1 = a1;  and Ptt_1 = P1;
%
% In Koop and Korobilis (and most other treatments, see the DMA/DMS code), there is an extra 
% updating step, so that the following are used at time t=1:
% 						att_1	= CC + Phi*a1;  	and 		Ptt_1	= Phi*P1*Phi' + RQR;
% This is just an initialization and not important per se for the Filter as it dissipates 	
% quickly, but good to keep in mind. 
% Ultimately, it is a question of where the initialization happens, ie., either t=1 (DK) or 
% at t=0, so that for t=1 we use already the predicted att_1 values (CC + Phi*a1). 
%
% NOTE: 
% This is the general notation in HARVEY. Also, R is a selection matrix to make 
% state dimension of alpha and Q dimensions consistent. Alternative is to pad Q matrix
% with extra zeros. I am using	Phi instead of T and M	instead of Z in the notation.
% Otherwise, notation as in HARVEY 1992 (T is sample size, k is dim of statevector alpha).
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%}

% dimension of state vector alpha & sample size
k	= size(Phi,1);			

% check input size of observable vector
[Nr,Nc] = size(y);

if Nr > Nc; 
	T = Nr; 
	y = y';
else 
	T = Nc;
end;

% space allocation & initial conditons for the (updated) state means and variances
att	= cell(1,T);
Ptt	= cell(1,T);

% INTIAL CONDITIONS: unconditonal mean & variance of the states, only if stationary states.
if nargin < 10
	V_tmp	= (eye(k^2) - kron(Phi,Phi))\Q(:);	% inv(I-PhixPhi)*vec(Q) or vec(R*Q*R')
	V_alpha	= reshape(V_tmp,k,k);
	P1		= V_alpha;
end

if nargin < 9
	mu_alpha= (eye(k)-Phi)\CC;					% inv(I-Phi)*C
	a1		= mu_alpha;
end;

% SET R TO IDENTITY IF NOT SUPPLIED.
if nargin < 8; 	R = eye(k); end;

% PRE-COMPUTE R*Q*R'
RQR = R*Q*R';

% INITIALISE THE KF RECURSIONS 
% % a la Durbin & Koopman (2012, see p.32 and p.124) at a1 and P1 (-> initialisation at t=1)
att_1 = a1;	
Ptt_1 = P1;

% Koop & Korobilis start at a0 and P0 (-> initialisation at t=0) and then use predicted alpha_t|t-1.
% This is also what the SSM toolbox in matlab uses. so leave it as such.
att_1 = CC + Phi*a1;
Ptt_1 = Phi*P1*Phi' + RQR;

% % UNCOMMENT: to initialize log-likelihood sum at 0.
% LL_sum	= 0;

for t = 1:T;
	% FORECASTING 
	% yhat		= DD + M*att_1;
% --------------------------------------------------------------------------------------------		
	% PREDICTION ERROR uhat and error variance Ft
	uhat		= y(:,t) - DD - M*att_1;
	% uhat		= y(:,t) - yhat;
	% pre-computing Ptt_1M'
	Ptt_1M_T	= Ptt_1*M';
	% MSE/Variance of uhat
	Ft			= M*Ptt_1M_T + H;					
	% (Nearly) the Kalman gain matrix 
	Kt			= Ptt_1M_T/Ft;		% Kt	= Ptt_1*M'*inv(Ft)
	% UPDATING. computing and storing filtered states att and MSE Ptt
	att{1,t}	= att_1 + Kt*uhat;
	Ptt{1,t}	= Ptt_1 - Kt*M*Ptt_1;  
	% FORECASTING STATES
	att_1		= CC + Phi*att{1,t};
	Ptt_1		= Phi*Ptt{1,t}*Phi' + RQR;
% ----------------------------------------------------------------------------------------	
% 	% UNCOMMENT: for log-likelihood
% 	LL_t		= -0.5*( log(2*pi) + log(abs(Ft)) + uhat.^2./Ft );
% 	LL_sum		= LL_sum + LL_t;
% 	% UNCOMMENT: to store MSE for all t (to see how to settle from intial conditions).
% 	Ft_full(t,1) = Ft;
% ----------------------------------------------------------------------------------------	
end;




% EOF