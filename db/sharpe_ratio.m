function sr = sharpe_ratio(x)

x			= removenan(x);

mu		= mean(x);
sig		= std(x);

sr		= mu./sig;