function gama = acvf(yIn,n)
% ------------------------------------------------------------------------------------------------------
% FUNCTION: Computes the Auto-covariance function ACVF for time series input dy;
% ------------------------------------------------------------------------------------------------------
% CALL AS: 
%			gamma = acvf(dy,10);
% ------------------------------------------------------------------------------------------------------
% INPUT: 
% dy						= data vector, can be fints object as well.
%									Will check for missing values and remove them.
% n							= last_quarter of the dates_in datestring, ie. 1, 2, 3 or 4. This is needed so that the 
%									last quarter is appropriately added to the series.
%									If not supplied, taken from the last quarter from the dates_in vector.
% 
% OUTPUT:
% gama					= (n+1)x1 vector of Autocovariances, with the first entry being gamma(0), the variance
% ------------------------------------------------------------------------------------------------------
% db (21.02.2018)
% ------------------------------------------------------------------------------------------------------

%% set defaul number of lags
SetDefaultValue(2,'n',20);

% check if financial time series object
if isa(yIn,'fints')
	yIn = fts2mat(yIn);
end

% take out any nans
y = removenan(yIn);
% compute acfs 
rho = autocorr(y,n);
% compute var(y) deviding by T not T-1.
gamma0	= var(y,1);
% ACVF vector
gama		= rho.*gamma0;

