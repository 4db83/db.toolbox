function [exp_tt, rec_exp_matrix_tt, index] = make_expansion_index(recession_tt)
%{F: Takes a timetable (tt) object of rececssion indicators and returns a matrix of expansion 
%			indicators for each expansion period.
% ---------------------------------------------------------------------------------------------
% CALL AS: 
%		exp_tt = make_expansion_index(recession_tt)
%		[exp_tt, rec_exp_matrix_tt] = make_expansion_index(recession_tt) 
% 	[exp_tt, rec_exp_matrix_tt, index] = make_expansion_index(recession_tt)
%										
%	INPUT:	
%		recession_tt = a matlab timetable with recession indicators and dates
%
% OUTPUT: 
%		exp_tt = timetable with expansion indicators for each expansion 
%		rec_exp_matrix_tt = adds the original 
%		index = handle to axis objects. if not called not returned.
% ---------------------------------------------------------------------------------------------
% Created :		07.01.2019.
% Modified:		07.01.2019.
% Copyleft:		Daniel Buncic.
% ---------------------------------------------------------------------------------------------}

% MAKE A DOUBLE/VECTOR OUT OF THE TIMETABLE (TT) OBJECT RECI_0
rec_ind = recession_tt.Variables;
T	= length(rec_ind);
% make a trend index
ttrend = (1:T)';
% CHECK THAT WE FIND THE RIGHT INDICES
% [ttrend rec_ind delta(rec_ind)]

% START/END OF EXPANSION
expBeg = find(delta(rec_ind)==-1);
expEnd = find(delta(rec_ind)== 1)-1;

% check if first Recession indicator date is 1.
if rec_ind(1)==1
	t0 = [expBeg];
else 
	t0 = [1;expBeg];
end

tT = [expEnd;T];

for ii = 1:length(t0)
	time_period = (t0(ii):tT(ii))';
	index{ii,1} = time_period;
end

% make matrix of dimension Tx(No. of Expansions) with 1 for each expansion periods episode
exp_matrix = zeros(T,length(index));

% fill with 1s at expansion points for each episode
for j = 1:length(index)
	exp_matrix(index{j},j) = 1;
end

% MAKE A EXPANSION_MATRIX TT OBJECT
% first make the var_names
numbers_i = cellstr(num2str((1:length(index))'));
numbers_	= strrep(numbers_i,' ','');
var_names = cellstr([repmat('exp_I_',length(index),1) char(numbers_) ]);
% make the tt object
exp_tt = array2timetable(exp_matrix, 'RowTimes', recession_tt.Time, 'VariableNames', var_names);
% head(exp_tt)
% JOIN TO THE EXISTING RECESSION VECTOR
rec_exp_matrix_tt = join(recession_tt,exp_tt);
% head(exp_ttout)

end % EOF
%%













































%EOF