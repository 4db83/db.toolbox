function [yfit,mse,best,sorts,subset_I] = dma_combine_model_forecasts_funct(y,yhat,pitt_1,sumS,subset,fixed_q)

% Constructs the various combined forecasts from all given forecasts from all models and
% one step ahead probablities Pr_{t|t-1} (pitt_1).
% The Forecasts are as follows:

% reweight pitt_1 just in case
%pitt_1 = reweight(pitt_1);

% Total number of Models M and in-sample sample size
[M,T] = size(yhat);

% some anonymous funcitons 
MSE   = @ (y,yhat) (mean((repmat(y,1,size(yhat,2))-yhat).^2));

% TVP Forecasts based on the full regressor set (no variable selection)
yfit.tvp		= yhat(M,:)';		% last entry in yhat has the full regressor set
% DMA forecasts based on Predicted Probabilities (eq. below eq. 16 in KK)
yfit.dma		= sum(pitt_1.*yhat)';
% DMA with EW weighted forecasts. 
yfit.dma_ew = mean(yhat)';

% (BEST model) forecasts (highest Predicted Probabilities)
% sort accordting to pitt_1 (SI) is the sort index.
[pitt_1_s, SI] = sort(pitt_1,'descend');	% SI is the sort index. %[sort_p, SI] = sort(pitt,'descend');		% This is what Koop and Korobilis are using current probs no predicted.

% Create pitt_1 sorted forecasts yhat for each time period based on Pr_{t|t-1} from SI index)
yhat_s = zeros(M,T);
for t = 1:T;
	yhat_s(:,t) = yhat(SI(:,t),t);
end;
% DMS is first row (Model) entry in yhat_s
yfit.dms	= yhat_s(1,:)';

%% DMQ forecast; averagig over q BEST models forecast, q is found by min(MSE) over all 
% or q could be fixed to fixed_q. 
mse_dmq			= zeros(M,1);
mse_dmq_ew	= zeros(M,1);

% to find the best_q need to loop through incrasing models.
for q = 1:M
	dmq						= sum(reweight(pitt_1_s(1:q,:)).*yhat_s(1:q,:))';
	mse_dmq(q)		= MSE(y,dmq);
	% now with equal weighting
	dmq_ew				= mean(yhat_s(1:q,:))';
	mse_dmq_ew(q)	= MSE(y,dmq_ew);
end

% Best fitting q averaged model and its forecast, q is best fitting q.
best_q			= find(min(mse_dmq)==mse_dmq);
best_q_ew		= find(min(mse_dmq_ew)==mse_dmq_ew);

% reweight inclusion probs. for best q models so that pitt_1_s terms sum to 1.
pitt_1_s_q	= reweight(pitt_1_s(1:best_q,:));
% DMQ with reweighted pitt_1
yfit.dmq		= sum((pitt_1_s_q.*yhat_s(1:best_q,:))',2);		% pitt weighted best q-models.
% DMQ with EW weighted forecasts. 
yfit.dmq_ew = mean(yhat_s(1:best_q_ew,:)',2);					

% based on fixed q, again with pitt_1 fixed q or ew weighting.
pitt_1_fixed_q	= reweight(pitt_1_s(1:fixed_q,:));
% fixed_q DMQ with reweighted pitt_1
yfit.dmq0				= sum((pitt_1_fixed_q.*yhat_s(1:fixed_q,:))',2);		% pitt weighte based on fixed q.
% fixed_q DMQ with EW weighted forecasts. 
yfit.dmq0_ew		= mean(yhat_s(1:fixed_q,:)',2);					

%% Based on Sub-set regressions
% find the vector of all regressro numbers including constant
%sumS			= sum(S,2);		% sum accross the columns in indicator vector S.
N_subsets = length(subset);
subset_I	= cell(N_subsets,1);

for n = 1:N_subsets
	subset_I{n}	= find(sumS==subset(n));
	% forecast for considered subset with EW
	ssfit_ew		= mean(yhat(subset_I{n},:)',2);
	% forecast for considered subset with pitt_1 weighting
	if length(subset_I{n}) == 1
		ssfit	= yhat(subset_I{n},:)';	
	else
		ssfit = sum((yhat(subset_I{n},:).*reweight(pitt_1(subset_I{n},:)))',2);
	end;
	yfit_full_ss_ew(:,n)= ssfit_ew;
	yfit_full_ss(:,n)		= ssfit;
end;

% MSE of subset regressison
mse_ss								= MSE(y,yfit_full_ss);
mse_ss_ew							= MSE(y,yfit_full_ss_ew);
% find best subset model by min(MSE)
best_SS_I							= find(mse_ss==min(mse_ss));
best_SS_I_ew					= find(mse_ss_ew==min(mse_ss_ew));
% best ftting subset regression forecasts.
yfit.best_subset			= yfit_full_ss(:,best_SS_I);
yfit.best_subset_ew		= yfit_full_ss_ew(:,best_SS_I_ew);
% best subset regressor number (including the constant)
best_subset_no.pitt_1 = subset(best_SS_I);
best_subset_no.ew			= subset(best_SS_I_ew);
% full subset storage for later retrial if needed.
yfit.full_subset			= yfit_full_ss;
yfit.full_subset_ew		= yfit_full_ss_ew;

%% Store/compute MSEs of different models % struct2mat(mse)'
mse.tvp								= MSE(y,yfit.tvp);
mse.dma								= MSE(y,yfit.dma);                                                  
% with EW
mse.dma_ew						= MSE(y,yfit.dma_ew);                                                  
mse.dms								= MSE(y,yfit.dms);
mse.dmq								= min(mse_dmq); 
% with EW
mse.dmq_ew						= min(mse_dmq_ew); 
mse.dmq_fixed					= MSE(y,yfit.dmq0);
mse.dmq_fixed_ew			= MSE(y,yfit.dmq0_ew);
% best subset regresions
mse.best_subset				= mse_ss(best_SS_I);
mse.best_subset_ew		= mse_ss_ew(best_SS_I_ew);
% full seubset regressions
mse.full_subset				= mse_ss;
mse.full_subset_ew		= mse_ss_ew;

% % aout.yfit = yfit;
% % aout.mse  = mse;
% % aout.SI   = SI;

% needed for bhat computations
best.q				= best_q;
best.SS_I			= best_SS_I;
best.SS_I_ew	= best_SS_I_ew;

sorts.SI			= SI;
sorts.yhat		= yhat_s;
sorts.pitt_1	= pitt_1_s;











