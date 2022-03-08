function msg = timerbar(ii, Nsim, timer0)
% display progress of simulation 
% ------------------------------------------------------------------------------------------------------------
% CALL AS:
% ------------------------------------------------------------------------------------------------------------
% timer0 = now; hwb	= waitbar(0,'Starting Simulation ...');
% for ii = 2:Nsim;
%  some stuff to compute
% 
% 	% display time remaining
% 	if ~rem(ii,50); waitbar( ii/Nsim, hwb, timerbar(ii, Nsim, timer0) );  end
% end;
% close(hwb)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


timing_elapsed	= now - timer0;
timing_total		= timing_elapsed*Nsim/ii;
timing_remain		= timing_total - timing_elapsed;
timing_end			= now + timing_remain;

%  msg_elapsed		= ['elapsed ', datestr(timing_elapsed,13)];
%  msg_remain		= ['remain ', datestr(timing_remain,13)];
% 
%  msg_elapsed		= sprintf('Time Elapsed: % 2.2f |', timing_elapsed*24*60);
%  msg_remain		= sprintf('Time Remaining: % 2.2f (HH:MM:SS) \n', timing_remain*24*60);

frmt = 13; 

msg_elapsed	= ['| Elapsed: '	, datestr(timing_elapsed, frmt)];
msg_remain	= ['| Remaining: ', datestr(timing_remain , frmt)];
msg_total		= ['Total: '			, datestr(timing_total	, frmt) '.'];
msg_newline	= sprintf('\n');

msg_iterNsim = ['', num2str(ii) '/' num2str(Nsim) ''];

msg_prcnt_complete	= ['. ['	, num2str(100*ii/Nsim,' %2.2f') '%].'];

msg_end	= [ '[Iter: ' msg_iterNsim ']. Ends ', datestr(timing_end,'HH:MM:SS') ...
						' on ' datestr(timing_end,'dd-mmm-yyyy')];

% msg_end	= [ 'Simulations end at ', datestr(timing_end,'HH:MM:SS') ...
% 						' on ' datestr(timing_end,'dd-mmm-yyyy')];					

msg		= [	msg_end, msg_prcnt_complete, msg_newline, ...
			msg_total, ' ', msg_elapsed, ' ', msg_remain];

% msg_newline, msg_end];

end






















% % % function msg = timerbar(it, nalldraws, timing_start)
% % % 
% % % timing_elapsed	= now - timing_start;
% % % timing_total	= timing_elapsed*nalldraws/it;
% % % timing_remain	= timing_total - timing_elapsed;
% % % timing_end		= now + timing_remain;
% % % % msg_elapsed = ['elapsed ', datestr(timing_elapsed,13)];
% % % % msg_remain = ['remain ', datestr(timing_remain,13)];
% % % % msg_elapsed		= sprintf('Time Elapsed: % 2.2f |', timing_elapsed*24*60);
% % % % msg_remain		= sprintf('Time Remaining: % 2.2f (HH:MM:SS) \n', timing_remain*24*60);
% % % 
% % % msg_elapsed		= ['Time Elapsed: ' datestr(timing_elapsed,13)];
% % % msg_remain		= ['| Time Remaining: ' datestr(timing_remain,13)];
% % % 
% % % msg_end			= ['Ending at ', datestr(timing_end,'HH:MM') ' on ' datestr(timing_end,'mmm dd')];
% % % msg				= [msg_elapsed, ' ', msg_remain, ' ', msg_end];
% % % 
% % % end
