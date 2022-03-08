function [] = movexticklabel(offset,FS,Frmat,xoffset,remXLabl,loctn,adj0,specialXlbl,fhndl)
% Function:	move xticklable up or down
% 
% CALL AS: movexticklabel(offset,FS,Frmat,xoffset,remLabl,fhndl)
% 
%
% NOTE: need to manually set the xoffset sometimes, so we can need to leave the XLabl in at 
%				times. Default for remXLabl is 0, ie., to show the lable. 
% -------------------------------------------------------------------------------------------
% INPUT:		
%		offset		= offset to move up or down.
%		FS				= Font size.
%		Frmat			= number to display format.
%		xoffset		= offsetting the x-axis left or right to align number as in the original
%								version.
%		remXLabl  = set to 1 to remove the old xlabel (Default is 0 to leave it in and to adjust)
%		loctn			= either 'Centre','Right' or 'Left', 'Centre' is default
%		adj0			= adjustst the zero display spacing
%		specilaXlbl = cell input {k,2}, with column(1) Xlable entry selector, and column(2) the lable.
%		fhndl			= figure handle (default is gca)
% 
% -------------------------------------------------------------------------------------------
% DB. 31.07.2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% move xticklable up or down

SetDefaultValue(3 ,'Frmat'		, '%2.2f');
SetDefaultValue(4 ,'xoffset'	, 0);
SetDefaultValue(5 ,'remXLabl'	, 1);
SetDefaultValue(6 ,'loctn'		, 'Center');
SetDefaultValue(7 ,'adj0'			, '  ');
SetDefaultValue(8 ,'specialXlbl', []);
SetDefaultValue(9 ,'fhndl'		, gca);

XTick		= get(fhndl,'XTick');
FntS		= get(fhndl,'FontSize');

SetDefaultValue(2 ,'FS'	, FntS);


% set the 0 entry without decimals for pretty plots.
k       = 1e12;
xtck0   = round(XTick*k)/k;						% set rounding floor
f0      = find(xtck0==0);							% find 0 value.

XTickLabel0			= cellstr(num2str(XTick(:),Frmat));
XTickLabel0(f0)	= {[adj0 '0']};

if isempty(specialXlbl)
	XTickLabel = XTickLabel0;
else
	for ii = 1:size(specialXlbl,1)
		XTickLabel0{specialXlbl{ii,1}} = specialXlbl{ii,2};
	end;
end;

XTickLabel = XTickLabel0;


% remove current Xticklabels
if remXLabl == 1
	set(fhndl,'XTickLabel',[]);
end

YLims	= get(fhndl,'YLim');
x			= YLims(1) - offset*diff(YLims);

% XTick
% XTickLabel

hText	= text(XTick + xoffset,repmat(x,size(XTick)), ...
				XTickLabel,'Horiz',loctn,'Fontsize',FS,'FontName','Times New Roman');
			
% 			FName = 'Times New Roman';
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
	
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			

end			