function [S,ac0,pac0] = plotacf0(aL,bL,No_acf,ylims,plfg)
% call as: [S,ac0,pac0] = plotacf0(aL,bL,No_acf,ylims,plfg); plot automatic
% Plots the Theoreticla ACV and PACF values.
%
% or as full call:
% [ac,pac] = plotacf0(aL,bL,ylims,No_acf,plfg)
%
% x			= data vector (column)
% nac		= no. acf values to return (<= length(x))
% plfg		= 1 do a plot
% acalpha	= alpha for CI in ACF/PACF plots

% % aL = [1 -0.92 0.2] 
% % bL = [1 0.99 0.2]
% % No_acf = 10;
% % plfg = 1

SetDefaultValue(3,'No_acf',50);
SetDefaultValue(4,'ylims',[]);
SetDefaultValue(5,'plfg'	,1);

tickshrinkValue = 0.7;

% compue the theoretical ACFs and PACFs
ac0			= acf0(aL,bL,No_acf);
pac0		= pacf0(aL,bL,No_acf);
% drop the first one that is equal to 1.
ac0			= ac0(2:end);
pac0		= pac0(2:end);

plot_dims = [.4 .30];

% % plotting floors for figures
% % if nargin < 3 
%  	FF				= 10;
% 	FFpac			= floor(FF*min(ac0))/FF;
%  	FFpacf		= floor(FF*min(pac0))/FF;
% 
% Ylims = min([-.2 FFpac FFpacf]);
% 
% if mod(Ylims*10,2)==0
% 	yylims = Ylims*ones(2,1);
% else
% 	yylims = Ylims - 0.1;
% 	yylims = yylims*ones(2,1);
% end;
% 
% %ylims = yylims;
% SetDefaultValue(3,'ylims',yylims);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% lower bounds on the ACF/PACF plot
mmac_pac	= min(min(ac0),min(pac0));
%plt_min		= min( [-thr -.2 min(0,floor(FF*mmac_pac)/FF)] );

xm_grid = ([-.2:-.2:-1])';
plt_min = xm_grid(sum(mmac_pac<xm_grid)+1);

%plt_min		= min( [-thr -.2 min(0,floor(FF*mmac_pac)/FF)] );

SetDefaultValue(4,'ylims',plt_min*ones(2,1));

if isempty(ylims)
	ylims	= plt_min*ones(2,1);
end;

if length(ylims)==1
	ylims = ylims*ones(2,1);
end;


%% plotting.
% CLR = [.73 .83 .96];
CLR = [.7 .8 1];
FNT = 10;
FNT1= 16;
FNT2= FNT1;

S = zeros(2,1);
no_acf = No_acf

if plfg == 2
% the acf
S(1) = subplot(211);
		bar(ac0,'FaceColor',CLR,'EdgeColor',CLR);	        % a stem plot with dot marker
    hold on;
    % xlim([.25 No_acf+0.5]);
		ylim([ylims(1) 1.001]);
    hline(0,'k')
		setplot([ 0.13 .55 .7 .3],FNT-1);
		setxticklabels([get(S(1),'XTick')],S(1));
		setyticklabels(ylims(1):.2:1);
		setytick(1);
		legend({'Theoretical ACF'},'FontSize',FNT-1,'Orientation','Horizontal');
		legend('boxoff');
    hold off;
		xlim([.25 No_acf+.5]);
   
% the pacf
S(2) = subplot(212);
		bar(pac0,'FaceColor',CLR,'EdgeColor',CLR);	        % a stem plot with dot marker
    % xlim([.25 No_acf+0.5]);
		ylim([ylims(2) 1.001]);
    hold on;
		hline(0,'k')
		setplot([ 0.13 .2 .7 .3],FNT-1);
		setxticklabels([get(S(2),'XTick')],S(2));
		setyticklabels(ylims(2):.2:1);
		setytick(1);
		legend({'Theoretical PACF'},'FontSize',FNT-1,'Orientation','Horizontal');
		legend('boxoff');
    hold off;		
		xlim([.25 No_acf+.5]);
end


CLR = [.7 .8 1];
%CLR = [.4 .7 1];
S = zeros(2,1);

if plfg == 1
% the acf
S(1) = subplot(121);
LL(1)= bar(ac0,'FaceColor',CLR,'EdgeColor',CLR);	        % a stem plot with dot marker
BS_H= get(LL(1),'BaseLine');set(BS_H,'LineStyle','-','Linewidth',0.5)
hold on;
    xlim([.25 no_acf+0.5]);
		ylim([ylims(1) 1.001]);
% LL(2)= hline_f(thr,'-.r');
% 		hline_f(-thr,'-.r')
%    hline_f(0,'k')
%		ylabel('ACF','FontSize',FNT);
% if Legnd == 1
		L1 = legend(LL,{'ACF'},'FontSize',FNT2,'Location','Northeast','Orientation','Horizontal');
		%set(L2,'units','normalized')
% 		L1_tmp = get(L1,'Position');
% 		set(L1,'Position',[.295 .4775 L1_tmp(3:4)]);
% 		get(L1,'Position');
% 		legend('boxoff');
% end
%		xlabel('horizon','FontSize',FNT);
		setplot([.070 .33 plot_dims],FNT1);
