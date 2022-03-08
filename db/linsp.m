function y = linsp(d1, d2, n)

if nargin < 3
	n = 1000;
end;

y = linspace(d1, d2, n)';
