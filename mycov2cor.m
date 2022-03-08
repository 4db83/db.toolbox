%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Covariance to correlation
 % function out = mycov2cor(V)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [corrV,Ipsd] = mycov2cor(V,makePSD)
% check if inpupt matrix is PSD
[~,p] = chol(V);

if nargin < 2
	makePSD = 0;
end;

if makePSD == 1
% if not PSD, find the negative eigenvalue and set it small positive one, ie, eps, make up V again
if p~=0
	%disp('non PSD')
	[Q,L]					= eig(V);
	L(find(L<0))	= eps;
	VV						= Q*L/(Q); % much stabler than Q*L*inv(Q
	% use VV for V now instead
	V = VV;	
end
end

A	= sqrt(1./diag(V));
% much faster than corrV = diag(A)*V*diag(A)
corrV	= V .* (A*A');

% make sure diagonal elemnts are exactly equal to 1.
corrV(logical(speye(size(corrV)))) = 1;

Ipsd = p;

% OLD VERSION
% for k=1:size(V,1);
% 	corrV(k,k) = 1;
% end

