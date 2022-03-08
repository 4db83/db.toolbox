function CW  = add2structs(S1,S2)
% Function: adds entries from fields of two structuers.
% --------------------------------------------------------------------------------------------------
% Returns new structure with the same fields but elements added together.
% db
% --------------------------------------------------------------------------------------------------

% get structure fieldnames
m1 = fieldnames(S1)';
m2 = fieldnames(S2)';

if length(m1)~=length(m2); error(' Different number of strcucture fields'); end;

% check if they are the same
mm_out = strcmp(m1',m2');
if sum(mm_out == 0); error(' Structure Fields are not the same'); end;

% get field numbers
a1 = struct2array(S1);
a2 = struct2array(S2);

% add them together
aa = a1 + a2;

% prepare output.
CW = struct;
for i = 1:length(m1)
	CW = setfield(CW,m1{i},aa(:,i));
end;
