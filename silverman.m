function bandwidth=silverman(x)
% calculates the silverman rule of thumb bandwidth for a matrix x

n=size(x,1);
q25=prctile(x,25);
q75=prctile(x,75);

bandwidth=1.06*min(std(x),(q75-q25)/1.34)*n^-(1/5);

% if q75-q25 ~= 0
%    bandwidth=1.06*min(stds,(q75-q25)/1.34)*n^-0.2;
% else
%    bandwidth=1.06*stds*n^-0.2; 
% end;


