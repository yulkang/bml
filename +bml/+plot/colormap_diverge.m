function cmap = colormap_diverge(n, colors)
% cmap = colormap_diverge(n, colors)
%
% n: positive integer
% colors: A matrix of 3 rows of [R, G, B] values.
%
% cmap: n x 3 matrix.

if nargin < 1 || isempty(n)
    n = 256;
else
    assert(isscalar(n));
    assert(n > 0);
end
if nargin < 2 || isempty(colors)
    colors = [
        0, 0, 1
        1, 1, 1
        1, 0, 0
        ];
else
    assert(ismatrix(colors));
    assert(isequal(size(colors), [3, 3]));
    assert(isnumeric(colors));
end

n_column = 3;
cmap = zeros(n, n_column);
xq = linspace(0, 1, n);
for ii = 1:n_column
    cmap(:, ii) = interp1([0, 0.5, 1]', colors(:,ii), xq);
end
