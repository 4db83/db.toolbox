function th=rotateticklabel(h,rot,FS,SC,paddng)
% ROTATETICKLABEL rotates tick labels
%   TH=ROTATETICKLABEL(H,ROT) is the calling form where H is a handle to
%   the axis that contains the XTickLabels that are to be rotated. ROT is
%   an optional parameter that specifies the angle of rotation. The default
%   angle is 90. TH is a handle to the text objects created. For long
%   strings such as those produced by datetick, you may have to adjust the
%   position of the axes so the labels don't get cut off.
% 		
% 		INPUTS:		h				= figure handle
% 							rot			= rotation factor, ie 90, or 45 etc.
% 							FS			= font size
%								SC			= scale factor for the placement below the X axis labels.
%								paddng	= padding to put between date vector and X axis.
% 
%   Of course, GCA can be substituted for H if desired.
% 
%   Known deficiencies: if tick labels are raised to a power, the power
%   will be lost after rotation.
% 
%   See also datetick.
%   Written Oct 14, 2005 by Andy Bliss
%   Copyright 2005 by Andy Bliss
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by Daniel Buncic 2014.
% % %DEMO:
% % if nargin==3
% %     x=[now-.7 now-.3 now];
% %     y=[20 35 15];
% %     figure
% %     plot(x,y,'.-')
% %     datetick('x',0,'keepticks')
% %     h=gca;
% %     set(h,'position',[0.13 0.35 0.775 0.55])
% %     rot=90;
% % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set the default rotation if user doesn't specify
if nargin==1
    rot=90;
end
% MAKE SURE THE ROTATION IS IN THE RANGE 0:360 (BRUTE FORCE METHOD)
while rot>360
    rot=rot-360;
end
while rot<0
    rot=rot+360;
end
% GET CURRENT TICK LABELS
currentXTicklables = get(h,'XTickLabel');
% GET THE FONT SIZE
FS0 = get(h,'FontSize');
% GET TICK LABEL POSITIONS
currentXTick = get(h,'XTick');
currentYTick = get(h,'YTick');
% ERASE CURRENT TICK LABELS FROM FIGURE
set(h,'XTickLabel',[]);

% MAKE NEW TICK LABELS
% set some default values
SetDefaultValue(3,'FS'		, FS0);
SetDefaultValue(4,'SC'		, currentYTick(1));
SetDefaultValue(5,'paddng', '  ');
% font to be used
FName = 'Times New Roman';

% SET THE Y AXIS POSITION OF THE X-AXIS LABELS
% SC = c(1);
FF = SC*ones(length(currentXTick),1);	% FF = repmat(c(1)-SC*(c(2)-c(1)),length(b),1);
[Ra, Ca] = size(currentXTicklables);
currentXTicklables	 = [currentXTicklables repmat([paddng] ,Ra,1)];

if rot<180
    th=text(currentXTick,FF,currentXTicklables,'HorizontalAlignment','right','rotation',rot);
else
    th=text(currentXTick,FF,currentXTicklables,'HorizontalAlignment','right','rotation',rot);
end

set(th,'FontSize',FS, 'FontName', FName)








































%EOF