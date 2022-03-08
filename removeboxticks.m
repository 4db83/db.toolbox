function [] = removeboxticks(keep_yticks)
% F: removes ticks on the top x-axis and right y-axis from a box 
%		call without inputs as: 
%												removeboxticks 
%		to keep the y-axis ticks on the plot.
%
%	  or wtih inputs as: 
%												removeboxticks(0) 
%		to not keep them.
%
% DB
% --------------------------------------------------------------------------------------------------

if nargin < 1
	keep_yticks = 1;
end;

% get handle to current axes
a = gca;

% get Linewidth of BOX
LW = get(gca,'Linewidth');
% get ticklenght
tick_length = get(gca,'TickLength');

% set box property to off and remove background color
set(a,'box','off','color','none','Layer','top');

% create new, empty axes with box but without ticks
ytick_tmp = get(gca,'ytick');

if nargin == 1
	b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'Linewidth',LW,'Layer','top');
else
	b = axes(	'Position',get(a,'Position'),'box','on','xtick',[],...
						'ytick',ytick_tmp,'yticklabel',[],'Linewidth',LW,'TickLength',tick_length,'Layer','top');
end;

% set original axes as active
axes(a)
set(a,'Layer','top')
% link axes in case of zooming
linkaxes([a b])
set(gca,'Layer','top')