function KFSout = kfs2ssm(KFS_object, Yin)
% put my Kalman Filter/Smoother output into Matlab state-space model from

[Nr,Nc] = size(Yin);

if Nc < Nr 
	Y = Yin';
else
	Y = Yin;
end

SSM_model	= ssm(KFS_object.Phi, ...
								KFS_object.S*chol(KFS_object.Q), ...
								KFS_object.M, ...
								sqrt(KFS_object.H), ...
								'Mean0', KFS_object.a00, ...
								'Cov0' , KFS_object.P00, ...
								'StateType', 2*ones(length(KFS_object.a00),1));
						
% Time period sample size
TT = length(Y);

% space allocation for filtered states and covariance matrices
att = zeros([size(KFS_object.Phi,1) TT]);
Ptt = zeros([size(KFS_object.Phi  ) TT]);
% space allocation for smoothed states and covariance matrices
atT = zeros([size(KFS_object.Phi,1) TT]);
PtT = zeros([size(KFS_object.Phi  ) TT]);

[~,~,filter_out] = filter(	SSM_model, (Y - KFS_object.D)' );
[~,~,smooth_out] = smooth(	SSM_model, (Y - KFS_object.D)' );

for i = 1:TT
	% filtered output
	att(:,i)		= filter_out(i).FilteredStates;
	Ptt(:,:,i)	= filter_out(i).FilteredStatesCov;
	% smoothed output	
	atT(:,i)		= smooth_out(i).SmoothedStates;
	PtT(:,:,i)	= smooth_out(i).SmoothedStatesCov;
end

% KFSout.att	= filter(		SSM_model,(Y - KFS_object.D));					% Kalman Filter
% KFSout.atT	= smooth(		SSM_model,(Y - KFS_object.D));          % Kalman Smoother

KFSout.att	= att';  % Kalman Filter   states (TxK)
KFSout.atT	= atT';  % Kalman Smoother states (TxK)

KFSout.Ptt	= Ptt;   % Kalman Filter   statesCov (KxKxT)
KFSout.PtT	= PtT;   % Kalman Smoother statesCov (KxKxT)

KFSout.draw = simsmooth(SSM_model,(Y - KFS_object.D)');         % Durbin Koopman Simsmoother
KFSout.ssm	= SSM_model;																				% return the SSM object as well