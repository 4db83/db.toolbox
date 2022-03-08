function hout = setsubplots(figDims, Vspace, BoxLineWidth)
%{F: specifies subplots vertical spacing and dimensions
% CALL AS:	setsubplots([.8 .2], .15) or as
%						setsubplots([ .1 .8 .2], .15) to shift up or down with first entry in []
%						setsubplots([.05 .1 .8 .2], .15) to shift left/right and up/down with first 2 entries in []
% BoxLineWidth is an optional parameer to adjust the width of the line of the box around
%-------------------------------------------------------------------------------
% figDims = [LeftPos BottomPos Width Height];
% can be 2 to 4 entries, ie. 
% figDims = [Width Height], or 
% figDims = [BottomPos Width Height], or
% figDims = [LeftPos BottomPos Width Height] for full control
%
% Vspace	= space between subplot figures.
%===============================================================================
% 	NOTES :   Always call it at the end of the plotting commands, after hold off;
%-------------------------------------------------------------------------------
% Created :		21.06.2018.
% Modified:		21.06.2018.
% Copyleft:		Daniel Buncic.
%------------------------------------------------------------------------------%}

% SetDefaultValue(3, 'BoxLineWidth', 1.25);
SetDefaultValue(3, 'BoxLineWidth', 6/5);

% HANDLE TO FIGURE OBJECT
hAx		= findobj(gcf , 'type', 'axes');
Pos1	= get(hAx(1)	,'Position');
PosL	= get(hAx(end),'Position');
xd		= length(figDims);
% THIS SETS THE LINEWIDTH OF THE BOX AND THE GRID LINES
set(hAx,'linewidth',BoxLineWidth)

Ns = length(hAx);

% DEFAULT VALUES
LP = .075;
% BP = Pos1(2)+.15;
% BP = (PosL(2) - Pos1(2))/Ns
BP = Pos1(2);
% BP = 1/Ns


% setsubplots([LeftPos BottomPos Width Height], Vspace)
if xd == 2
	plot_dims = [LP BP figDims];
elseif xd == 3
	plot_dims = [LP figDims];
	BP = figDims(1);
elseif xd == 4
	plot_dims = [figDims];
	BP = figDims(2);
end
	
% now loop through to set all the figures
for h = 1:Ns
	plot_dims(2) = BP +(h-1)*Vspace;
 	set(hAx(h), 'position', plot_dims)
% 	end;
end

