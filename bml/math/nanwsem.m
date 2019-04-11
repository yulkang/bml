function res = nanwsem(dat, weight, dim)
% weighted SEM ignoring NaNs.
%
% res = nanwsem(dat, weight, [dim])
%
% See also MEAN, STD, nanwmean

if nargin < 3 || isempty(dim)
    dim = 1;
end

[dat, weight] = rep2match({dat, weight});

mean_dat = nanwmean(dat, weight, dim);

weight(isnan(dat)) = 0;
dat(isnan(dat)) = 0;

n = sum(weight, dim);

res = sqrt( ...
        bsxfun(@rdivide, ...
            bsxfun(@rdivide, ...
                sum((dat - mean_dat) .^ 2 .* weight, dim), ...
                max(n - 1, 1) ...
            ), ...
            n ...
        ) ...
    );
