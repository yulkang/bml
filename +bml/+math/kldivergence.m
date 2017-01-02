function d = kldivergence(p1, p2)
% If multidimensional, works on the first dimension. Uses log2().
%
% d = kldivergence(p1, p2)
% : computes D_KL(p1 || p2)

assert(isequal(size(p1), size(p2)));

d = nansum(p1 .* (log2(p1) - log2(p2)));
