function beautify(ax)
if ~exist('ax', 'var'), ax = gca; end

set(ax, 'Box', 'off', 'TickDir', 'out');
end