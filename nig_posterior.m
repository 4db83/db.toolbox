function postpars = nig_posterior(olsfit,prior)

W_    	= (olsfit.xpx + inv(prior.V0));
beta_ 	= W_\(olsfit.xpx*olsfit.bhat + prior.V0\prior.beta0);
      	
a_    	= olsfit.N + prior.a0;
      	
SSE_  	= prior.b0 ...
      	+ olsfit.y'*olsfit.y ...
      	+ prior.beta0'*inv(prior.V0)*prior.beta0 ...
      	- beta_'*W_*beta_;

% log of marginal likelihood computation (for numerical stability)
log_py	= 0.5*(prior.a0*log(prior.b0) - olsfit.N*log(pi)) ...
		+ gammaln(a_/2) - gammaln(prior.a0/2) ...
		+ 0.5*(log(det(inv(W_))) - log(det(prior.V0))) ...
		- 0.5*a_*log(SSE_);

py		= exp(log_py);	
	
postpars.beta_  = beta_;
postpars.W_     = W_;
postpars.a_     = a_;	% note the slight change in notation I do not devide by 2 here
postpars.SSE_   = SSE_; % note the slight change in notation I do not devide by 2 here
postpars.Sigma_	= SSE_/a_*inv(W_); 
postpars.py		= py;	
postpars.log_py = log_py;

% these are not really needed since they have already computed but just in case one calls them
postpars.v_ 	= a_;	
postpars.b_		= SSE_;

      
%% alternative forms (check which one is the fastest later)
% SSE_  = prior.b0 + olsfit.u'*olsfit.u + (olsfit.bhat - prior.beta0)'*inv(inv(olsfit.xpx) + prior.V0)*(olsfit.bhat - prior.beta0)
% SSE_  = prior.b0 + olsfit.u'*olsfit.u + ...
%         olsfit.bhat'*olsfit.xpx*olsfit.bhat + ...
%         prior.beta0'*inv(prior.V0)*prior.beta0 - beta_'*W_*beta_

