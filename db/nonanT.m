function Tnonan = nonanT(x)

[T,k] = size(x);

Tnonan = zeros(k,1);

if k == 1
	Tnonan = sum(~anynan(x));
else
	for i=1:k
		Tnonan(i) = sum(~anynan(x(:,i)));
	end
end;

