function [S, ac0, pac0] = plotacf0(aL, bL, No_acf, ylims, plot_dims, FNT)
%   function varargout = plotacf(    x,no_acf,ylims,plot_dims,FNT,Legnd,plfg)
% call as: [S,ac0,pac0] = plotacf0(aL_bic,bL_bic,50,[-.2 -.2],[.38 .20],22);
% Plots the theoretcial ACF and PACF values.
%
% or as simply:
% plotacf0(aL,bL,No_acf)
%
% where: 
%   aL = [1 -0.3614];
%   bL = [1 +0.3];
%   No_acf = Nubmer of ACFs to plot.
%   ylims = [-.2 -.2] lower bounds on the y axis for the two plots
%   FNT = font size.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(3,'No_acf',50);
% SetDefaultValue(4,'ylims',[]); set below
SetDefaultValue(5,'plot_dims',[])
SetDefaultValue(6,'FNT',[22 22])
% bar color
CLR = [.7 .8 1];

% compue the theoretical ACFs and PACFs
plot_dims0  = [.38 .21]; % this is the default

% fig_postion function
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

% make ACFs/PACFs
ac0			= acf0(aL,bL,No_acf);
pac0		= pacf0(aL,bL,No_acf);
% drop the first one that is equal to 1.
ac0			= ac0(2:end);
pac0		= pac0(2:end);

% lower bounds on the ACF/PACF plot
mac_pac	= min(min(ac0),min(pac0));
xm_grid = ([-.2:-.2:-1])';
plt_min = xm_grid(sum(mac_pac<xm_grid)+1);

SetDefaultValue(4,'ylims',plt_min*ones(2,1));

if isempty(ylims);      ylims	= plt_min*ones(2,1);  end
if length(ylims)==1;    ylims = ylims*ones(2,1);   end

FNT1 = FNT(1);
if length(FNT)==1; FNT2 = FNT(1); else; FNT2 = FNT(2); end

S = zeros(2,1);

% do the plots now 
S = []; 
% THE ACF
S(1) = subplot(121); LL = [];
  LL(1) = bar(ac0, 'FaceColor',CLR,'EdgeColor',CLR);
box on; grid on;
xlim([.25 No_acf+0.5]);
ylim([ylims(1) 1.001]);
setplot(f1, FNT1, 1);
setxticklabels([1 get(S(1),'XTick')],S(1));
xlim([.0 No_acf+1]);
setyticklabels(ylims(1):.2:1, 1);
xclr = get(gca,'XColor');
h0 = hline(0); set(h0,'Color',xclr)
set(gca,'GridLineStyle',':','GridAlpha',1/3);
tickshrink(.8)
setoutsideTicks
legendflex(LL,{'ACF'}, 'fontsize', FNT1 - 1);
    
% THE PACF
S(2) = subplot(122); LL = [];
  LL(1) = bar(pac0, 'FaceColor',CLR,'EdgeColor',CLR);
box on; grid on;
xlim([.25 No_acf+0.5]);
ylim([ylims(2) 1.001]);
setplot(f2, FNT2, 1);
setxticklabels([1 get(S(2),'XTick')],S(2));
xlim([.0 No_acf+1]);
setyticklabels(ylims(2):.2:1, 1);
xclr = get(gca,'XColor');
h0 = hline(0); set(h0,'Color',xclr)
set(gca,'GridLineStyle',':','GridAlpha',1/3);
tickshrink(.8)
setoutsideTicks
legendflex(LL,{'PACF'}, 'fontsize', FNT2 - 1);











































%EOF