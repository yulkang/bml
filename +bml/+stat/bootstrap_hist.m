function hst = bootstrap_hist(hst0, varargin)
% Stratified bootstrap of a histogram within each condition.
%
% hst = bootstrap_hist(hst0, varargin)
%
% hst0(bin, condition)
% hst{boot}(bin, condition)

S = varargin2S(varargin, {
    'n_boot', 1e3
    'seed', []
    });

if ~isempty(S.seed)
    rng(S.seed);
end

cum_hst0 = cumsum(hst0);
n0 = cum_hst0(end,:);
ix0 = zeros(size(hst0));
n_cond = size(hst0, 2);

for i_cond = 1:n_cond
    cum_hst1 = cum_hst0(:,i_cond);
    for i0 = 1:n0
        ix0(i0, i_cond) = find(cum_hst1 >= i0, 1, 'first');
    end
end

hst = cell(S.n_boot, 1);
for i_boot = 1:S.n_boot
    for i_cond = n_cond:-1:1
        n1 = n0(i_cond);
        ix1 = max(ceil(rand(n1, 1) * n1), 1);
        hst1(:,i_cond) = ix0(ix1, i_cond)
    end
end