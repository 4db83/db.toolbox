function [S, ac, pac] = plotacf(x, No_acf, ylims, plot_dims, FNT)
% function [S,ac,pac] = plotacf(x, No_acf, ylims, plot_dims, FNT)
%   
% CALL AS: [S,ac,pac] = plotacf(x,50,[-.2 -.2],[.38 .20],22);
% Plots the sample ACF and PACF values.
%
% or as simply:
%                 plotacf(x)
%
% WHERE: 
% 	x = is the input data
%
% optional function inputs
%   No_acf  	= Number of ACFs to plot.
%   ylims   	= [-.2 -.2] lower bounds on the y axis for the two plots
%   plot_dims = [.05 .55 .38 .20] a (1x2), (1x3) or (1x4) positioning vector
%   FNT     	= font size.
% ---------------------------------------------------------------------------------------------
% db, Stockholm 16.03.2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(2,'No_acf',50)
% SetDefaultValue(3,'ylims',plt_min*ones(2,1)); see Below
SetDefaultValue(4,'plot_dims',[])
SetDefaultValue(5,'FNT',[22 22])
% bar colour
CLR = [.7 .8 1];

% plot dimensions
plot_dims0  = [.38 .20]; 

% CHECK IF SERIES IS AN FINTS OBJECT
if isa(x, 'fints');	x = fts2mat(x); end
% remove nans if exist
x = rmvnan(x);

% COMPUTE THE ACFS AND PACFS
nx  = size(x, 1);
ac0	= acf_f(x,No_acf+1);
ac	= ac0(2:end);
pac	= pacf_f(x,No_acf,ac0)';		

% LOWER BOUNDS ON THE ACF/PACF PLOT
mac_pac	= min(min(ac0),min(pac));
xm_grid = ([-.2:-.2:-1])';
plt_min = xm_grid(sum(mac_pac<xm_grid)+1);
thr			=	2/sqrt(nx); % 2*sqrt(T)

% FIG_POSTION FUNCTION
fig_pos = @(x,z) ([x .5 z]);

if isempty(plot_dims)  
  LP1 = .08;
  LP2 = .49;
  f1 = fig_pos(LP1,plot_dims0);
  f2 = fig_pos(LP1+LP2,plot_dims0);
else 
  if length(plot_dims) == 2 
    LP1 = .08;
    LP2 = .49;
    f1 = fig_pos(LP1,plot_dims);
    f2 = fig_pos(LP1+LP2,plot_dims);
  elseif length(plot_dims) == 3 
    LP1 = plot_dims(1);
    LP2 = .49;
    f1 = fig_pos(LP1,plot_dims(end-1:end));
    f2 = fig_pos(LP1+LP2,plot_dims(end-1:end));
  elseif length(plot_dims) == 4
    LP1 = plot_dims(1);
    LP2 = plot_dims(2);
    f1 = fig_pos(LP1,plot_dims(end-1:end));
    f2 = fig_pos(LP1+LP2,plot_dims(end-1:end));
  end
end 

% YLIMS
SetDefaultValue(3,'ylims', plt_min*ones(2,1) );
if isempty(ylims);   ylims = plt_min*ones(2,1); end
if length(ylims)==1; ylims = ylims*ones(2,1);   end

% font
FNT1 = FNT(1);
if length(FNT)==1; FNT2 = FNT(1); else; FNT2 = FNT(2); end

S = []; 
% THE ACF
S(1) = subplot(121); LL = [];
  LL(1) = bar(ac, 'FaceColor',CLR,'EdgeColor',CLR);
  LL(2) = hline_f(thr,'-.r');
          hline_f(-thr,'-.r');
box on; grid on;
setplot(f1, FNT1, 1);
xlim([.25 No_acf+0.5]); 
ylim([ylims(1) 1.001]);
setxticklabels([1 get(S(1),'XTick')],S(1));
xlim([.0 No_acf+1]);
setyticklabels(ylims(1):.2:1, 1);
set(gca,'GridLineStyle',':','GridAlpha',1/3);
hline(0); tickshrink(.8); setoutsideTicks
legendflex(LL,{'ACF','95% CI'}, 'fontsize', FNT1 - 1, ncol = 2);
    
% THE PACF
S(2) = subplot(122); LL = [];
  LL(1) = bar(pac, 'FaceColor',CLR,'EdgeColor',CLR);
  LL(2) = hline_f(thr,'-.r');
          hline_f(-thr,'-.r');
box on; grid on;
setplot(f2, FNT2, 1);
xlim([.25 No_acf+0.5]);
ylim([ylims(2) 1.001]);
setxticklabels([1 get(S(2),'XTick')],S(2));
xlim([.0 No_acf+1]);
setyticklabels(ylims(2):.2:1, 1);	
set(gca,'GridLineStyle',':','GridAlpha',1/3);
hline(0); tickshrink(.8); setoutsideTicks
legendflex(LL,{'ACF','95% CI'}, 'fontsize', FNT2 - 1, ncol = 2);

