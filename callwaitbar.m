function [] = callwaitbar(ii,Nsim,timer0,hwb)

% h = waitbar;
% titleHandle = get(findobj(hwb,'Type','axes'),'Title');
% set(titleHandle,'FontSize',14)
% % set(titleHandle,'FontName','Times New Roman')
% set(findall(hwb),'Units', 'normalized');
% % Change the size of the figure
% set(hwb,'Position', [.2 .4 .2 .07]);

aout = waitbar( ii/Nsim, hwb, timerbar(ii, Nsim, timer0) );


