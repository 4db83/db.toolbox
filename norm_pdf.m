function y = norm_pdf(x,mu,V)
%	pr_norm Normal probability density function (pdf).
%   Y = pr_norm(X,MU,SIGMA) returns the pdf of the normal distribution with
%   mean MU and standard deviation SIGMA, evaluated at the values in X.
%   The size of Y is the common size of the input arguments.  A scalar
%   input functions as a constant matrix of the same size as the other
%   inputs.
%
%   Default values for MU and SIGMA are 0 and 1 respectively.
%
%   See also NORMCDF, NORMFIT, NORMINV, NORMLIKE, NORMRND, NORMSTAT.
%	WIthouth error checking.


y = exp(-0.5*(x-mu).^2./V)./(sqrt(2*pi.*V));
