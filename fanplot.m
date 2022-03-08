function [varargout] = fanplot(CI,X,colr) % ,color,edge,add,transparency)
% Does Confidence Interval (CI) shading rather than CI bands.
% INPUTS: CI = (Tx2) vector of [lower CI, upper CI]
% Optional: 
% X				= (Tx1) vector of X-axis grid points of the plot.
%						default is to use a simple 1:T index;
% color		= CI shading color. If not supplied, set to blue.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% db Feb.2015.

SetDefaultValue(2,'X',[1:length(CI)]')
SetDefaultValue(3,'colr',[.85 .94 1])
% SetDefaultValue(3,'colr',[.88 .92 .95])

% check for nans
II = anynan([CI X]);

% if sum(II)>0
% 	disp(' WARNING: Nans INCLUDED in CI ---> THESE have been REMOVED FROM FANPLOT')
% end

% remove manually 
CI 	= CI(~II,:);
X 	= X(~II,:);

upper_Y		= CI(:,2);
lower_Y		= CI(:,1);


% SORT THEM ON X VALUES FIRST if not already sorted
[~,SI]		= sort(X);

X					= X(SI)';
upper_Y		= upper_Y(SI)';
lower_Y		= lower_Y(SI)';	

filled	= [upper_Y,fliplr(lower_Y)];
X	= [X,fliplr(X)];
% fillhandle = fill(X,filled,colr,'EdgeColor','none');
fillhandle = fill(X,filled,colr,'EdgeColor',colr);

if nargout > 0
	varargout{1} = fillhandle;
end	
