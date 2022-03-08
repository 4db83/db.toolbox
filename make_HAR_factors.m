function rv_har = make_HAR_factors(rv_data)
% makes the HAR structure. NOTE. this Tx3 matrix will then need to be lagged h times
% to be called in a OLS HAR structure regression. 
% call as:rv_har = make_HAR(rv_data)
% where:	rv_har = Tx3 matrix of HAR factors, with the first entry being 
%									RV_{t}^d (just the lagged daily component)
%									RV_{t}^w 1/5[RV_{t}+RV_{t-1}+RV_{t-2}+RV_{t-3}+RV_{t-4}] (5 terms)
%									RV_{t}^m 1/22[RV_{t}+RV_{t-1}+...+RV_{t-20}+RV_{t-21}] (22 terms)
% db
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%			

RV			= [rv_data mlag(rv_data,21)];
rv_har	= [RV(:,1) mean(RV(:,1:5),2) mean(RV(:,1:22),2)];

