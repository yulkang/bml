function res = nanind(v, ind)
% Same as v(ind) except it is NaN where ind is NaN
%
% res = nanind(v, ind)
%
% res(~isnan(ind)) = v(ind(~isnan(ind)));
% res(isnan(ind)) = nan;

res = nan(size(ind));
is_ind = ~isnan(ind);
res(is_ind) = v(ind(is_ind));

