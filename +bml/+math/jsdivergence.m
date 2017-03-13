function [d, d_sep] = jsdivergence(p1, p2)
% Jensen-Shannon divergence between two distributions.
%
% [d, d_sep] = jsdivergence(p1, p2)

m = (p1 + p2) ./ 2;

d = (bml.math.kldivergence(p1, m) + bml.math.kldivergence(p2, m)) ./ 2;

if nargout >= 2
    [~, kl1] = bml.math.kldivergence(p1, m);
    [~, kl2] = bml.math.kldivergence(p2, m);
    d_sep = (kl1 + kl2) ./ 2;
end    
