function x = normrnd_trunc(sigma, range)
% x = normrnd_trunc(sigma, range)

range = range ./ abs(double(sigma));
lb = range(1);
ub = range(2);
r = rand * (ub - lb) + lb;
x = norminv(r, 0, 1);