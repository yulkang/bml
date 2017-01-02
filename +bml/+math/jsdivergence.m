function d = jsdivergence(p1, p2)
% Jensen-Shannon divergence between two distributions.
%
% d = jsdivergence(p1, p2)

m = (p1 + p2) ./ 2;
d = bml.math.kldivergence(p1, m) + bml.math.kldivergence(p2, m);