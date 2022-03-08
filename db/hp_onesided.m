% daniel's HP filter version 
% returns the permanent component of a series called data.
% L (Lambda) is the  smoothing paremater.

function [cycle_1,trend_1] = hp_onesided(data,lambda,init_hp)

T       = size(data,1);
cycle_1 = zeros(T,1);


if nargin < 3;
  init_hp = 0;
end;

%% looping through the end points of each HP filtered cycle
for i = 3:T;
  tmp         = hp(data(1:i),lambda);
  cycle_1(i)  = tmp(i);
  if i == 3;
    inits = tmp(1:2);
  end;
end;
trend_1 = data - cycle_1;

if init_hp == 1;
  cycle_1(1:2) = inits;
end;
