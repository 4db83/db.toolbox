function moveylabel(postn,fig_handle)
% move the position of the y-axis label
% =======================================================================================
% input
% adjst:			(3x1), location vector to move the entry [leftright updown threeD]
% fig_handle:	scalar, figure handle, default is gca.
%
% leftright:	scalar, how much to move the y-axis label to left right
% updown:			scalar, how much to move it up or down.
% threeD:			scalar, this is optional, when using 3-D figures.
%
% call as:		moveylabel(-.2) to move the y-axis lable to the left by .2.
%							or pass additional parameters if needed. ie.
%							setylabel([-.2 -.3 20],figure_handle);
% =======================================================================================
% db 14.06.2012
% modfified on 10.07.2013
% =======================================================================================

if length(postn) == 1
	adjst = [postn 0 0];
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

set(get(fig_handle,'YLabel'),'Position',(get(get(fig_handle,'YLabel'),'Position') + adjst));

end
