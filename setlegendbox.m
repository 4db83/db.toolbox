%function [leghandle] = setlegendbox(LH,width,height)
% call as setlegendbox(legend_handle,[X Y Height lenght]);
function [leghandle] = setlegendbox(LH,pos)

set(LH,'units','pixels');
set(LH,'Units','normalized');
lp = get(LH,'Position');

norm_pos = get(LH,'Position');

% if nargin < 3
% 	set(LH,'Position',[lp(1:2),width,lp(4)]);
% else
% 	set(LH,'Position',[norm_pos(1:2).*.8,width,height]);
% end;

set(LH,'Position',pos);

%set(LH,'Position',[norm_pos(1:2).*.8,width,height]);


%pixls_pos = get(LH,'Position')
%new_pos = pixls_pos.*norm_pos

%set(LH,'Position',new_pos)
%set(LH, 'units','normalized')
leghandle = LH;

	