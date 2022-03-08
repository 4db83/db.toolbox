function [varargout] = fan(X,upper_Y,lower_Y,colr) % ,color,edge,add,transparency)
% Does Confidence Interval (CI) shading rather than CI bands.
% 
% X				= (Nx1) vector of X-axis points of the plot.
% upper_Y	= (Nx1) vector of upper CI values on Y axis.
% lower_Y = (Nx1) vector of lower CI values on Y axis.
% color		= CI shading color. If not supplied, set to grey.
%

% SORT THEM ON X VALUES FIRST if not already sorted
[~,SI]		= sort(X);

X					= X(SI)';
upper_Y		= upper_Y(SI)';
lower_Y		= lower_Y(SI)';

if nargin<4;
	% colr = [.9 .9 .9]; % default color is grey;
	colr = .8*ones(1,3); % default color is grey;
end;

filled	= [upper_Y,fliplr(lower_Y)];
X	= [X,fliplr(X)];
fillhandle = fill(X,filled,colr,'EdgeColor','none');

if nargout > 0
	varargout{1} = fillhandle;
end	
