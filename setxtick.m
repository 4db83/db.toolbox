function [] = setxtick(xdates,frmt,dx,rot)
% set the xticklabel to for time series plots with option to rotate the labels
% call as: 
%      setytick
% or pass in d to specify number of digits.
% db 14.06.2012
% modfified on 10.07.2013

ytck = get(gca,'YTick');

if nargin < 2
  frmt = 'yyyy:mm';
  dx = 20;
end

%if nargin > 1 || nargin < 3
if nargin == 2
  if isnumeric(frmt)==0
    isnumeric(frmt)
    frmt = frmt;
    dx = 20;
  else
    dx = frmt
    frmt = 'yyyy:mm';
  end
end

xg = [1 dx:dx:size(xdates,1)];
set(gca,'XTick',xdates(xg))
set(gca,'XTickLabel',datestr(xdates(xg),frmt))

if nargin == 4
  handl = gca;
  rotateticklabel(handl,90)
end

 