% 		setplot([plot_dims(1:2)],FNT1);
%		moveylabel(7)
		setxticklabels([1 get(S(1),'XTick')],S(1));
		xlim([.0 no_acf+1]);
		setyticklabels(ylims(1):.2:1);
		setytick(1,FNT1);
		set(gca, 'Layer','top')
		xclr = get(gca,'XColor');
		h0 = hline(0);
		set(h0,'Color',xclr)
		tickshrink(tickshrinkValue)
		hold off;
    
% the pacf
S(2) = subplot(122);
LL(1)= bar(pac0,'FaceColor',CLR,'EdgeColor',CLR);	        % a stem plot with dot marker
BS_H= get(LL(1),'BaseLine');set(BS_H,'LineStyle','-','Linewidth',0.5)
    xlim([.25 no_acf+0.5]);
		ylim([ylims(2) 1.001]);
    hold on;
% LL(2)= hline_f(thr,'-.r');
% 		hline_f(-thr,'-.r')
		hline(0,'k')
%		ylabel('PACF','FontSize',FNT);
% if Legnd == 1
		L1 = legend(LL,{'PACF'},'FontSize',FNT2,'Location','Northeast','Orientation','Horizontal');
% 		set(L2,'units','normalized')
%  		L2_tmp = get(L2,'Position');
%  		set(L2,'Position',[.725 .4775 L2_tmp(3:4)]);
% % 		get(L2,'Position');
% 		legend('boxon');
% end
%		xlabel('horizon','FontSize',FNT);
		setplot([.540 .33 plot_dims],FNT2);
% 		setplot([plot_dims(1:2)],FNT1);
%		moveylabel(7)
%		setyticklabels([-.4:.2:1])
		setxticklabels([1 get(S(2),'XTick')],S(2));
		xlim([.0 no_acf+1]);
		setyticklabels(ylims(2):.2:1);
		setytick(1,FNT1);
		set(gca, 'Layer','top')
		set(gca, 'Layer','top')
		xclr = get(gca,'XColor');
		h0 = hline(0);
		set(h0,'Color',xclr)
		tickshrink(tickshrinkValue)
    hold off;
end


% % if plfg == 1
% % 	
% % 	
% % % the acf
% % S(1) = subplot(121);
% % 		bar(ac0,'FaceColor',CLR,'EdgeColor',CLR);	        % a stem plot with dot marker
% %     hold on;
% %     %xlim([.25 No_acf+0.5]);
% % 		ylim([ylims(1) 1.001]);		
% %     hline(0,'k')
% % % 		setplot([ 0.13 .2 .35 .4],FNT);
% % 		setplot([.07 .33 plot_dims],100);
% % 		setxticklabels([get(S(1),'XTick')],S(1));
% % 		setyticklabels(ylims(1):.2:1.01);
% % 		setytick(1,FNT1);
% % 		legend({'Theoretical PACF'},'FontSize',FNT1,'Orientation','Horizontal');
% % % 		legend('boxoff');
% %     hold off;
% % 		xlim([.25 No_acf+.5]);
% %     
% % % the pacf
% % S(2) = subplot(122);
% % 		bar(pac0,'FaceColor',CLR,'EdgeColor',CLR);	        % a stem plot with dot marker
% %     %xlim([.25 No_acf+0.5]);
% % 		ylim([ylims(2) 1.001]);
% %     hold on;
% % 		hline(0,'k')
% % % 		setplot([ 0.55 .2 .35 .4],FNT);
% % 		setplot([.57 .33 plot_dims],FNT1);
% % 		setxticklabels([get(S(2),'XTick')],S(2));
% % % %		setyticklabels([-.4:.2:1])
% % 		setxticklabels([1 get(S(2),'XTick')],S(2));
% % 		
% % 		setyticklabels(ylims(2):.2:1);
% % 		setytick(1,FNT1);
% % 		legend({'Theoretical PACF'},'FontSize',FNT1,'Orientation','Horizontal');
% % % 		legend('boxoff');
% %     hold off;
% % 		xlim([.25 No_acf+.5]);
% % end






% if Legnd == 1
% 		L2 = legend(LL,{'PACF','95% CI'},'FontSize',FNT2,'Location','Northeast','Orientation','Horizontal');
% % 		set(L2,'units','normalized')
% %  		L2_tmp = get(L2,'Position');
% %  		set(L2,'Position',[.725 .4775 L2_tmp(3:4)]);
% % % 		get(L2,'Position');
% % 		legend('boxon');
% end
% %		xlabel('horizon','FontSize',FNT);
% 		setplot([.57 .33 plot_dims],FNT2);
% % 		setplot([plot_dims(1:2)],FNT1);
% %		moveylabel(7)
% %		setyticklabels([-.4:.2:1])
% 		setxticklabels([1 get(S(2),'XTick')],S(2));
% 		xlim([.0 no_acf+1]);
% 		setyticklabels(ylims(2):.2:1);
% 		setytick(1,FNT1);
% 		set(gca, 'Layer','top')
% 		set(gca, 'Layer','top')
% 		xclr = get(gca,'XColor');
% 		h0 = hline(0);
% 		set(h0,'Color',xclr)
% 		tickshrink(tickshrinkValue)
%     hold off;









































%% to modifiy specific handles
% % icrm = .2;
% % mtcks = [min_pac:icrm:1]'
% % setyticklabels(mtcks,S(2))
% % setytick(4,S(2))
% % setylabel(5,S(2))
% % setxlabel([10.05 .05],S(2))

% % print2pdf('here')


end


