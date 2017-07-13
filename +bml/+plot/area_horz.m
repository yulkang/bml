function h = area_horz(y, x, varargin)
% h = area_horz(y, x, varargin)
%
% OPTIONS:
% 'baseline', 0
% 'patch_args', {}
% 'ax', gca
%
% patch_args:
% 'FaceAlpha', 0.3
% 'EdgeColor', 'none'

S = varargin2S(varargin, {
    'baseline', 0
    'patch_args', {}
    'ax', gca
    });
S.patch_args = varargin2C(S.patch_args, {
    'FaceAlpha', 0.3
    'EdgeColor', 'none'
    });
assert(isvector(y));
assert(isvector(x));
assert(length(x) == length(y));

y2 = [y(:); y(end); y(1)];
x2 = [x(:); S.baseline; S.baseline];

h = patch(S.ax, 'XData', x2, 'YData', y2, S.patch_args{:});