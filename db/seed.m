function seed( val )
% SEED(val) --- sets the random seed.
% val should be an integer
% if no arguments are given, the clock time is used to set
% the seed

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved
% Version 1.0

if (nargin < 1)
   seed( sum(clock) )
else
   rand('seed', ceil(263+1000*abs(val)));
   randn('seed', ceil( 276+1020*abs(val)));
end
