function movetitlelabel(adjst,title_handle,FNS)
% move the position of the title
% CALL AS:		movetitlelabel(postn,title_handle)
% =======================================================================================
% input
% adjst:			scalar or 2x1, how much to shift up or down (or left right)(note we only shift up or down)
%	NOTE:				POSITION IS NORMALISED.
%
% fig_handle:	scalar, figure handle, default is gca.
%
% =======================================================================================
% db 28.01.2015
% modfified on na
% =======================================================================================
FNS0 = get(gca,'FontSize');

SetDefaultValue(3 ,'FNS'				, FNS0);

% Use normalised units, works better as it does not depend on the y-axis scale.
set(title_handle  ,'Units','normalized');

current_pos		= get(title_handle,'Position');

if length(adjst)>1
	new_pos				= current_pos + [adjst(2) adjst(1) 0];
else
	new_pos				= current_pos + [0 adjst(1) 0];
end;

set(title_handle,'Position',new_pos);
set(title_handle,'FontSize',FNS);
set(title_handle,'FontWeight','Normal','Units','normalized','FontName','Times New Roman');

end
