function b = bernrnd(p,varargin)
%	BERNRND Random arrays from the Bernoulli (Binary) distribution.
%   b = BERNRND(P,MM,NN) returns an array of random numbers chosen from a
%   Bernoulli distribution with probablity parameters p.
%

if nargin < 2
  error(message('stats:bernrnd:TooFewInputs'))
end


if( (p<0)||(p>1) )
  error(' Success probalbity has to be in 0,1 interval ')
end

sizeout = cell2mat(varargin);
b	= rand(sizeout) < p;
