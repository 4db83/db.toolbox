function [alpha_draw] = ffbs(y,Dt,M,H,Ct,Phi,Q,R,a1,P1) 
%{ CALL AS: [alpha_draw] = ffbs(y,Dt,M,H,Ct,Phi,Q,R,a1,P1) 
% Forward Filtering Backward Sampling a la Carter and Kohn (1994) 
% for multivariate states (alphas) general notation as in HARVEY 1992.
% State space model is:
% 		Observed:	y_t			= Dt + M*alpha_t			+ e_t;		Var(e_t) = H.
% 		State:		alpha_t = Ct + Phi*alpha_t-1	+ R*n_t;	Var(n_t) = Q.
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
% 						att_1	= Ct + Phi*a1;  	and 		Ptt_1	= Phi*P1*Phi' + RQR;
% This is just an initialization and not important per se for the Filter as it dissipates 	
% quickly, but good to keep in mind. 
% Ultimately, it is a question of where the initialization happens, ie., either t=1 (DK) or 
% at t=0, so that for t=1 we use already the predicted att_1 values (Ct + Phi*a1). 
%
% NOTE: ---------------------------------------------------------------------------------------------------
% This is the general notation in HARVEY. Also, R is a selection matrix to make 
% state dimension of alpha and Q dimensions consistent. Alternative is to pad Q matrix
% with extra zeros. I am using	Phi instead of T and M	instead of Z in the notation.
% Otherwise, notation as in HARVEY 1992 (T is sample size, k is dim of statevector alpha).
% RECURSIONS ARE TAKEN FROM: Durbin and Koopman (2012) 'Time Series Analysis By State Space 
% methods 2nd edition', page 86.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%}

% DIM(ALPHA) DIMENSION OF STATE VECTOR ALPHA
k = size(Phi,1);			

% check input size of observable vector Y which should be (nY x T)
[Nr, Nc] = size(y);

% SAMPLE SIZE
if Nr > Nc 
	T = Nr; 
	y = y';
else 
	T = Nc;
end;

% Get the dimension of the 'constants' Ct 
if size(Ct,2) == 1;	Ct = repmat(Ct,1,T); end;
% and Dt and make them of the papropriate size
if size(Dt,2) == 1; Dt = repmat(Dt,1,T); end;

% space allocation & initial conditons for the (updated) state means and variances
att	= zeros(k,T);
Ptt	= zeros(k,k,T);

% % SET R TO IDENTITY IF NOT SUPPLIED.
% if nargin < 8; R = eye(k); end;

% PRE-COMPUTE R*Q*R'
RQR = R*Q*R';

% UNCOMMENT: TO INITIALIZE LOG-LIKELIHOOD SUM AT 0.
% LL_sum	= 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALISE THE KF RECURSIONS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------------------------------------------------------------		
% UNCOMMENT	BELOW TO USE THIS INITIALIZATION A LA DURBIN & KOOPMAN (2012, SEE P.32 AND P.124) 
% AT A1 AND P1 (-> INITIALISATION AT T=1)
% ---------------------------------------------------------------------------------------------------------		
% att_1 = a1;	
% Ptt_1 = P1;
% ---------------------------------------------------------------------------------------------------------
% UNCOMMENT	BELOW TO USE KOOP & KOROBILIS START AT a0 and P0 (-> initialisation at t=0) and then use 
% predicted alpha_t|t-1. THIS IS ALSO WHAT THE SSM TOOLBOX IN MATLAB USES. SO LEAVE IT AS SUCH.
% ---------------------------------------------------------------------------------------------------------		
att_1 = Ct(:,1) + Phi*a1;				% att_1 = Phi*a1;
Ptt_1 = Phi*P1*Phi' + RQR;

% MAIN TIME SERIES LOOP (LOOPING OVER COLUMNS IN MATLAB IS FASTER THAN OVER ROWS)
for t = 1:T
	% FORECASTING (commented out because it is not needed, uhat = y - yhat is computed directly instead)
	% yhat		= Dt + M*att_1;
% ---------------------------------------------------------------------------------------------------------
	% PREDICTION ERROR uhat and error variance Ft
	uhat = y(:,t) - Dt(:,t) - M*att_1;
	% pre-computing Ptt_1M' (transpose)) for faster computation
	Ptt_1M_T = Ptt_1*M';
	% MSE/Variance of uhat
	Ft = M*Ptt_1M_T + H;					
	% (Nearly) the Kalman gain matrix 
	Kt = Ptt_1M_T/Ft;		% Kt	= Ptt_1*M'*inv(Ft)
	% UPDATING. computing and storing filtered states att and MSE Ptt
	att(:,t)	 = att_1 + Kt*uhat;
	Ptt(:,:,t) = Ptt_1 - Kt*M*Ptt_1;  
	% FORECASTING STATES
	att_1	= Ct(:,t) + Phi*att(:,t);
	Ptt_1	= Phi*Ptt(:,:,t)*Phi' + RQR;
% ---------------------------------------------------------------------------------------------------------
% 	% UNCOMMENT: for log-likelihood to be computed as well
% 	LL_t		= -0.5*( log(2*pi) + log(abs(Ft)) + uhat.^2./Ft );
% 	LL_sum	= LL_sum + LL_t;
% 	% UNCOMMENT: to store MSE for all t (to see the recursions settle from intial conditions).
% 	Ft_full(t,1) = Ft;
% ---------------------------------------------------------------------------------------------------------
end


%% BACKWARD SAMPLER 
% MN draws for simulation smoother and storage for state draws
alpha_draw = nan(k,T);                   
MN = randn(k,T);            

% LAST DRAW FROM THE STATE, FIRST TO START BACKWARDS RECURSION.
alpha_draw(:,T) = att(:,T) + chol(Ptt(:,:,T),'lower')*MN(:,T);      % alpha(T)~N(a(T),P(T)), 

% RESIZE PHI, CC, DUE TO R BEING NON-IDENTITY, R IS SELECTION MATRIX WHEN DIM(Q) < DIM(ALPHA)
RT_Phi = R'*Phi;

% LOOP TROUGH FROM T-2 TO 1. 
for n = (T-1):(-1):1
	% pre-computing some common terms
	Ptn	= Ptt(:,:,T);
	Ptn_RT_Phi = Ptn*RT_Phi';
	KK	= Ptn_RT_Phi/(RT_Phi*Ptn_RT_Phi + Q);
	eta	= alpha_draw(:,n+1) - Ct(:,n) - Phi*att(:,n);
	% location (mean)
	EA = att(:,n) + KK*(R'*eta);		
 	% scale (variance)
	VA = Ptn	- KK*RT_Phi*Ptn;							
	% draw alpha
	alpha_draw(:,n) = EA + chol(VA,'lower')*MN(:,n);
end;

% % RETURN DRAWS FROM THE STATES ONLY. 
alpha_draw = alpha_draw';





















































% EOF
