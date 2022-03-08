function r = multivtrnd(S,df,N)
%MULTIVTRND Random matrices from the multivariate t distribution.
%   R = MULTIVTRND (S,DF,N) returns an N-by-D matrix R of random numbers from
%   the multivariate t distribution with Covariance parameters S and
%   degrees of freedom DF.
%	
%	This is a modification of the mvtrnd function of matlab and now creates draws
%	withe with the covariance matrix as the scale (and not correlation matrix).
%	
%	One could also use the original mvtrnd function and then just scale back by
%	multiplying by sqrt(s * s') that is, call:
%		r = sqrt(d*d').*mvtrnd(S, df, 500), where d = diag(S) and S as below.
%   Example:
%
%      S = [1.3 .4; .4 0.5]; df = 2;
%      r = multivtrnd(S, df, 500);



[m,n] = size(S);
if (m ~= n)
   error(message('stats:mvtrnd:BadCorrelationNotSquare'));
end

df = df(:);
if ~(isscalar(df) || (isvector(df) && length(df) == N))
   error(message('stats:mvtrnd:InputSizeMismatch'));
elseif any(df <= 0)
   error(message('stats:mvtrnd:BadDF'));
end

% Make sure C is a correlation matrix, then get Cholesky factor
% s = diag(S);
% if (any(s~=1))
%    S = S ./ sqrt(s * s');
% end

[T,err] = cholcov(S);
if (err ~= 0)
   error(message('stats:mvtrnd:BadCorrelationSymPos'));
end

% Generate normal and sqrt(normalized chi-square), then divide
r = randn(N, size(T,1)) * T;				% MNormal(0,TT')
x = sqrt(df/2./gamrnd(df./2, 1, N, 1));		% sqrt of IG(df/2,df/2);
%x = sqrt(df/2./randg(df./2,N,1));			% sqrt of IG(df/2,df/2);
r = r .* x(:,ones(n,1));					% Mt(df,0,TT');

