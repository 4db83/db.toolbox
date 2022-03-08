function stderr_x= stderr(x,LRV)
% F: computes the standard error (of the mean) defined as sqrt(Var(x)/T).
% if LRV == 1, the we use the LRV with PREWHITENING FUNCTION

SetDefaultValue(2,'LRV',0);
% remove nans if exist
Inan = anynan(x);
x		= x(~Inan,:);

[T,k]			= size(x);

VAR_x			= var(x);

if LRV == 1
	[VAR_x, ALLx]	= LRVwPW(x);
end

stderr_x	= sqrt(VAR_x./T);


