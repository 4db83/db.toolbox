function [fhndl] = plotwithdates(xin,dates,FntSize,date_fmt,intrval,rot,LW,TckShrink)

SetDefaultValue(3 ,'FntSize'	, 12);
SetDefaultValue(4 ,'date_fmt'	, 'mmm yyyy');
SetDefaultValue(5 ,'intrval'	, 4 );
SetDefaultValue(6	,'rot'			, 90);					% rotate x axis labels if needed.
SetDefaultValue(7	,'LW'				, 1);
SetDefaultValue(8	,'TckShrink', 0);

% if nargin < 2 || isempty(dates) 
% 	if size(xin,2) > 1
% 		dates	=	xin(:,1);
% 		X			= xin(:,2:end);
% 	else 
% 		X = xin;
% 	end;
% end
X = xin;

XN = length(dates);

figH = plot(X,'LineWidth',LW);
set(gca,'Fontsize',FntSize);
xlim([1 XN])

% setrotatedateticks(dates,dateformat,datetickwidth,FNTS,ROT,fig_handle,date_space)
setrotatedateticks(dates,[],intrval,FntSize,rot,[],2)
% setrotatedateticks(dates);

% setdateticks(dates);

% % 
% if rot == 90
% 	th = rotateticklabel(gca,rot);
% 	set(th,'FontName','Palatino');
% end

if TckShrink ~= 0
	tickshrink(TckShrink);
end

if nargout
	fhndl = figH;
end
