function [weights, princ_omp, eigenvals, explvar, cumR2]=pca_mfe(data,type)
% Uncentered or centered (demeaned) principal component analysis 
%
% USAGE:
%   [WEIGHTS,PRINCOMP,EIGENVALS,EXPLVAR,CUMR2]=pca(data,type);
%
% INPUTS:
%   DATA    - a t by k matrix to be decomposed using PCA
%   TYPE    - [OPTIONAL] String, either 'outer', 'cov' or 'corr' that denotees the matrix to use in
%               computing the principle components, either the OUTERproduct of the data,  COVariance
%               matrix or CORRelation matrix. 
%								If omitted, 'COV' version is used as DEFAULT (CHANGED FROM 'OUTER' DEFAULT)
%
% OUTPUTS:
%   WEIGHTS    - A K by K matrix of componet weights or LOADINGS, where the ith row corresponds to the ith
%                principle component, ie. WEIGTHS(2,:) gives LOADINGS OF second PC.
%   PRINCOMP   - A T by K matrix of principal componets
%   EIGENVALS  - The eigenvalues associated with each PRINCOMP
%   EXPLVAR    - The percent of the viariance explained by each PRINCOMP
%   CUMR2      - The cumulative R2 of including the PRINCOMP 1,2,...,i
%
% COMMENTS:
%   When using the 'outer' version of PCA,
%      data = princomp*weights
%
%   When using the 'cov' version of PCA,
%      e = princomp*weights
%   where
%      e(:,i) = data(:,i) - mean(data(:,i))
%
%   When using the 'corr' version of PCA,
%      e = princomp*weights
%   where
%      e(:,i) = (data(:,i) - mean(data(:,i)))/std(data(:,i))

 % Author: Kevin Sheppard
% kevin.sheppard@economics.ox.ac.uk
% Revision: 3    Date: 2/1/2008
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Checking
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get data size
T=size(data,1);
 
if ndims(data)~=2
    error('DATA must be a T by K matrix')
end
 
switch nargin
    case 1
        pca_type=1;
    case 2
        switch lower(type)
            case ''				
                pca_type=2;		% this is the default value, changed to COV not OUTTER
            case 'outer'
                pca_type=1;
            case 'cov'
                pca_type=2;
            case 'corr'
                pca_type=3;
            otherwise
                error('TYPE must be either ''cov'' or ''corr''.')
        end
    otherwise
        error('Either 1 or 2 inputes required.')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Checking
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
% Compute the matrix depending on whether the outer, cov or corr is used
% used
switch pca_type
    case 1
        inputmat=data'*data/T;
    case 2
        % Demean the data
        data = data-repmat(mean(data),T,1);
        inputmat = cov(data,1);
    case 3
        % Demean the data
        data = data-repmat(mean(data),T,1);
        % Standardized the data
        stdevs = std(data);
        if any(stdevs==0)
            error('One or more of the colums of DATA has no variation, and the correlation-based method is not applicable.');
        end
        data = data./repmat(stdevs,T,1);
        inputmat=cov(data,1);
end
 
 
% Compute the eigenvalues and eigenvectors
[eigenvects,eigenvals]=eig(inputmat);
% Flip them since they come out ordered smallest to largest
eigenvals=fliplr(flipud(eigenvals));
% Weights are the eigen vectors
weights=eigenvects;
% Principle components are the data times the eigenvectors
princ_omp=data*eigenvects;
% Get the diagonal elements of the eigenvalue matrix
eigenvals=diag(eigenvals);
% Explained variance is the % of total eigenvalue sum
explvar=eigenvals/sum(eigenvals);
% Cumulative R2 is the amount less than or equal to the sum of the
% cumulative explained variance
cumR2=cumsum(explvar);
% transpose weights
weights=weights';
% Finally flip the princomp and weights so that the most important one
% comes first
weights=flipud(weights);
princ_omp=fliplr(princ_omp);