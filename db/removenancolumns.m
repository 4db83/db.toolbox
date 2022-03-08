function [Xno_nan, Inan]= removenancolumns(x)
% F: removes nan COLUMNS.
% Call as: [Xno_nan, Inan]= removenancolumns(x)
% which returns X without the nan columsn Xno_nan
% and a Inan Indicator for which columsn are nan.
% DB 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0		= x;
Inan	= anynan(x0);

x0(:,all(Inan,1)) = [];

Xno_nan = x0;
