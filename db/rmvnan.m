function Xno_nan= rmvnan(x)
% F: removes nan ROWS.

I = anynans(x);
Xno_nan = x(~I,:);
