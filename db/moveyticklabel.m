function [] = moveyticklabel(offset,FS,Frmat,fhndl)


SetDefaultValue(2 ,'FS'				, get(gca,'FontSize'));
SetDefaultValue(3 ,'Frmat'		, '%2.1f');
SetDefaultValue(4 ,'fhndl'		, gca);

YTick				= get(fhndl,'YTick');
% get(fhndl,'YTickLabel')
%if Frmat
%tickfrmat	= ['%2. 2f'

% set the 0 entry without decimals for pretty plots.
k       = 1e12;
ytck0   = round(YTick*k)/k;						% set rounding floor
f0      = find(ytck0==0);							% find 0 value.

YTickLabel	= cellstr(num2str(YTick(:),Frmat));
YTickLabel(f0) = {'0'};

% remove current Yticklabels
set(fhndl,'YTickLabel',[]);

XLims				= get(fhndl,'XLim');
x						= XLims(1) - offset*diff(XLims);
% x						= (1+offset)*XLims(1);
hText				= text(repmat(x,size(YTick)),YTick,YTickLabel,'Horiz','Right','Fontsize',FS,'FontName','Times New Roman');
