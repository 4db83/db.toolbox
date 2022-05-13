function [beta, aout] = fastols(y,X,no_const)
% F: fit beta parameter by OLS
% beta = fastols(y,x), set no_constant = 1 to exclude intercept term
SetDefaultValue(3,'no_const',0)			% default is to include a constant

% remove any missing/nan values
Inan	= anynan([y X]);
y			= y(~Inan,:); 
X			= X(~Inan,:);

T	= size(X,1);				

% check if first column is unit vector for constant
x1 = X(:,1);
Ic = (sum(x1==1)==T); % Ic == 1 if constant is included in x

%if (no_const==1)

if no_const==0
% check if constant already in, if not, add a constant
	if ~Ic
		X = [ones(T,1) X];
	end
else
	if Ic
		disp(' You want to exclude a constant in the regression model, but x includes a vector of ones')
		disp(' The constant (vector of ones) was excluded from the regression model')
		X = X(:,2:end);
	end
end

% final size of design matrix X'X
KK = size(X,2);
xpx			= X'*X;
invxpx	= xpx\eye(KK);
beta		= invxpx*(X'*y);        
% beta  = X\y; % IS MUCH MUCH SLOWER!!!

% compute also OLS residuals and SSE = u'*u;
u		= y-X*beta;
SSE	= u'*u;
sigma_2		= SSE/T;							% this is the MLE variance
Var_beta	= invxpx.*sigma_2;		% standard OLS var(beta) not HAC
% output a structure
aout.u = u;
aout.sigma2 = sigma_2;
aout.var_beta = Var_beta;
aout.SSE = SSE;
aout.se = sqrt(diag(Var_beta));

