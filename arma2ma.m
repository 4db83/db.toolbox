function ma_infty = arma2ma(aL,bL,R)
% function: ARMA2MA(inf)
% call as: ma_infty = arma2ma(aL,bL,R)
% Input:
%       aL = alpha(L) 1x(p+1) vector lag polynomial of AR terms: [1 -a1 -a2 ... -ap]
%       bL = beta(L) 1x(q+1) vector lag polynomial of MA terms: [1 b1 b2 ... bq]
%       R  = number of MA(inf) terms.
%
% Output:
%       ma_infty = R+1 terms of the MA(inf) represention with psi_0 = 1.

maout       = deconv([bL(:);zeros(R+size(aL,2)+size(bL,2),1)],aL(:));
ma_infty    = maout(1:R+1);
end
