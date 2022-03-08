function fts_out = addmat2fts(fts_in, matrix_in, names_in)
% FUNCTION: adds a data matrix (with names) to an existing fints object. 
% ------------------------------------------------------------------------------------------------------
% CALL AS:	fts_out = addmat2fts(fts_in, matrix_in, names_in)
% ------------------------------------------------------------------------------------------------------
% INPUT: 
% matrix_in			= matrix of values to be added to the fints object, ie, matrix_in	= [y dy d2y];
% names_in			= cellarray of variable names, ie., names_in	= {'y';'dy';'d2y'};
%									ALL OTHER ENTRIES ARE TAKEN FROM FTS_IN.
% 
% OUTPUT:
% fts_out				= fints object with new data matrix added.
% ------------------------------------------------------------------------------------------------------
% db (20.02.2018).
% ------------------------------------------------------------------------------------------------------

% get fieldnames
fieldnames_fts = fieldnames(fts_in);

% % input
% % matrix_in	= [y dy d2y];
% % names_in	= {'y';'dy';'d2y'};

% output 
matrix_joint	= [fts2mat(fts_in) matrix_in];

[Nr,Nc] = size(names_in);

if Nc>Nr
	names_in = names_in';
end

names_joint		= [fieldnames_fts(4:end); names_in];

% fints output 
fts_out = fints(fts_in.dates, matrix_joint, names_joint, fts_in.freq, fts_in.desc);

end
