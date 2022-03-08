function [bhat_ada_Lasso,FitInfo,ada_Lasso_rescaled] = adaptiveLasso(y,x,lambda,gamma_)
% implements the Adaptivle Lasso of Zou (2007)
% db
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(3,'lambda',[]);
SetDefaultValue(4,'gamma_',1);

T				= size(y,1);
% demean y, normalize x to zero means and unit variances, see (Zhou, Buehlman all of Lasso lit.)
mu_y		= mean(y);
YY			= demean(y);									% demean y.
mu_x		= mean(x);
std_x		= std(x);
XX			= zscore(x);									% standardise x.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get first stage consistent estimate (OLS or RIDGE if K > T)
% b_ols 	= fastols(y,x,1)						% note NO constant in regression to be bhat_ols
% bin_w		= XX\YY;											% note NO constant in regression to be bhat_ols
bin_w		= ridge(YY,XX,1);							% using ridge instead with Lambda = 1. Lambda = 0 => OLS

% compute weights W
w				= abs(bin_w).^(-gamma_);
% compute X** 
Xw			= XX./repmat(w',T,1);

% Solve lasso problem with Xw now
[bhat, FitInfo] = lasso(Xw,YY,'Lambda',lambda);

% get mean and number of Lambda values
mean_y	= FitInfo.Intercept(1);
Nlambda = length(FitInfo.Lambda);

% Compute bhat_w
bhat_w	= bhat'./repmat(w',Nlambda,1);
bhat_w	= bhat_w';

% forecast, forecast errors and MSE for all N lambda values 
% (note: mean_y not really needed here since we demean y, but for more general case)
yhat		= mean_y + Xw*bhat_w;
uhat		= repmat(YY,1,Nlambda) - yhat;
mse			= mean(uhat.^2);

FitInfo.MSE 	= mse;				% this overwrites the OLD normal LASSO MSE`
FitInfo.yhat 	= yhat;				% also output the fitted y 
FitInfo.uhat 	= uhat;				% and the residuals
FitInfo.mu_y  = mean(y);		% mean of y

% output
bhat_ada_Lasso = bhat_w;

if nargout > 2
% rescale bhat_ada_Lasso estimates to un-standardised/normalised data to be comparabel to OLS estimates.
	%ada_Lasso_rescaled.bhat = bhat_ada_Lasso./repmat(std_x',1,size(bhat_w,2));
	ada_Lasso_rescaled.bhat = bhat_ada_Lasso./std_x';
	ada_Lasso_rescaled.cnst = mu_y - mu_x*ada_Lasso_rescaled.bhat;
end

