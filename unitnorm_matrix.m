function uM = unitnorm_matrix(MM)
% create a matrix with norm of each column equal to 1.

[rm,cm] = size(MM);
% storage space
uM			= nan(size(MM));

if rm ~= cm
	disp('Error: matrix must be square')
else
	for ii = 1:cm
		uM(:,ii) = MM(:,ii)./norm(MM(:,ii));
	end;
end;