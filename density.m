function [fighndl,varargout] = density(X,h,Use_KDE,trans,linesty,histclr,M,xgrid,Fntsize,DoNotPlot)
%% F: Plot of Density of X.                                  
%{==============================================================================
%  CALL: 		function [fighndl,fhat,xgrid,h] = density(X,h,Use_KDE,trans,linesty,histclr,M,xgrid,Fntsize,DoNotPlot)
% ==============================================================================
%  INPUT:	
% ------------------------------------------------------------------------------
%  	X:				(Tx1) data matrix.
%  	h:				smoothing bandwidth parameter. if not supplied silverman(X) is used.
% 	Use_KDE:	indicator, set to 1 if KDE is to be used.
%  	trans:		binary indicator, 0 for transparent histogram in background, 1 for not.
%  	M:				Mean and std.dev vector. Optional for plotting normal density in 
%							background.
%	xgrid:			(Tx1) vector of grid values.
% 
% ==============================================================================
%  OUTPUT:	
% ------------------------------------------------------------------------------
%  	fhat:			fhat(x) given h, ie. density estimate.
% 	xgrid:		X data grid that was used in the evaluation of the density.
%							plot of density.
% ==============================================================================
%  NOTES:	
% ------------------------------------------------------------------------------
%	Uses Gaussian Kernel by default and cannot be changed from function call.
% ==============================================================================
%  Created	:	27/11/2008.
%  Modified	:	12/06/2014.
%  Copyleft	:	Daniel Buncic.
%% ==============================================================================%}

% remove any nans
X	= removenan(X);

tmp_min = min([min(X);mean(X)-4.5*std(X)]);
tmp_max = max([max(X);mean(X)+4.5*std(X)]);

MM	= [mean(X), std(X)];
p		= 500;	% number of grid points
xgrid0	= (linspace(tmp_min,tmp_max,p))';

% if length(X)>5000;
% 	h1 = silverman(X);
% else
% 	h1 = sskernel(X);
% end;

h1 = silverman(X);
% OR sskernel(X);
h2 = sshist(X);

SetDefaultValue(2, 'h'				, [h1;h2]);
SetDefaultValue(3, 'Use_KDE'	, 0);
SetDefaultValue(4, 'trans'		, 1);
SetDefaultValue(5, 'linesty'	, [1.5 .7 .7 1])
SetDefaultValue(6, 'histclr'	, [.44 .99])
SetDefaultValue(7, 'M'				, MM);
SetDefaultValue(8, 'xgrid'		, xgrid0);
SetDefaultValue(9, 'Fntsize'	, 14);
SetDefaultValue(10,'DoNotPlot', 0);

Fns_0 = get(gca,'FontSize');

h1 = h(1);
h2 = h(2);
nx = length(X);

if Use_KDE == 0
% OLD WAY UNCOMMENT BELOW -------------------------------------------------
% COMPUTE THE KERNEL DENSITY ESTIMATE IN VECTORSIZED FROM
% --------------------------------------------------------------------------
	p		= length(xgrid);
	u 		= repmat(X,1,p) - repmat(xgrid',nx,1);
	fhat 	= 1/(nx*h1)*sum(g(u./h1));
	fhat 	= fhat';
else 
% NEW USING THE KDE TOOLBOX -----------------------------------------------
	[BW_H,fhat,xgridKDE] = kde(X,[],min(xgrid),max(xgrid));
	xgrid = xgridKDE;
end

% SET FHAT < 0 = 0 TO PRESERVE POSITIVITY OF DENSITY.
fhat(fhat<0) = 0;

% compute standard errors
k		= (4*pi)^-.5;
asyvar	= fhat*k/((nx-1)*h1);
ub		= fhat+1.96*sqrt(asyvar);
lb		= fhat-1.96*sqrt(asyvar);

% those those less then zero to zero
lb(lb<0) = 0;

% xgrid to evaluate normpdf at.
tmp_min	= min(xgrid);
tmp_max	= max(xgrid);
Normgrid= (linspace(tmp_min,tmp_max,p))';		

C = .8;

% histogratm
% [nbar,xout]   = hist(X,h2);
% mxfhat        = max(fhat)*.95;
% xgmax         = xgrid(fhat==max(fhat));
% plot all of them
I = ones(3,1);

if ~DoNotPlot
	%%%% PLOTTING BEGINS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% clf
	% set(gca,'Fontsize',12);set(gca,'Fontname','Palatino');

	hold on;

	% this plots the background density

	fnorm = normpdf(Normgrid,M(1),M(2));

	if trans
		LG(1) = area(Normgrid,fnorm,'FaceColor',C*I,'EdgeColor',.4*I);
		box on
  end

	% HISTOGRAM PLOT
	% b1 = bar(xout,nbar/max(nbar)*mxfhat,1,'FaceColor',.7*I,'EdgeColor',0*I);
	[b1, h_height] =  histogram_F(X,h2,[],histclr,[],linesty(4));
	% NEW WAY
	%hh = histogram(post_draws(:,2),'BinMethod','scott','Normalization','pdf')

	% Control of transparency
	if trans
		alpha(0.9);
  end

	% Figure handle
% 	fighndl =	plot(xgrid,fhat ,'b','LineStyle','-' ,'LineWidth'	,linesty(1));
% 	nargout == 0
	if nargout == 0 
		LG(2) = plot(xgrid, fhat, 'Color', clr(2),'LineStyle','-' ,'LineWidth'	,linesty(1));
	else 
% 		fighndl =	plot(xgrid,fhat ,'b','LineStyle','-' ,'LineWidth'	,linesty(1));
    fighndl = plot(xgrid, fhat, 'Color', clr(2),'LineStyle','-' ,'LineWidth'	,linesty(1));
	end
	if ~(linesty(2)==0)
						plot(xgrid,ub		,'Color', clr(2), 'LineStyle',':','LineWidth'	,linesty(2));
						plot(xgrid,lb		,'Color', clr(2), 'LineStyle',':','LineWidth'	,linesty(2));
  end
	box on			

  LG(2) = fighndl;
	if ~trans
		if ~linesty(3)==0
			plot(Normgrid,fnorm,'k-','Linewidth',linesty(3));
		end
		box on;
  end

	%plot(Normgrid,normpdf(Normgrid,M(1),M(2)),'k','LineStyle','-','LineWidth',0.5);

	% X/Y LIMITS
	ytcks	= get(gca,'YTick');
	dytk	= diff(ytcks);
	% mmY		= max([max(ub);max(h_height)]);
	% max_Y	= 0.5*(roundup(mmY,1)+roundown(mmY,1));
	% mmy		= max(ytcks)+dytk(end)
	% max_Y = mmy;
	% 
	% ylim([0 max_Y])
	% xlim([min(xgrid),max(xgrid)])
	% vline(M(1),'k-');
	%xlim([(tmp_min),tmp_max]);

	hold off;


	ytck = get(gca,'YTick');
	%%aa   = sprintf('%2.2f|',ytck(2:end));bb=['0|' aa];
	% setplot([.10 .8 .8],11,1)
	%set(gca,'YTickLabel',['0|' sprintf('%2.2f|',ytck(2:end))],'FontName','Palatino','Fontsize',12)
	set(gca,'Fontsize',Fntsize)
	% axis square
	box on;

  % add a legend if needed
  LN	= {	['$\mathrm{N}(\bar{x}$ = ',num2str(mean(X),'%2.2f'),'$, s^2$= ',... 
					num2str(var(X),'%2.2f'),')'],...
          ['$\widehat{f}_h(x),  h=$ ',num2str(h(1),'%2.2f')]};
 % 				['$\widehat{f}_h(x), h_{Silverman}=$ ',num2str(h,'%2.2f')]};

