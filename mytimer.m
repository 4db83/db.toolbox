function [] = mytimer(t0,timer0,ii,Nsim)
% times the progress of a long computatioan
% t0		= tic; 
% timer0	= now;
% 
% for ii = 1:Nsim;
%   % some compuatons print time taken
%     if ii == 1e2;        mytimer(t0,timer0,ii,Nsim); end; % first 
%     if mod(ii,1e3) == 0; mytimer(t0,timer0,ii,Nsim); end; % subsequent ones
% end;     
% by db 2012 (mod. 22.10.2013)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ti    = toc(t0);
tbar  = ti/ii;
Etime = (tbar*(Nsim)); 
tend  = timer0 + Etime/86400;
stend = datestr(tend);
fprintf('Iteration number: %d out of %d  (%2.2f Percent Complete) \n', [ii Nsim 100*ii/Nsim]);
if Etime/60 > 240
    fprintf('Expected Total Time in Hours: %2.2f          [Remaining: %2.2f]\n', [Etime/3600 (Etime-ti)/3600]);
    % fprintf('Approximate Time remaining (in Hours) %2.2f \n', (Etime-ti)/3600);  
else;
    fprintf('Expected Total Time in Minutes: %2.2f        [Remaining: %2.2f]\n', [Etime/60 (Etime-ti)/60]);
    % fprintf('Approximate Time remaining (in Minutes) %2.2f \n', (Etime-ti)/60); 
end;
fprintf('Approximate Date and Time at completion: %s \n', stend(1:20));
%fprintf('--------------------------------------------------------------\n');
sep
end
