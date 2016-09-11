function lim = beautify_lim(varargin)
% lim = beautify_lim(varargin)
%
% 'xy', 'y'
% 'ax', gca
% 'margin', 0.05

% 2016 Yul Kang. hk2699 at columbia dot edu.

S = varargin2S(varargin, {
    'xy', 'y'
    'ax', gca
    'margin', 0.1
    });

xy = bml.plot.get_all_xy(S.ax);
coord = xy(:, lower(S.xy) == 'xy');
coord = coord(isfinite(coord));

max_lim = max(coord);
min_lim = min(coord);
range_lim = max_lim - min_lim;
lim = [max_lim - range_lim * (1 + S.margin), ...
       min_lim + range_lim * (1 + S.margin)];

name = [upper(S.xy), 'Lim'];
if lim(1) < lim(2)
    set(S.ax, name, lim);
end
end
