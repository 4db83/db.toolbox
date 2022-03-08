function [h,height] = histogram_adj_height(x,p,plot_N01,histclr,baselinewidth,EdgeLinewidth) 
% compute a histogram with p cells
% usage: h = histogram_adj_height(x,p,plot_N01,histclr,baselinewidth,EdgeLinewidth) ; 
% FC optional histogram facecolor default is 0.8 (Gray)
%
%
% h = figure handle (if needed).
% x = data 
% p = number of subintervals 

[nR,nC] = size(x);

if nC > nR
	x = x';
end;


SetDefaultValue(2 ,'p'		, sshist(x));
% if nargin < 2
% 	p = 100;
% 	p = sshist(x)
% %	plot_N01 = [];
% end;

if nargin < 3
	plot_N01 = [];
end;

% facecolor
if nargin < 4
	FC = 0.6;
	EC = 0.8;
else
	FC = histclr(1);
	EC = histclr(2);
end;

if nargin < 5
	baselinewidth = 1;
end

if nargin < 6
	EdgeLinewidth = .5;
end


% % edge color
% if nargin < 5
% 	EC = 0.95;
% end

if( (p<=0) || length(x)<p)  
    error(' p<= 0  or length(x) < p ')
elseif(length(x)<1) 
    error('error, null vector')  
elseif (min(size(x))>1)
    error('error, matrix input') 
end
set(gca, 'Layer','top')			

I = ones(3,1);
[count,xvals]	= hist(x,p);

Nx			= length(x);
delta		= xvals(2)-xvals(1); 

% NOT SURE WHY HE IS DOING THAT.
% height	= count/(delta*sum(count)); 
height	= count/Nx;

%hh			= bar(xvals,height,1.0);  % handle to output.
hh			= bar(xvals,height,1.0,'FaceColor',FC*I,'EdgeColor',EC*I,'LineWidth',EdgeLinewidth);
% get(hh,'LineWidth')

% set basline line to none;
if baselinewidth == 0;
	set(get(hh,'Baseline'),'LineStyle','none')
else
	set(get(hh,'Baseline'),'LineWidth',baselinewidth)
end;
	

% plot all of them
set(gca,'Fontsize',12);set(gca,'Fontname','Palatino');
set(gca, 'Layer','top')			


if plot_N01 == 0;
	setytick(3)
end

if nargout>0
	h = hh;		
end

mm = max(0.45,1.1*max(height));

if length(plot_N01) > 0
	if length(plot_N01) > 1;
		M = plot_N01(1);
		V = plot_N01(2);
	else
		M = 0;
		V = 1;
	end;
	xgr = linspace(-6,6,1000);
	fxn = normpdf(xgr,M,sqrt(V));
	hold on;
	plot(xgr,fxn,'r','LineWidth',.8);
	ylim([0 mm])
	hold off;
	setytick(2)
end

set(gca,'FontName','Times');
setytick(2)

%ylim([0 mm])
