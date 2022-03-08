function strct_out = structfun2(fun_hndl,A,B)
% F: perform operation fun_hndl on structures A and B;
% and return a structure after the operation is complete.
%
%	CALL AS:		CW = structfun2(@plus,DM,ADJ_fct);
%----------------------------------------------------------------------------------------
% Created :		05.08.2013.
% Modified:		21.05.2014.
% Copyleft:		Daniel Buncic.
%----------------------------------------------------------------------------------------%}


strct_out = cell2struct(cellfun(fun_hndl,struct2cell(A),struct2cell(B),'UniformOutput', false),fields(A));

