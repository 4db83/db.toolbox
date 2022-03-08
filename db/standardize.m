function st=standardize(x,de_mean)
% Standardization of a matrix of data where each column returned will be
% mean zero and have variance 1
%
% USAGE:
%   ST = standardize(X)
%   ST = standardize(X,DEMEAN)
%
% INPUTS:
%   X      - A T by K matrix of data to be standardized
%   DEMEAN - [OPTIONAL] A logical value indicating whether to demean the data (1) or not (0).
%              Default is 1
%
% OUTPUTS:
%   ST - A T by K matrix of standardized data
%
% COMMENTS:
%   For each column j, st(:,j)=x(:,j)-mean(x(:,j))
%                               ----------------
%                                  std(x(:,j))

% Copyright: Kevin Sheppard
% kevin.sheppard@economics.ox.ac.uk
% Revision: 1    Date: 9/1/2005

if nargin < 2
	de_mean = 1;
end;


z_score_x = @(x) (x-nanmean(x)./nanstd(x));

divide_by_std_x_only  = @(x) (x./nanstd(x));

[T,K] = size(x);
stdev = std(x);

if de_mean
%     st = demean(x)./repmat(stdev,T,1);
		st = z_score_x(x);
else
		st = divide_by_std_x_only(x);
%     st = x./repmat(stdev,T,1);
end