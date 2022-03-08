function mat_out = cellarray2mat(cellarray_in,fieldname_in)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% return/extract a matrix from an cell array of fixed size entries. 
% Call as: cellarray2mat(os_eval_results,'period');
% where os_eval_results is a (jx1) cell, with entries .period .T_os .dates etc. 
% this will stack all the rows of a call tmp_struct	= cell2mat(cellarray_in) into a matrix, so 
% the dimension of the elements must be the same that are stacked. 
% conveniente to use when one wants to store even scalar values or 1xK vectors in a cell array.
%
% NOTE: when there are muliple layered strctures, it returns an error.
%
% Created by DB: 28.06.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get strcture with fields and all data entries.
tmp_struct	= cell2mat(cellarray_in);
% form string to be evaluationed
tmp_string	= ['vertcat(tmp_struct.' fieldname_in ');'];
% return the cellarray converted to matrix from or cell matrix if strings.
mat_out			= eval(tmp_string);

