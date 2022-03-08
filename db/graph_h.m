function p = graph_h(lw);
% ------------------------------------------------------------------------------
%	function [GSout,p] = graph_h(fontsize,GSversion);
% ------------------------------------------------------------------------------
% p.me = 'MarkerEdgeColor';     p.mf = 'MarkerFaceColor';
% p.lw = 'LineWidth';           p.ms = 'MarkerSize';
% p.fs = 'FontSize';            p.ps = 'Position';
% p.ls = 'LineStyle';           p.mk = 'Marker';
% p.cl = 'Color';               p.ec = 'EdgeColor';
% p.fc = 'FaceColor';           p.ip = 'Interpreter';
% p.lc = 'Location';            p.fn = 'FontName';
% p.xt = 'XTick';               p.xtl= 'XTickLabel';
% p.yt = 'YTick';               p.ytl= 'YtickLabel';
% p.ot = 'Orientation';							
% ------------------------------------------------------------------------------

if nargin < 1;
	lw = 1.5;
end;
% h = gcf;	% figure handle
h = 0;	% figure handle

% ------------------------------------------------------------------------------
% set(0,'Defaultaxesfontsize',fontsize);set(0,'Defaultaxesfontname','Palatino');
set(h,'defaultTexTFontName'	,'Palatino',...
			'defaultLineLineWidth',lw);

% ------------------------------------------------------------------------------
%set(0,'DefaultLineLineWidth',1);
%GSout=['C:\Program Files\gs\gs' num2str(GSversion,'%1.2f') '\bin\gswin32c.exe'];
% PLOTTING ABREVIATIONS --------------------------------------------------------
p.me = 'MarkerEdgeColor';     p.mf = 'MarkerFaceColor';
p.lw = 'LineWidth';           p.ms = 'MarkerSize';
p.fs = 'FontSize';            p.ps = 'Position';
p.ls = 'LineStyle';           p.mk = 'Marker';
p.cl = 'Color';               p.ec = 'EdgeColor';
p.fc = 'FaceColor';           p.ip = 'Interpreter';
p.lc = 'Location';            p.fn = 'FontName';
p.xt = 'XTick';               p.xtl= 'XTickLabel';
p.yt = 'YTick';               p.ytl= 'YtickLabel';
p.ot = 'Orientation';					
% ------------------------------------------------------------------------------
% 	AvantGarde 		Helvetica-Narrow 	Times-Roman 
% 	Bookman 		NewCenturySchlbk 	ZapfChancery
% 	Courier			Palatino 			ZapfDingbats
% 	Helvetica 		Symbol
% ------------------------------------------------------------------------------


%% SOME EXTRA PLOTTIG CONTROALS FOR BACKGROUND COLORS ARE:
% set(gca,'Xcolor',1*ones(1,3));
% set(gca,'Ycolor',1*ones(1,3));
% set(gcf, 'InvertHardCopy', 'off');
% set(gca, 'Color', .7*ones(1,3));
% set(gcf, 'Color', .7*ones(1,3));
