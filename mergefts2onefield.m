function outputname = mergefts2onefield(cellnames,fts2change,field2get)
% Function: Gets the field 'field2get' from the financial time series 'fts2change' and loops over the
% cellnames 'cellnames' to create one merged time series object with only one field 'field2get' with the
% entries being the names in cellnames. 
% 
% This is useful when wanting to plot information from a fints databases with various starting dates for
% different banks (or entities) and the same fundamental values to plot them or analyse them further. 
% 
% For instance: one can take the fints database FUND which has cellnames {'SEB';'NORDEA' etc} all having different
% starting values for various fundamental entries such as ROA, EPS, etc. and then combine them in one fints
% object that has for one particular fundamental entry such as EPS for instance, all banks merged together to
% one datebase. 
%
% db 06.03.2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fts2_name = 'fts2change';
tmp_strng = [];

% loop over all cellnames
for jj=1:length(cellnames)
	bank_jj = cellnames{jj};
	% make a temporary string name of the cha
	tmp_name = ['chfield(' fts2_name '.' bank_jj '.' field2get ',''' field2get ''',''' bank_jj '''),'];
 	tmp_strng = [tmp_strng tmp_name];
end

tmp_string_eval = ['tmp_output_name = merge(' tmp_strng	'''DateSetMethod'',''Union'');'];

% evaluate the string now.
eval(tmp_string_eval)
% assign outputname
outputname = tmp_output_name;