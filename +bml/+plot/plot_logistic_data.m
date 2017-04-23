function h = plot_logistic_data(x, ch, varargin)
% h = plot_logistic_data(x, ch, varargin)

assert(isvector(x));
assert(isvector(ch));

S = varargin2S(varargin, {
    'n_bin', min(9, numel(x))
    'plot_args', {}
    });
S.plot_args = varargin2plot(S.plot_args, {
    'o'
    });

incl = ~isnan(x) & ~isnan(ch);
x = x(incl);
ch = ch(incl);

[bin, ~, x_plot] = quantilize(x, S.n_bin);

n_all = accumarray(bin, 1, [S.n_bin, 1], @sum);
n_ch = accumarray(bin, ch, [S.n_bin, 1], @sum);

p_ch = n_ch ./ n_all;

h = plot(x_plot, p_ch, S.plot_args{:});
end