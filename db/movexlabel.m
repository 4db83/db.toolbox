function movexlabel(postn,fig_handle)
% move the position of the x-axis label
% call as:		movexlabel(-.2)
% =======================================================================================
% input
% adjst:			(3x1), location vector to move the entry [leftright updown threeD]
% fig_handle:	scalar, figure handle, default is gca.
%
% updown:			scalar, how much to move it up or down.
% leftright:	scalar, how much to move the x-axis label to up or down.
% threeD:			scalar, this is optional, when using 3-D figures.
%
% call as:		movexlabel(-.2) to move the x-axis lable to the down by .2.
%							or pass additional parameters if needed. ie.
%							setxlabel([-.2 -.3 20],figure_handle);
% =======================================================================================
% db 14.06.2012
% modfified on 10.07.2013
% =======================================================================================

if length(postn) == 1
	adjst = [0 postn 0];
end

if length(postn) == 2
	adjst = [postn 0];
end;

if length(postn) == 3
	adjst = postn;
end

if nargin < 2;
	fig_handle = gca;
end;

% handle to x-axis lable (not the figure, which is fig_handle)
xlabel_handle	= get(fig_handle,'XLabel');

% Use normalised units, works better as it does not depend on the y-axis scale.
set(xlabel_handle,'Units','normalized');
current_pos		= get(xlabel_handle,'Position');
new_pos				= current_pos + adjst;

set(xlabel_handle,'Position',new_pos);


end
