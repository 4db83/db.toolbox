g_ = graph_h


% Set Properties to Factory-Defined Values
% Specifying a property value of 'factory' sets the property to its factory-defined value. For example, these statements set the EdgeColor of surface h to black (its factory setting), regardless of what default values you have defined:

set(gcf,'defaultSurfaceEdgeColor','g')
h = surface(peaks);
set(h,'EdgeColor','factory')

% List Factory-Defined Property Values
% You can list factory values:
get(groot,'factory') — List all factory-defined property values for all graphics objects
get(groot,'factoryObjectType') — List all factory-defined property values for a specific object
get(groot,'factoryObjectTypePropertyName') — List factory-defined value for the specified property.

% Use below code in Command Window or script and title will be in 'normal' form
set(0,'DefaultAxesTitleFontWeight','normal');
set(groot,'DefaultAxesTitleFontWeight','normal')

%% NEW PLOTTING COMMANDS AND LEGEND
% only use this if needed.
set(gca, 'Layer','top')	

% SOME PRELIMINARY PLOTS
DF	= 65; 
dFN = 10;
tPS = -1.21;
tFN = 12;
yFN = 11;

% define legend string for all entries.
leginfo1	= 'legendflex(names,''fontsize'',12,''padding'',[5 4 5],';
leginfo2	= '''anchor'',{''nw'',''nw''},''buffer'',[0 0], ''xscale'',.5);';
leginfo		= [leginfo1 leginfo2];

subplot(3,1,1);
plot(Pt,FH.lw,1); 
setdateticks(dates,'mmm yyyy',DF)
setyticklabels(0:20:240,0,yFN);
%setplot([.7 .4],[],1);
rotateticklabel(gca,90,dFN);
xlim([0 length(dates)+10])
tickshrink(.5)
eval(leginfo)
subtitle('(a) Price series',tPS,tFN);
grid on;

subplot(3,1,2);
plot(rt,FH.lw,1); 
hline(0)
setdateticks(dates,'mmm yyyy',65)
setyticklabels(-.25:.05:.3,2,yFN);
%setplot([.7 .4],[],1);
rotateticklabel(gca,90,dFN);
xlim([0 length(dates)+10])
tickshrink(.5)
eval(leginfo)
subtitle('(b) Daily return',tPS,tFN);
grid on;
				
subplot(3,1,3);
plot(rt_yoy,FH.lw,1); 
hline(0)
setdateticks(dates,'mmm yyyy',65)
setyticklabels(-1:.5:4,1,yFN);
%ylim([0 4.5])
%setplot([.7 .4],[],1);
rotateticklabel(gca,90,dFN);
xlim([0 length(dates)+10])
tickshrink(.5)
eval(leginfo)
subtitle('(c) Year-on-Year return',tPS,tFN);
grid on;

% shrink the plot area
subplotsqueeze(gcf,[1.17 1.1]);
		
print2pdf('returns');




% ---------------------------------------------------------------------------
%% some plotting commands
% ---------------------------------------------------------------------------


LW = 1.5;
plot(yT			 ,'k',g_.lw,LW);hold on;
plot(yhat_exp,'g',g_.lw,LW);
plot(yhat_rec,'r',g_.lw,LW);
plot(yhat_tvp,'b',g_.lw,LW);
axis tight;
ylim([-4 5])
setyticklabels([-4:1:5])
setdateticks(datesT,'yyyy:QQ',150)
setplot([.8 .4],8)
grid on;
print2pdf('aout')
hold off;

% ---------------------------------------------------------------------------
%% working with dates and compbining dates
% ---------------------------------------------------------------------------
mdate   = datenum(date_str,'yyyy-mm-dd');

% createing a date vector
date_0  = datenum(2001,12,19)
date_1  = datenum(2001,12,31)
dates_  = (date_0:date_1)'
datestr(dates_,'dd:mm:yyyy')

% make time series object for daily data as given in the excel file
bb_ts   = fints(mdate,nss_b);           % for the nss weights, (b0,b1, ...)

% convert to monthly series (end-of-month)
bb_ts_m = tomonthly(bb_ts,'CalcMethod','Nearest');

string_date   = datestr(bb_mat(1:end-1,1),'yyyy:mm'); %datestr((m2xdate(bb_mat(:,1),0),'yyyy:mm');

% more working with dates, set up date 0 and add 1 unit to the number form of it, convert 
% to monthly series using end of month, etc.
date_0  = datenum(2014,01,24)
date_full = date_0:1:735663
dd = date_full'
datestr(dd,'dd.mm.yyyy')
ddstr = ans;
xx = randn(size(ddstr,1),1);
x2m = fints(datenum(ddstr,'dd.mm.yyyy'),xx);
tomonthly(x2m,'CalcMethod','Nearest')

% anonymous funcitons
c = @(a, b, theta) (sqrt(a.^2+b.^2-2*a.*b.*cos(theta)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(SPs,1,4) %----------------------------------------------------------------------------------
hold on;
%%%% fan(Xvalue,upper_Y,lower_Y,color)
fan(xgrid,AP_ub,AP_lb);
SP(1) = plot(Yhat_Mcomp,dy_Th,F.ms,1,F.mk,'x',F.ms,2,F.ls,'None',F.lw,.35,F.me,.3*ones(3,1));
SP(2) = plot(xgrid,AP_npg,'r',F.ls,'-',F.mk,'o',F.ms,1.5,F.lw,.3);
SP(3) = plot(Yhat_Mcomp,AP_ols.yhat,'b',F.lw,.4);
%plot(apout.yhat,yTh,F.ms,1,F.mk,'x',F.ms,2,F.ls,'None',F.lw,.5);hold off
%plot(cumsum(fe2.dma),'r',F.lw,LW);
hold off;
%axis tight
xlim([min(Yhat_Mcomp) max(Yhat_Mcomp)])
LHd = legend(SP,'Scatter(Predicted, Actual)',...
						 'LOESS (non-parametric fit)',...
						 'OLS (linear fit)',F.lc,'NorthWest');
set(LHd,F.fs,FSl,'Box', 'on',F.ot,'vertical');%,'Position', [.098,.0,0,0]);
%setxticklabels(DS_Xtcks)
setyticklabels(DS_Ytcks)
%ylim([-41.1 40])
box on;
% to show plot ticks and lines on top of area/fan chart use LAYER on TOP as below
set(gca, 'Layer','top')	
hl = hline(0);set(hl,'linewidth',LW/2);
%VL = vline(0,'k-.');VL = vline(-4,'k--');set(VL,'linewidth',LW/2)
setplot(PP,FSs)
set(gca,'linewidth',.25)
%subtitle('(d) Scatter Plot of Predicted and Actual (with fits)',100.5,5);
subtitle('(d) Scatter Plot of Predicted and Actual (with fits)',99.5,5);
% reduce the legend line length and box size.
setlegendbox(LHd,[39.4 135.5 90 24]);
legendshrink(.3,'r')
% --------------------------------------------------------------------------------------------------
%
print2pdf(['../graphics/forecast_' num2str(h) fout_name])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,1,2)
plot(dy,F.lw,LW); 
setdateticks(dates,Dfmt,TKf)
box on;grid off;
setplot(Pdim,Xft)
setyticklabels(-40:10:40);
xlim([0 T+1])
hline(0,'k-')
subtitle('(b) Return series (log returns)',105,9);
rotateticklabel(gca,90,7);
tickshrink(.4);
%subplotsqueeze(gcf,0.95)


print2pdf(['../graphics/copper'])
disp('finished plotting')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalise the axis text location
plot(randn(100,1))
th = title('x-axis')
set(th,'Units','normalized','Position',[0.5 -.1]);


%%%%%%%%%%%%%%%%%%%%% OLD STUFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(x,y)
dates = datenum(date_str0,'dd.mm.yyyy'); 
% datestr(date_num,'dd.mm.yyyy')
setplot([.8 .4],10)
ylabel('Year','FontName','Palatino','FontSize',10)
set(gca,'YTIckLabel',datestr(dates(ttick'),'yyyy'))
axis tigh
datetick('x','yyyy:QQ','keepticks','keeplimits'); % for dates
