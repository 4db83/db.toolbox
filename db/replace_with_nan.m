function [Xreplaced,replacedI] = replace_with_nan(X,num_value,col_names,row_names,show_them)
% F: replaces X which contains 0s, with nans for the 0s.
% CALL AS: Xreplaced = replace_with_nan(X)
% ----------------------------------------------------------------------------------------------
[Nr,Nc] = size(X);

default_col_names = char([repmat('Col(',Nc,1) num2str((1:Nc)') repmat(')',Nc,1)]);
default_row_names = char([repmat('Row(',Nr,1) num2str((1:Nr)') repmat(')',Nr,1)]);

SetDefaultValue(2,'num_value', 0)
SetDefaultValue(3,'col_names',default_col_names)
SetDefaultValue(4,'row_names',default_row_names)
SetDefaultValue(5,'show_them', 0)

% ----------------------------------------------------------------------------------------------
% check if X is a logical, if so, convert to double.
if isa(X,'logical'); X = double(X); end

I0			= X==num_value;				% zero entries Indicator
sI			= sum(I0)~=num_value;	% sum to see which columns have zero entries
II			= I0(:,sI);						% column of Indicators with 1 entries to get row entry/dates
indxF		= 1:Nc;								% index  from 1:212
indx_0	= indxF(sI);					% find the 0 entries columns and store the column numbers

replacedI.rows = find(II);
replacedI.cols = indx_0;

% get asset nanmes with 0 entries
col_names_with_0	= col_names(sI,:);

% % if show_them == 1;
% % 	fprintf(' Data that have a 0 entry are: \n')
% % 	sep
% % end;

for ii = 1:size(II,2)
	% print screen
	if show_them == 1
		fprintf(' %s \n', char(col_names_with_0(ii,:)));			% assets types
		disp(cellstr((row_names(II(:,ii),:))));
	end
	
	% replace the nans in row with col ii==1 of II, and col corresponding to the indx_0
	X(II(:,ii),indx_0(ii))	= nan;
end

Xreplaced = X;