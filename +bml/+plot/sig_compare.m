function [h_line, h_txt] = sig_compare(x, y, sig_str, varargin)
% [h_line, h_txt] = sig_compare(x, y, sig_str, varargin)
%
% OPTION
% ------
% 'ax', gca

S = varargin2S(varargin, {
    'ax', gca
    'y_txt_offset', 0
    });

if isvector(x)
    assert(numel(x) == 2);
    assert(isscalar(y));
    x = hVec(x);
    y = [0 0] + y;
else
    error('Unsupported format!');
end

hold(S.ax, 'on');
h_line = plot(S.ax, x, y, 'k-');
h_txt = text(S.ax, mean(x), y(1) + S.y_txt_offset, sig_str, ...
    'FontSize', 9, ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom');
hold(S.ax, 'off');
end