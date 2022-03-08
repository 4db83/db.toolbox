function lambda_opt = find_best_lambda_tvp_ewma(yin,xin,D)
% function to loop trough and find the best lambda value in the 
% foregetting factor version of the TVP model.

if nargin < 3
	D = 0.1;
end;

if max(size(D)) > 1;
	Lambda	= D;
else
	Lambda	= [(0.1:D:.9)'; [.95 .99 1]']; 
end;

dim_L		= length(Lambda);
	
% space allocation
mse_tvp = zeros(dim_L,1);
	
% loop through different lambdas to find best forgetting parameter
parfor L = 1:dim_L
 	[~,uhat_tvp,~,~,~]	= tvp_ewma(yin,xin,Lambda(L));
	mse_tvp(L) = mean(uhat_tvp.^2); 
end;
	
mse_min = min(mse_tvp);

II = find(mse_min==mse_tvp);
lambda_opt = Lambda(II);

plot(Lambda,mse_tvp)


