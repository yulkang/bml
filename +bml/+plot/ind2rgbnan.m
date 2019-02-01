function rout = ind2rgbnan(a, cm, color_nan)
rout = ind2rgb(a, cm);

siz = size(a);
[nanrow, nancol] = find(isnan(a));
n_nan = numel(nanrow);
n_color = size(rout, 3);
assert(numel(color_nan) == n_color);
if n_nan > 0
    for color = 1:n_color
        ind = sub2ind([siz, n_color], ...
            nanrow, nancol, zeros(n_nan, 1) + color);
        rout(ind) = color_nan(color);
    end
end