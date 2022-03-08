%% F: Computes the long-run variance using Newey West type hac
%%----------------------------------------------------------------------------------------
%% Usage : lrvar=nwvar(y,nlag);
%% 
%% Input : y = (nx1) time series vector.
%% 		 nlag= number of lags to be included in the HAC covariance procedure.
%%
%% Output: lrvar = long-run or HAC variance. 
%%----------------------------------------------------------------------------------------	

function lrvar=nwvar(y,nlag);
T=rows(y);
[bhat,V,rsds,results] = nwest(y,ones(T,1),nlag);
lrvar=V;