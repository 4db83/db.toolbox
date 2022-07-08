function varargout =  plotfts(ftsdata,DateTickFrequency,DateFormat,legON,LegNames,FNs)
% function: does a quick plot of a financial times series object.
% ------------------------------------------------------------------------------------------------------
% To set custom legend names, call with legON = 0, ie., no legend and then call:
% ------------------------------------------------------------------------------------------------------
% fighndl		= plotfts(fts2plot);
% legnames	= {'$\Delta y$'; '$\Delta^2y$'};
% legendflex(fighndl.fig,legnames,'Interpreter','Latex','Fontsize',14)
% so then we have more control over it.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CHECK IF IT IS AN FTS OBJECT OR A TT OBJECT
isTT = isa(ftsdata,'timetable');

%clear figure
clf;

% MAKE NAMES WITHOUT SUB_SCRIPTS
if isTT 
	names0 = ftsdata.Properties.VariableNames;
	names1 = names0;
else
	names0	= fieldnames(ftsdata);
	names1	= names0(4:end);
end

names		= strrep(names1,'_','.');

SetDefaultValue(2,'DateTickFrequency',50);
SetDefaultValue(4,'DateFormat','yyyy:qq');
SetDefaultValue(5,'legON',1);
% SetDefaultValue(4,'DateFormat',1);
SetDefaultValue(5,'LegNames',names);
SetDefaultValue(6,'FNs',14);

if isTT 
	matx		= ftsdata.Variables;
 	dates		= ftsdata.Properties.RowTimes;
else
	matx		= fts2mat(ftsdata);
	dates		= ftsdata.dates;
end

% PLOTTING
hndl.fig = plot(matx,'LineWidth',1.75);
% set(hndl.fig(4),'Linestyle','--')
% ADD ONS
box on; grid on;
setplot([0.07 .45 .86 .25]) 
% setdateticks(dates, DateTickFrequency, DateFormat,FNs)
setrotatedateticks(ftsdata.Time, DateTickFrequency, 'yyyy:mm', FNs);
% setyticklabels(-4:2:12,0,FNs)
set(gca,'GridLineStyle',':','GridAlpha',1/3)
hline(0)
% NOW MAKE OUTSIDE TICKS FOR TWO AXIS Y LABELS 
setoutsideTicks
add2yaxislabel



% LEGEND
placement = 'nw';
placement = 'ne';
% buffer or spaceing around the plot
bfr	= 0;

if legON
% 	[legnd,~,~,legNames] = legendflex(names,	'fontsize',14,'padding',[5 4 5],'anchor',{placement,placement},...
	[hndl.legend] = legendflex( LegNames, ...
															'fontsize',FNs, ...
															'padding',[5 4 5], ...
															'anchor',{placement,placement},...
															'buffer',[-1 -bfr], ...
															'xscale',1.25);
% % 	[hndl.legend,~,~,~,hndl.legNames] = legendflex(names,	'fontsize',14,'padding',[5 4 5],'anchor',{placement,placement},...
end

% legNames
% hndl.legend.names = legNames
% hndl.legendNames = Legend.Names


% title_name = inputname(1);
title_name		= strrep(inputname(1),'_','.');
hndl.subtitle = subtitle(title_name,-1.135);

if nargout > 0
	varargout{1} = hndl;
end



















































% EOF