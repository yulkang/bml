function [h, y_bin, x, x_bin] = plot_binned_ch(x0, ch, varargin)
% [h, y_bin, x, x_bin] = plot_binned_ch(x0, ch, varargin)
S = varargin2S(varargin, {
    'n_bin', 9
    'plot_args', {};
    });
S.plot_args = varargin2plot(S.plot_args, {
    'o'
    });

incl = ~isnan(x0) & ~isnan(ch);
x0 = x0(incl);
ch = ch(incl);

[x_bin, ~, x] = quantilize(x0, S.n_bin);

y_bin = accumarray(x_bin, ch, [], @nanmean);
% try
    h = plot(x, y_bin, S.plot_args{:});
% catch
%     keyboard;
% end
end