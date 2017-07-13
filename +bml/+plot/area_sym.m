function h = area_sym(x, y, varargin)
% h = area_sym(x, y, varargin)
%
% OPTIONS
% 'patch_args', {}

S = varargin2S(varargin, {
    'patch_args', {}
    'ax', gca
    });
S.patch_args = varargin2C(S.patch_args, {
    'FaceAlpha', 0.3
    'EdgeColor', 'none'
    });

assert(isvector(x));
assert(isvector(y));
assert(length(x) == length(y));
x2 = [x(:); flipud(x(:))];
y2 = [y(:); -flipud(y(:))];

h = patch(S.ax, 'XData', x2, 'YData', y2, S.patch_args{:});