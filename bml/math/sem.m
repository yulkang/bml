function res = sem(dat, dim, nanBelow)
% SEM   Standard error of mean.
%
% res = sem(dat, dim, nanBelow)
%
% See also MEAN, STD

dim_given = nargin >= 2;
if ~dim_given || isempty(dim), dim = 1; end
if ~exist('nanBelow', 'var'), nanBelow = 0; end

if (numel(dat) == length(dat)) && ~dim_given % vector
    res = std(dat) ./ sqrt(length(dat));
else
    res = std(dat, 0, dim) / sqrt(size(dat, dim));
    
    toNan = size(dat, dim) <= nanBelow;
    
    res(toNan) = nan;
end