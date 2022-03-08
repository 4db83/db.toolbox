function p = powerset_old(set)
% Return the power set of a set of integers
% e.g. powerset(1:3) = {[],1,2,3,[1,2],[1,3],[2,3],[1,2,3]}

% This file is from matlabtools.googlecode.com

p = sortfun_F(@(x)numel(x), cellfuncell_F(@(x)set(x),...
    num2cell(dec2bin(2^numel(set)-1:-1:0) == '1', 2)));
end



function out = cellfuncell_F(fun, C, varargin)
% Just like cellfun, except it always returns a cell array
% by setting UniformOutput = false, 
% eg. a=cellfuncell(@(x) upper(x), {'foo','bananas','bar'})
% returns a{1} = 'FOO', etc.

% This file is from pmtk3.googlecode.com


%varargin{end+1} = 'UniformOutput';
%varargin{end+1} = false;  % slow extending varargin unnecessarily
out = cellfun(fun, C, varargin{:},'UniformOutput',false);

end


function x = sortfun_F(f, x)
% Sort a cell array by some function of its elements
%  e.g. sortfun(@(x)numel(x),C) sorts C by the number of elements in each cell.

% This file is from pmtk3.googlecode.com

x = x(sortidx_F(cellfun(f, x)));
end


function [perm,val] = sortidx_F(varargin)
% Return the index permutation that sorts an array

% This file is from pmtk3.googlecode.com

[val,perm] = sort(varargin{:});
end
