function out = vech(sigma,K)
% vech(X,K) is the elements on and below the K-th diagonal of X.  
% K = 0 is the main diagonal.
% K > 0 is above the main diagonal
% K < 0 is below the main diagonal.

if nargin < 2;
  K = 0;
end;

tmp = tril(sigma,K);
out = sigma(tmp(:)~=0);

