function [fighndl,ytick_out] =	subplots(X,C,names,dates,date_fmt,intrval,setylims,fntsize,...
																LW,sqeez,rot,TckShrink,mveyticklable,Ytckfrmat,title_space,...
																abc_title,lbl_space,AREA_PLOT,rem_nan)
%{F: quick subplot function. 
%----------------------------------------------------------------------------------------
% 	USGAGE	fighndl = subplots(X,C,names,dates,date_fmt,intrval,setylims,fntsize,LW,...
%											sqeez,rot,TckShrink,mveyticklable,Ytckfrmat,lbl_space)
%
%		EXAMPLE USAGE:		subplots(FX_dFX,2,Names_F, FXData.dates,'mmm yy',36,tckvec,[3;4;3],0.3,
%											[.64 .92 .53],90,.7,0.01,frmtvec);
%---------------------------------------------------------------------------------------
% 	INPUT  
%	  X:				(Tx1) vector, dependent variable.
%		C:				number of columns in subplot				(default 1)
%   names:		variable names											(default empty)
%   dates:		(Tx1) datenum date vector						(default empty)
%   date_fmt:	string dateformat, ie., 'mmm yyyy'	(default 'qq:yyyy')
%							error volatility as a time varying process.
%		intrval:	x-axis plotting frequency for the dates (default 10)
%		setylims: set ylimits for plotting, either Nx1 vector or scalar if same for all
%   fntsize:	fontsize for lables, ylabels and ticks can be 3x1 vector or scalar
%		LW:				Linewidth
%		sqeez:		squeeze plot to eliminatre empty space
%		rot:			set rotation of x-axis label
%		TckShrink: 
%                 
% 	OUTPUT       
%	  fighndl:	handle to figure
%========================================================================================
% 	NOTES :   calls the subplotsqueeze to reduce the margin between the subplots
%----------------------------------------------------------------------------------------
% Created :		14.08.2014.
% Modified:		14.08.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}

[Tf,k] = size(X);
R = roundup(k/C,0);

title_spc = [0.5 -0.2];

SetDefaultValue(2 ,'C'						, 1);						% number of columnscolum
SetDefaultValue(3 ,'names'				, []);					% must be a cell, ie. tckvec = {'aa','bb','aaasd'} 
SetDefaultValue(4 ,'dates'				, []);					% date vector
SetDefaultValue(5 ,'date_fmt'			, 'qq:yyyy');		% date format
SetDefaultValue(6 ,'intrval'			, 10);					% date (x-axis) spacing
SetDefaultValue(7 ,'setylims'			, []);					% setylims
SetDefaultValue(8 ,'fntsize'			, 6);						% can be up to a 3x1 vector for labels, ylables and titles
SetDefaultValue(9 ,'LW'						, 1);						% line width
SetDefaultValue(10,'sqeez'				, []);					% squeeze plot settings
SetDefaultValue(11,'rot'					, []);					% rotate x axis labels if needed.
SetDefaultValue(12,'TckShrink'		, 0	);					% Tickshrink for small plots.
SetDefaultValue(13,'mveyticklable', 0	);					% Move yyticklable for small plots.
SetDefaultValue(14,'Ytckfrmat'		, 2	);					% yticklabel format vector, must be a cell.
SetDefaultValue(15,'title_space'	, title_spc);		% Where to put the title. if 0 above, else put how far below x-axis
SetDefaultValue(16,'abc_title'		, 0);						% Putting (a) (b) etc in title header. 
SetDefaultValue(17,'lbl_space'		, []);					% Scaling the drop in x-axis label.
SetDefaultValue(18,'AREA_PLOT'		, []);					% Strcture with .xvec vector of dim(X) setting which plots to make an area and .color the color vector
SetDefaultValue(19,'rem_nan'			, 1);						% Indicator, if == 1, remove nan entries in the plots. default = 1;

if length(title_space) < 2;
	title_space = [title_spc(1) title_space];
end;
	
if isnumeric(Ytckfrmat)
	tmp			= repmat(['%2.' num2str(Ytckfrmat) 'f'],k,1);
	frmtvec	= cellstr(tmp);
else 
	frmtvec = Ytckfrmat;
end;

if length(fntsize) < 3;
	Fntsize = [fntsize;fntsize(1)];
	if length(fntsize) < 2;
		Fntsize = fntsize*ones(3,1);
	end;
else
	Fntsize = fntsize;
end

% subplot index
abc_seq = char({'abcdefghijklmnopqrstuvwxyz'});

