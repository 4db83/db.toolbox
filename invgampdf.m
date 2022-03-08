function py = invgampdf(x,a,b)
% INVGAMPDF Inverse Gamma probability density function.
% CALL AS:	py = invgampdf(x,a,b)
% p(y|a,b) = b^{a}/Gamma(a) * x^{-(a+1)} * exp(-b/x).
% x > 0.
% a > 0 (shape parameter)
% b > 0 (scale or rate paramter. 
% NOTE: This pdf goes with invgamrnd = b ./ randg(a). 
% I am using scale and not inverse scale.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% compute log of gamma function for numerical stability
lnGamma_a		= gammaln(a);
% this is the normalizeing constant
norm_const	= b^a/exp(lnGamma_a);
% kernel of invgamma pdf is:
inv_gam_kernel	= x.^(-(a+1)).*exp(-b./x);
% now form appropriate pdf if InvGam(a,b)
py = norm_const*inv_gam_kernel;
