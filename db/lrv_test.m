%% long run variance estiatmion.
clc;clear all;tic;
if isempty(gcp('nocreate')); parpool; end;
seed(0)
T   = 5e1;              % sample size
B   = 5e1;              % burn-in
NS  = 1e1;              % number of simulations
% addpath(genpath(['.' filesep 'fncts'])) % path to fncts subfolder.

%% ARMA(p,q) parameter settings for simulation of the series.
C   = 0.3;				% constant
a1  = 0.9;
b1  = 0.2;
a_L	= [1 -a1];
b_L = [1 b1];
Cnst = ones(T,1);

% simulate ARMA(p,q) process
Zi  = C/sum(a_L);				% initial condition if needed.
x		= filter(b_L, a_L, C/sum(b_L) + randn(T+B,NS));
x		= x(B+1:end,:);     % drop burn in 

%% Run a simulation
LRV_hat					= zeros(NS,6);
LRV_hat_simple	= zeros(NS,6);

% if pre-whitenining is used, need to fit "best" ARMA(p,q) model to x series, than use the 
% LRV formula for residuals to find LRV of x as LRV(resduals)*Psi(1)^2. (see notes for details), 
p = 1; q = 1; c = 1; 
% ARMA(p,q) fitting paramter choices.
parfor (s = 1:NS)
	% LRV with Pre-Whiteninig 
	[~,altvars]					= LRVwPW(x(:,s));
	LRV_hat(s,:)				= struct2array(altvars);
	% simple LRV without pre-whiteninig 
	[~,altvars_s]       = LRV(x(:,s));
	LRV_hat_simple(s,:) = struct2array(altvars_s);
	% NOTE: MATLAB's HAC returns the HAC estimate LRV/T NOT LRV ITSELF
	LRV_matlab(s,:)     = HAC(Cnst,x(:,s),'bandwidth','AR1MLE','weights','QS', ...
												'whiten',1,'smallT',false,'intercept',false,'display','off')*T;	
end;

%% PRINT TO SCREEN SIMULATION RESULTS
% true parametric Long-run variance from ARMA model parameters
LRV_0	= (sum(b_L)/sum(a_L))^2;sep(46,'=')
fprintf('True LR variance is:					%16.6f \n', LRV_0);
sep(46,'=')
	prnt1.fmt			= char('%16.6f');
	prnt1.cnames	= char('QS-Kernel', 'Bartlett-Kernel');
	prnt1.rnames	= char('PreWhite Off','AR(1)','ARMA(1,1)','RoT');
	myprint( reshape(mean(LRV_hat_simple),3,2),prnt1);
sep(46)
	prnt1.rnames	= char('PreWhite On ','AR(1)','ARMA(1,1)','RoT');
	myprint( reshape(mean(LRV_hat),3,2),prnt1);
sep(46)
fprintf('Matlab''s built in HAC function:   %12.6f \n', mean(LRV_matlab));
sep(46,'=')
toc;

