function w = reweight(w0)

% reweigths a vector to have weights sum to unity.

w = w0./repmat(sum(w0),size(w0,1),1);
