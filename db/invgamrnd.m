function r = invgamrnd(a,b,varargin)
%INVGAMRND Random arrays from gamma distribution.
%   R = INVGAMRND(A,B) returns an array of random numbers chosen from the
%   gamma distribution with shape parameter A and scale parameter B.  The
%   size of R is the common size of A and B if both are arrays.  If
%   either parameter is a scalar, the size of R is the size of the other
%   parameter.
%
%   R = INVGAMRND(A,B,M,N,...) or R = INVGAMRND(A,B,[M,N,...]) returns an
%   M-by-N-by-... array.
%
%  db: in the bayesian conditiona posterior for sigma2, this corresponds to
% 
%		p(sigma2|Other) prop. to sigma2^-(N/2+a0+1)*exp{-1/sigma2*(sum(y-mu)^2 /2 + b0}
%		which is IG(a,b), where a = (N/2+a0) and b = (sum(y-mu).^2 /2 + b0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin < 2
    error(message('stats:invgamrnd:TooFewInputs'));
end

% [err, sizeOut] = statsizechk(2,a,b,varargin{:});
% if err > 0
%     error(message('stats:invgamrnd:InputSizeMismatch'));
% end

sizeout = cell2mat(varargin);
% Return NaN for elements corresponding to illegal parameter values.
a(a < 0) = NaN;
b(b < 0) = NaN;

r = b ./ randg(a,sizeout);
