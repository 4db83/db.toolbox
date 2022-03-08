function h = tsplot(x,begyear,begmonth,dtkformat,Ndtk);
%{F: Does a time series plot for monthly/quarterly data.						
%===============================================================================
% This improves on matlabs plot function when a quick ts plot wiht dates is needed.
%-------------------------------------------------------------------------------
% 	USGAGE:	h = tsplot(x,begyear,begmonth,datetickformat,Ndateticks);
%-------------------------------------------------------------------------------
% 	INPUT : 
%	x					=	(Tx1) time series array.
%	begyear		=	scalar beginning year of time series.
%	begmonth  =	scalar beginning month of time series. 
%	dtkformat =	string of date formatat, ie., 'mmm:yyyy' or 'yyyy:QQ' for 
%							monthly and quarterly.
%	Ndtk		  =	scalar number of date ticks on the x (time axis) to control 
%							the readablity of the axis. 
%                 
% 	OUTPUT:       
%	h					= Figure handle
%             where shortstr(i) is equal to longstr.
%===============================================================================
% 	NOTES :		Follow up with 
%					    - setplot([.8 .5], 9) to set plot dimiensions and
% 					  - print2pdf('filenameout');
%-------------------------------------------------------------------------------
% Created :		22.05.2013.
% Modified:		22.05.2013.
% Copyleft:		Daniel Buncic.
%------------------------------------------------------------------------------%}

T     = size(x,1);
%% make daily date vector from monthly data. 
dat0  = bsxfun(@(Month,Year) datenum(Year,Month,1),(1:12).',begyear:(begyear+T/4));
dat1  = dat0(:);
datx  = dat1(begmonth:T+begmonth-1);  % correct date vector size.
%% Plot series datevector number;
D     = ceil((T)/Ndtk);
tgrid = [1 [D:D:T] T];
plot(datx,x,'Linewidth',1);
set(gca,'XTick',datx(tgrid),'FontName','Palatino');
axis tight;
datetick('x',dtkformat,'keepticks','keeplimits');
%%
% begyear = 1980;
% begmonth = 1;
% Ndateticks = 8;
% datetickformat = 'mmm yyyy';

