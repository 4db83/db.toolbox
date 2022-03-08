function Xout = standardizeData(X, Standardize_switch)
% F: Standardizes data X according to 3 criteria. 
%	0 demean only
% 1 demean and unit variance
% 2 to the [-1 1] interval.
% 3 nothing, return X without standardisation.
% ------------------------------------------------------------------------------------------------------
% Adapted from Mattias Villani's standardize function
% db 17.08.2017.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % X = infl_lags
% % X = randn(100,3);
% input (n x p) matrix to be standardized
[n,p] = size(X);

meanX = mean(X);
stdX	= std(X);
maxX	= max(X);
minX	= min(X);

SetDefaultValue(2,'Standardize_switch',0);

switch Standardize_switch
	case 0 % only zero mean (demean)
		Xout = X - repmat(meanX,n,1);
	case 1 % zero mean, unit variance
		Xout = (X - repmat(meanX,n,1))./repmat(stdX,n,1);
	case 2 % Restrict to [-1,1] interval
		a = 2./(maxX - minX);
		b = 1-a.*maxX;
		Xout = X.*repmat(a,n,1) + ones(n,1)*b;
	case 3 % Nothing, return X
		Xout = X;
end
