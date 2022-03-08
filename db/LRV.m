function [LRV_L, LRV_all, KWout, LOPTS] = LRV(x,L,prnt)
%{F: Computes the (UNIVARIATE) Long-Run Variance (LRV) WITHOUT PRE-WHITENING of vector X.
% INPUTS: 	
%						X: 	(Tx1) series whose long-run variance is needed.
%						L: 	scalar, optional for specific bandwidth.
%				 prnt:	indicator, if 1, then some summary output is printed.
% OUTPUTS: 		
%			  LRV_L:	scalar, default LRV with either fixed L or ROT L of Newey & West (1994) and Bartlet Kernel.
% 							
%			LRV_all: 	structure, all computed LRV combinations using ARMA(1,1),AR(1), QS,Bartlet (NO PW)
%			data driven truncation lags and also QS and Bartlet rule of thumb results.
% 		  KWout:	(Tx1) vector of used Kernel weights.
% 		  LOPTS:	ARMA fitting optimization output.
% ---------------------------------------------------------------------------------------
% NO PRE-WHITENING DONE HERE. ONLY COMPUTE AR(1) AND ARMA(1,1) MODELS TO GET DATA DRIVEN TRUNCATION
% LAGS AS IN ANDREWS FOR QS AND BARTLETT KERNELS
%========================================================================================
% 	NOTES :   	see also LRVwPW.m function. DOES ONLY Univariate MODELS.
%========================================================================================
% Created :			02.07.2014.
% Modified:			06.11.2015.
% Copyleft:			Daniel Buncic.
%----------------------------------------------------------------------------------------%}

SetDefaultValue(2, 'L'		,[]);
SetDefaultValue(3, 'prnt'	,0);

[~,Nc] = size(x);

if Nc == 1
	[LRV_L, LRV_all, KWout, LOPTS] = LRV_1(x,L,prnt);
end
	
	
if Nc > 1
	for jj = 1:Nc
		[LRV_L, LRV_all, KWout, LOPTS] = LRV_1(x(:,jj), L, prnt);
		LRV_L_out(jj)		= LRV_L;
		LRV_all_out{jj} = LRV_all;
		KWout_out{jj}		= KWout;
		LOPTS_out{jj}		= LOPTS;
	end
	% parse them back to output
	LRV_L		= LRV_L_out;
	LRV_all = LRV_all_out;
	KWout		= KWout_out;
	LOPTS		= LOPTS_out;
end





