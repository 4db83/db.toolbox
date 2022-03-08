function [yhatmt,Fmt,BETA_tt,Pmt] = dma_model_loop(yyt_1,yhatmt_1,Hmt_1,inits,BETA_t_1,Pmt_1)

b_00		= inits.b_00;
P_00		= inits.P_00;
H_00		= inits.H_00;
Kappa		= inits.Kappa;
inv_lam = initis.inv_lam;


% Prediction of states (where btt_1 means beta_t|t-1 and Ptt_1 means P_t|t-1)
				% --------------------------------------------------------------------------------------------------
				if t==1
 						% first observation only
						btt_1				= b_00*ones(km,1);								% \beta_t|t-1 for first period
 						Ptt_1				= P_00*eye(km);										% P_t|t-1 for first period
						Hmt(m)			= H_00;														% Volality initialisation for all models for first period
				else % all others as usual
						btt_1				= BETA_t_1{m};
 						Ptt_1				= Pmt_1{m}*inv_lam;								% MSE (Var of states) approximation
						% --------------------------------------------------------------------------------------------------		
						% EWMA for H_t (subtract 0.02 to avoid having an integrated variance model)
						% This is the original Koop and Korobilis EWMA/IGARCH with 0 intercept version with Integrated Vol.
						Hmt(m)			= (1-Kappa)*(yyt_1 - yhatmt_1(m)).^2 + Kappa*Hmt_1(m);
						% this below would be a verison that is a GARCH version with non-zero intercept and non-Integrated Vol
						% H(m,t)		= 0.01 + (1-Kappa-0.02)*(y(t-1) - yhat(m,t-1)).^2 + Kappa*H(m,t-1);
				end
				% --------------------------------------------------------------------------------------------------
				% Forecasting y_t given t-1 info
				yhatmt(m)				= xtm*btt_1;
				% Forecast error MSE (Var of forecast errors)
				Fmt(m)					= xtm*Ptt_1*xtm' + Hmt(m);				% DO NOT STORE ANYMORE AS NOT NEEDED.
				% Kalman Gain
				KG							= Ptt_1*xtm'/Fmt(m);
		 		% Updating
		 		% beta_tt{m}(:,t) = btt_1 + KG*(yyt - yhatmt(m));
				BETA_tt{m}			= btt_1 + KG*(yyt - yhatmt(m));
				Pmt{m}					= Ptt_1 - KG*xtm*Ptt_1;				