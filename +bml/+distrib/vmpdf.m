function p = vmpdf(x, m, k)
% p = vmpdf(x, m, k)

p = exp(k * cos(x - m)) ./ (2 .* pi .* besseli(0, k));