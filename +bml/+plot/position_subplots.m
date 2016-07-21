function position_subplots(ax, varargin)
% position_subplots(ax, varargin)
%
% OPTIONS
% -------
% 'margin_out', [0.2, 0.2, 0.1, 0] % [bottom, left, top, right]
% 'margin_in', [0.05, 0.05] % [between_rows, between_columns]

% 2016 Yul Kang. hk2699 at columbia dot edu.

S = varargin2S(varargin, {
    'margin', [0.1, 0.125, 0.025, 0.075] % [left, bottom, right, top]
    'btw_row', 0.05
    'btw_col', 0.05
    });
n_row = size(ax, 1);
n_col = size(ax, 2);

width = (1 - sum(S.margin([1, 3])) - S.btw_col * (n_col - 1)) / n_col;
height = (1 - sum(S.margin([2, 4])) - S.btw_row * (n_row - 1)) / n_row;

for i_row = 1:n_row
    for i_col = 1:n_col
        left = S.margin(1) + (S.btw_col + width) * (i_col - 1);
        bottom = S.margin(2) + (S.btw_row + height) * (n_row - i_row);
        
        set(ax(i_row, i_col), 'Position', [left, bottom, width, height]);
    end
end
end