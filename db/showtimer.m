function [] = showtimer(i,Nsim,initT)
% F: Calls the timer in the main loop of the MCMC and shows the waitbar.
%		call as: showtimer(i,Nsim,initT).
% ------------------------------------------------------------------------------------------------------
%		INPUT IS.
%		i			is the loop index.
%		Nsim	is the nubmer of simulations.
%		initT is the initialisation index T that is called before, outside the loop.
%
%		NO INPUT VARIABLES.
%
%		INSIDE MAIN LOOP CALL AS:
%		% display time remaining
%		if ~rem(i,50); showtimer(i,Nsime,initT); end;
%
%		THE CALL IS AS FOLLOWS:
% ------------------------------------------------------------------------------------------------------
% 		% initialize timer and waitbar outside main loop
% 		initT_abc = initiTimer;
%
% 		for i = 1:Nsim
%				DO STUFF HERE
%
% 			% display time remaining
% 			if ~rem(i,50); showtimer(i,Nsim,initT); end;
% 		end
% 		% close the HWB
% 		close(initT.HWB)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

waitbar( i/Nsim, initT.HWB, timerbar(i, Nsim, initT.T0) ); 