[rws,~] = size(setylims);

% AREA_PLOT.xvec
% isempty(AREA_PLOT)

if ~isempty(AREA_PLOT)
	AREA_ii = find(AREA_PLOT.xvec==1);
	if ~isfield(AREA_PLOT, 'color')
		AREA_PLOT.color = 0.8*ones(3,1);
	end
end;

for i = 1:k
	figH		= subplot(R,C,i);
	[Xi_nan,Ii]	= removenan(X(:,i));
	
	if rem_nan == 1;
		Xi = Xi_nan;
	else
		Xi = X(:,i);
	end;
	T				= size(Xi,1);
	if isempty(AREA_PLOT)
		plot(Xi,'LineWidth',LW);
	else
		if sum(i == AREA_ii)
			find(AREA_PLOT.xvec==1);
			bar(Xi,1,'FaceColor',AREA_PLOT.color)
		else
			plot(Xi,'LineWidth',LW);
		end
	end
	tmp_ 					= get(gca,'YTick');
	tckalt0 			= tmp_(1):((tmp_(end)-tmp_(1))/4):tmp_(end);
	% tmp2_ = str2num(get(gca,'YTickLabel'))
	% size(tmp2_)
	Ytick_L(i,:) 	= tmp_(1);
	Ytick_H(i,:) 	= tmp_(end);
	% Yticks2(i,:) = tmp2_(1);

	set(figH,'FontSize',Fntsize(1),'FontName','Palatino');
	if length(dates)>0
		if rem_nan == 1;
			dates_nan = dates(~Ii);
		else
			dates_nan = dates;
		end;
% 		setdateticks(dates_nan,date_fmt,intrval);
	end;
	
 	if ~isempty(names)
		if ~abc_title==0
			names_i = ['(' abc_seq(i) ') ' char(names(i))];
		else
			names_i = names(i);
		end
% 		title(names_i,'Interpreter','latex')
		th_ndle = title(names_i,'Fontsize',Fntsize(2));
		if ~title_space==0
			set(th_ndle,'Units','normalized','Position',title_space);
		end;
 	end;
	
	% horizontal lines
	hlh = hline(0,'k-');
	xlim([1 T]);
	
	% check to see if ylimits specifier is empty
	if ~isempty(setylims)
		if rws > 1;
			if ~isempty(setylims{i})
				setyticklabels([setylims{i}]);
			else
				% IF NOT SET, TAKE THEM FROM THE DATA
				ylim([tmp_(1) tmp_(end)]);
				% set(gca,'YTickLabel',tckalt0);
				set(gca,'YTick'			,tckalt0,'FontName','Palatino');
			end
		else
			setyticklabels([setylims]);
		end
	else
		% IF NOT, GET THEM FROM THE DATA
		ylim([tmp_(1) tmp_(end)]);
	end;
	if mveyticklable~=0
		moveyticklabel(mveyticklable,Fntsize(3),frmtvec{i})
	end;
	
	% STET YLIMITS TO WHAT THEY ARE NOW.
	tmp_0 = get(gca,'YTick');
	Ytick_L(i,:) = tmp_0(1);
		
	% REDUCE LINE WIDTH
	set(gca,'linewidth',.25)
	set(hlh,'linewidth',.25)
	
	if ~isempty(rot)
		if ~isempty(lbl_space)
			th = rotateticklabel(figH,rot,[],Ytick_L(i),lbl_space);
			set(th,'FontName','Palatino')
		else
			th = rotateticklabel(figH,rot,[],Ytick_L(i));
			set(th,'FontName','Palatino')
		end
	end
	% STORE THE FIGURE HANDLE
	fighndl(i,1) = figH;
	% grid on;
	if TckShrink ~= 0;
		tickshrink(TckShrink);
 	end
end;

% SQUEEZE THE PLOT TO ELIMINATE USELESS SPACE
if ~isempty(sqeez)
	subplotsqueeze(gcf,sqeez);
end;

% STORE YLIMITS THAT ARE SET AUTOMATICALLY
ytick_out = [Ytick_L Ytick_H];

%%
% 		if isempty(SC)
% 			SC = Yticks(i);
% 		end;


% % 	if ~isempty(rot)
% % 		if isempty(SC)
% % 			SC = Yticks(i);
% % 			th = rotateticklabel2(figH,rot,SC);
% % 		else
% % 			th = rotateticklabel2(figH,rot);
% % 		end;
% % 	end
% isempty(SC)












