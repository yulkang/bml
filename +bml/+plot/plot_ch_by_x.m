function h = plot_ch_by_x(x, ch, varargin)
% h = plot_ch_by_x(x, ch, varargin)

assert(isvector(x));
assert(isvector(ch));

incl = ~isnan(x) & ~isnan(ch);

x = x(incl);
ch = ch(incl);

ch(ch == 0) = -1;

[~, ix] = sort(x);

x_plot = x(ix);
ch_plot = cumsum(ch(ix));
h = stairs(x_plot, ch_plot, varargin{:});