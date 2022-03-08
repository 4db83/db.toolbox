function initT = initTimer
% F: Initializes the timer and the waitbar outside the main loop of the MCMC. 
% call as: initT = initiTimer
% ------------------------------------------------------------------------------------------------------
%		NO INPUT VARIABLES.
%
%		OUTPUT IS: 
%		initT.T0	= now; time zero before main call to loop
%		initT.HWB = handle to waitbar
%
%		INSIDE MAIN LOOP CALL AS:
%		% display time remaining
%		if ~rem(i,50); showtimer(i,s,initT_abc); end;
%
%		THE CALL IS AS FOLLOWS:
% ------------------------------------------------------------------------------------------------------
% 		% initialize timer and waitbar outside main loop
% 		initT = initiTimer;
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

% initialize timer and waitbar outside main loop
% initT = initiTimer;

initT.T0	= now; 
initT.HWB	= waitbar(0,'Starting Simulation ...');

end