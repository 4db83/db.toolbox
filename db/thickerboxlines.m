function [] = thickerboxlines(linewidth)
% make thicker lines of the box environment.
% 	get axes handle and increase the thickness of lnes and choose grid value for color
% 	ax = gca; 
% 	ax.GridAlpha = .15;  
%  	ax.LineWidth = 1.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(1, 'linewidth', 1);

% get X and Y limits
xl = xlim;
yl = ylim;

% now make the box lines thicker.
plot(xl,ones(1,2)*yl(1), '-k',  ones(1,2)*xl(1), yl,'-k', 'LineWidth',linewidth)  % Left & Lower Axes
plot(xl,ones(1,2)*yl(2), '-k',  ones(1,2)*xl(2), yl,'-k', 'LineWidth',linewidth)  % Right & Upper Axes
