function y = get_traj_brownian(t)
% y = get_traj_brownian(t)
%
% t : sorted vector of time points with equal steps.
% y : Brownian bridge that starts from 0 and ends at 0.

assert(isvector(t));
n = length(t);
is_row = isrow(t);

t = t(:);

dt = t(2) - t(1);
T = t(end) - t(1);

dWt = randn([n - 1, 1]) * sqrt(dt);
Wt = cumsum(dWt);

y = [0
    Wt - (t(2:end) - t(1)) ./ T .* Wt];
if is_row
    y = y';
end
end