legendflex(LG,LN, 'fontsize', Fntsize + 14, 'anchor',[1 1],'Interpreter','Latex')  

%   legend(LG,LN,'FontName','Palatino Linotype','FontSize',14,...
% 	  	'Location','NorthEast','Orientation','vertical',...     
% 	  	'EdgeColor',[0 0 0],'Interpreter','Latex');



	%%%% PLOTTING END HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

% if nargout > 0
if DoNotPlot; fighndl = [];end
% end

% if nargout == 0
% 	fighndl = ' ';
% end

% if nargout > 0
% 	varargout{1} = fighndl;
% 	varargout{2} = fhat;
% 	varargout{3} = xgrid;
% 	varargout{4} = h;
% end;

% if nargout > 0
	varargout{1} = fhat;
	varargout{2} = xgrid;
	varargout{3} = h;
% end;

% tickshrink(.66)

end % ends main function
      


% gaussian kernel.
% ------------------------------------------------------------------------------
function f = g(z)
f = exp(-0.5*z.^2)./sqrt(2*pi); % faster than normpdf;
%f = normpdf(z,0,1);
end


% histogram furnction kernel.
% ------------------------------------------------------------------------------
function [h,height] = histogram_F(x,p,plot_N01,histclr,baselinewidth,EdgeLinewidth) 
% compute a histogram with p cells
% usage: h = histogram(x,p); 
% FC optional histogram facecolor default is 0.8 (Gray)
%
%
% h = figure handle (if needed).
% x = data 
% p = number of subintervals 

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
	FC = 0.8;
	EC = 0.95;
else
	FC = histclr(1);
	EC = histclr(2);
end

SetDefaultValue(5 ,'baselinewidth'		, .5);
SetDefaultValue(6 ,'EdgeLinewidth'		, .25);

% if nargin < 5
% 	baselinewidth = 1;
% end

% if nargin < 6
% 	EdgeLinewidth = .5;
% end


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

height	= count/(delta*sum(count)); % NOT SURE WHY HE IS DOING THAT.
% height	= count/Nx;

%hh			= bar(xvals,height,1.0);  % handle to output.
hh			= bar(xvals,height,1.0,'FaceColor',FC*I,'EdgeColor',EC*I,'LineWidth',EdgeLinewidth);
% get(hh,'LineWidth')

% set basline line to none;
if baselinewidth == 0;
	set(get(hh,'Baseline'),'LineStyle','none')
else
	set(get(hh,'Baseline'),'LineWidth',baselinewidth)
end;
	
FName = 'Times New Roman';

% plot all of them
set(gca,'Fontsize',12);set(gca,'Fontname',FName);


if plot_N01 == 0
	setytick(3)
end

if nargout>0
	h = hh;		
end

mm = max(0.45,1.1*max(height));

if length(plot_N01) > 0
	if length(plot_N01) > 1
		M = plot_N01(1);
		V = plot_N01(2);
	else
		M = 0;
		V = 1;
  end
	xgr = linspace(-6,6,1000);
	fxn = normpdf(xgr,M,sqrt(V));
	hold on;
	plot(xgr,fxn,'r','LineWidth',.8);
	ylim([0 mm])
	hold off;
	setytick(2)
end

set(gca,'FontName',FName);

end

%ylim([0 mm])




% eof