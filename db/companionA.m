function [Aout,Cnst] = companionA(paramvec,K,P)
%{F: Takes output from ic_var and puts in companion format
%===============================================================================
% Makes it easy to forecast from general VAR(p) model
%-------------------------------------------------------------------------------
% 	USGAGE:	[Aout,Cnst] = companionA(paramvec,K,P)
%-------------------------------------------------------------------------------
% 	INPUT : 
%	  paramvec  = (Gx1) paramvector from ic_var function, where G = K*K*P+K.
%   K         = is number of variabls in the VAR.
%   P         = lag order of the VAR  
%                 
% 	OUTPUT:       
%	  Aout      = Companion matrix of VAR pareamters.
%   Cnst      = Companiont matrix of Constant/intercpt term. 
%===============================================================================
% 	NOTES :     best used with xlswrite(xls_out_name,cellstr(strng),'Sheet1','A2');
%-------------------------------------------------------------------------------
% Created :		05.06.2013.
% Modified:		05.06.2013.
% Copyleft:		Daniel Buncic.
%------------------------------------------------------------------------------%}

[RA,CA] = size(paramvec);

if CA == 1;
  G1 = K*(K*P+1); % with constant
  G0 = K*(K*P);   % without constant
  AA = reshape(paramvec,size(paramvec,1)/K,K)';
  if RA == G1;
    Aout = [AA(:,2:end); [eye((P-1)*K) zeros((P-1)*K,K)]];
    Cnst = [AA(:,1);zeros(K*(P-1),1)];
  elseif RA == G0;
    Aout = [AA; [eye((P-1)*K) zeros((P-1)*K,K)]];
    Cnst = [zeros(K*(P),1)];
  else
    disp('dimension error');
  end;    
else % if the input is in [A1;A2 ... Ap form]
  Aout = [paramvec; [eye((P-1)*K) zeros((P-1)*K,K)]];
end;

