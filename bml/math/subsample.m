function res = subsample(v, fac, dim)
% subsample  subsample V by FAC along DIM.
%
% res = subsample(v, fac, [dim=1])

if nargin >= 3
    perm = [dim, setdiff(1:ndims(v), dim)];
    
    v = permute(v, perm);
end

siz = size(v);
siz(1) = siz(1) / fac;

if floor(siz(1)) < siz(1)
    siz(1) = floor(siz(1));
    v = reshape(v(1:(siz(1)*fac),:), [fac, siz]);
else
    v = reshape(v, [fac, siz]);
end

res = reshape(mean_rows(v, 1), siz);

if nargin >= 3
    res = ipermute(res, perm);
end