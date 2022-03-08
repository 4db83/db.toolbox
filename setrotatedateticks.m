% function hndl = setrotatedateticks(dates,Width,dateformat,FNTS,ROT,fig_handle,date_space)
function step_sizes_out = setrotatedateticks(dates,Width,dateformat,FNTS,ROT,date_space,fig_handle)
% function: sets the date tick format in rotated from:
% ----------------------------------------------------------------------------------------------
% call as:		setrotatedateticks(dates,Width,dateformat,FNTS,ROT,fig_handle,date_space)
% setdateticks with rotation already
% SET WIDTH equal to (length(dates)-1)/x = 35 to 45, with x as close to an
% integer as possible (with date_space = {0,3} to show first and last date % entry).
% 35 to 45 are the number of ticks that are shown
% Note: need to find x in 1:x:T where T is the sample size, with 1:width:T being
% such that it ends at T, where x is the widht of the intervals.

% ----------------------------------------------------------------------------------------------

% get defaulf font size
fonts0 = get(gca,'FontSize');

SetDefaultValue(2, 'Width', 12);
SetDefaultValue(3, 'dateformat', 0);
SetDefaultValue(4, 'FNTS', fonts0);
SetDefaultValue(5, 'ROT', 90);
SetDefaultValue(6, 'date_space', 0);
SetDefaultValue(7, 'fig_handle', gca);

% if datetime convert to datenum
if isdatetime(dates)
	dates = datenum(dates);
end

% mod the format of the date string showing
if ~isstring(dateformat)
	if dateformat == 0
		dateformat = 'yyyy:QQ';
	elseif dateformat == 1
		dateformat = 'mmm-yyyy';
	elseif dateformat == 2
		dateformat = 'dd.mm.yyyy';
	end
end

% old stuff
% hndl = rotateticklabel(gca,ROT);
% setdateticks(dates,dateformat,W,date_space,fig_handle)
% setdateticks(dates,Width,dateformat,date_space);

date_step_width = setdateticks(dates,Width,dateformat,FNTS,date_space,fig_handle);
% this is the rotation
H_rot = rotateticklabel(gca,ROT);

if nargout > 0
	step_sizes_out = date_step_width;
end


% if nargout
% 	hndl = H_rot;
% end

% tickshrink(1.75);

% setdateticks(dates);
% FName = 'Times New Roman';
% set(H_rot,'FontName',FName,'FontSize',FNTS);     
