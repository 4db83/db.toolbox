function [] = setgridlinestyle(grid_alpha,grid_style)
% function adds/adjust the gridline style

SetDefaultValue(1,'grid_alpha', 1/3);
SetDefaultValue(2,'grid_style', ':');


set(gca,'GridLineStyle',grid_style,'GridAlpha',grid_alpha);

end