function r2 = r2_wo_regr(v_orig, v_fit)
% r2 = r2_wo_regr(v_orig, v_fit)
%
% Similar to R^2 but without regression.

assert(isvector(v_orig));
assert(isequal(size(v_orig), size(v_fit)));

v_orig_mean = mean(v_orig);

r2 = mean((v_fit - v_orig).^2) ./ mean((v_orig - v_orig_mean) .^ 2);
