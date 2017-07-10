function traj = get_traj_unabsorbed(t, drift, bound, y0, y_end, y)
% y = get_traj_unabsorbed(t, drift, bound, y0, y_end, [y])
%
% t: time vector
% bound(t,ch) or bound(1,ch) : absorbing boundaries (ch = 1 or 2)
% y0: y at t(1)
% y_end: y at t(end)
% y: vector of y locations.
% unabs(y, t): P(Y_t = y, R_t > t) where R_t is the first crossing time.
%
% y: diffusion path that is unabsorbed between t(1) and t(end).
%    Currently, ignoring special treatment for t(end),
%    where P(Y_t-dt = y' | Y_t = y) should be summed over y > b(t).
%    Use only for rough illustrations!

assert(isvector(t));
t = t(:);
dt = t(2) - t(1);
nt = length(t);
% prop = t ./ t(end);
% y_shift = y0 + (y_end - y0) .* prop;

assert(size(bound, 2) == 2);
if size(bound, 1) == 1
    bound = bsxfun(@plus, zeros(nt, 1), bound);
else
    assert(size(bound, 1) == nt);
end

if ~exist('y', 'var')
    max_y = max(abs(bound(:)));
    y = linspace(-max_y * 3, max_y * 3, 256)';
end
assert(isvector(y));
y = y(:);
ny = length(y);
dy = y(2) - y(1);

% bound = bsxfun(@minus, bound, y_shift);
mu = drift * dt;
sig = sqrt(dt);

[~,ix_y_end] = min(abs(y_end - y));
[~,ix_y0] = min(abs(y0 - y));

p0 = zeros(ny, 1);
p0(ix_y0) = 1;
D = dtb.pred.spectral_dtbAA(drift, t, bound(:,2), bound(:,1), y, p0, true);
unabs = permute(D.notabs.pdf, [2, 3, 1]);
unabs = bsxfun(@rdivide, unabs, sum(unabs, 1));
% y1 = y_end;

traj = zeros(nt, 1);
traj(nt) = y_end;

%%
if y_end > bound(end, 2) - dy
    p_y_bef_given_y = zeros(ny, 1);
    for iy = ix_y_end:ny
        y11 = y(iy);
        p_y_bef_given_y = p_y_bef_given_y + normpdf(y - y11, -mu, sig);
    end
    
elseif y_end < bound(end, 1) + dy
    p_y_bef_given_y = zeros(ny, 1);
    for iy = 1:ix_y_end
        y11 = y(iy);
        p_y_bef_given_y = p_y_bef_given_y + normpdf(y - y11, -mu, sig);
    end
else
    p_y_bef_given_y = normpdf(y - y_end, -mu, sig);
end
p_y_posterior = p_y_bef_given_y .* unabs(:,nt - 1);
y1 = randsample(y, 1, true, p_y_posterior);
traj(nt-1) = y1;

%%
for it = (nt-1):-1:2
    p_y_bef_given_y = normpdf(y - y1, -mu, sig);
    p_y_posterior = p_y_bef_given_y .* unabs(:,it-1);
    
    y1 = randsample(y, 1, true, p_y_posterior);
    traj(it-1) = y1;
end
traj(1) = y0;