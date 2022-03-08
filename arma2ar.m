% function: ARMA2AR(inf)
% Input:
%       aL = alpha(L) 1x(p+1) vector lag polynomial of AR terms: [1 -a1 -a2 ... -ap]
%       bL = beta(L) 1x(q+1) vector lag polynomial of MA terms: [1 b1 b2 ... bq]
%       R  = number of MA(inf) terms.
%
% Output:
%       ar_infty = R+1 terms of the AR(inf) represention with pi_0 = 1.

function ar_infty = arma2ar(aL,bL,R)
arout       = deconv([aL(:);zeros(R+size(aL,2)+size(bL,2),1)],bL(:));
ar_infty    = arout(1:R+1);
end