end

function r=acf_f(x,nac)
	% ==========================================================================
	% SUPER FAST ACF COMPUTATION
	% r=acf(x,normflg)
	% ==========================================================================
	%  This function computes the acf r(k) k=0:length(x)
	%  CAUTION the first value r(1) is hat{gamma}(0) IE the first lag is 0
	% x = time series vector (column)
	% normflg 0 to divide by nr=length(x)
	%         1 to divide by nr*sample variance
	%         2 to divide by nr-k
	%         3 to divide by (nr-k)*sample variance
	% ==========================================================================
	[nr,nc]=size(x);
	if nc > nr
	    error('x must be a column vector');
	end
	
	x = x - repmat(mean(x),nr,1);
	
	r = conv(flipud(x),x);
	r = r(nr:end);
	r = r/nr;
	r = r/r(1);
	r = r(1:nac);
end

function pr=pacf_f(x,m,rho)
	% ==============================================================================
	% pr=pacf(x,m,plfg)
	% ==============================================================================
	% computes the pacf of the series in x
	% ==============================================================================
	% x = input series
	% m = maximum lag to compute
	% pa = pacf(j) j=1:m
	% ==============================================================================
	% first compute all the sample correlations needed
	nx=length(x);
	pr(1)=rho(2); % lag 1 rho
	%pr=zeros(1,m);
	for k=2:m
	   pmat=toeplitz(rho(1:k));% lag 0 to k-1
	   rhovec=rho(2:k+1);		% lag 1 to k
	   phi=inv(pmat)*rhovec;
	   pr(k)=phi(k);
	end
end

function hhh=hline_f(y,in1,in2)
	% ==============================================================================
	% function h=hline(y, linetype, label)
	% ==============================================================================
	% Draws a horizontal line on the current axes at the location specified by 'y'.  Optional arguments are
	% 'linetype' (default is 'r:') and 'label', which applies a text label to the graph near the line.  The
	% label appears in the same color as the line.
	%
	% The line is held on the current axes, and after plotting the line, the function returns the axes to
	% its prior hold state.
	%
	% The HandleVisibility property of the line object is set to "off", so not only does it not appear on
	% legends, but it is not findable by using findobj.  Specifying an output argument causes the function to
	% return a handle to the line, so it can be manipulated or deleted.  Also, the HandleVisibility can be 
	% overridden by setting the root's ShowHiddenHandles property to on.
	%
	% h = hline(42,'g','The Answer')
	%
	% returns a handle to a green horizontal line on the current axes at y=42, and creates a text object on
	% the current axes, close to the line, which reads "The Answer".
	%
	% hline also supports vector inputs to draw multiple lines at once.  For example,
	%
	% hline([4 8 12],{'g','r','b'},{'l1','lab2','LABELC'})
	%
	% draws three lines with the appropriate labels and colors.
	% 
	% By Brandon Kuczenski for Kensington Labs.
	% brandon_kuczenski@kensingtonlabs.com
	% 8 November 2001
	% ==============================================================================
if length(y)>1  % vector input
    for I=1:length(y)
        switch nargin
        case 1
            linetype='r:';
            label='';
        case 2
            if ~iscell(in1)
                in1={in1};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            label='';
        case 3
            if ~iscell(in1)
                in1={in1};
            end
            if ~iscell(in2)
                in2={in2};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            if I>length(in2)
                label=in2{end};
            else
                label=in2{I};
            end
        end
        h(I)=hline(y(I),linetype,label);
    end
else
    switch nargin
    case 1
        linetype='r:';
        label='';
    case 2
        linetype=in1;
        label='';
    case 3
        linetype=in1;
        label=in2;
    end
   
    g=ishold(gca);
    hold on

    x=get(gca,'xlim');
    h=plot(x,[y y],linetype,'Linewidth',0.5);
    if ~isempty(label)
        yy=get(gca,'ylim');
        yrange=yy(2)-yy(1);
        yunit=(y-yy(1))/yrange;
        if yunit<0.2
            text(x(1)+0.02*(x(2)-x(1)),y+0.02*yrange,label,'color',get(h,'color'))
        else
            text(x(1)+0.02*(x(2)-x(1)),y-0.02*yrange,label,'color',get(h,'color'))
        end
    end

    if g==0
    hold off
    end
    set(h,'tag','hline','handlevisibility','off') % this last part is so that it doesn't show up on legends
end % else

	if nargout
	    hhh=h;
	end
end


















   
   






%EOF