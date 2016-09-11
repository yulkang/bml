function position_subplots(ax, varargin)
% position_subplots(ax, varargin)
%
% OPTIONS
% -------
% 'margin_left', 0.2   % If nonempty, overrides margin(1)
% 'margin_bottom', 0.2 % If nonempty, overrides margin(2)
% 'margin_right', 0.1  % If nonempty, overrides margin(3)
% 'margin_top', 0      % If nonempty, overrides margin(4)
% 'margin', [0.2, 0.2, 0.1, 0] % [left, bottom, right, top]
% 'btw_row', 0.05 % if vector, btw_row(1) is between rows 1 and 2.
% 'btw_col', 0.05 % if vector, btw_col(1) is between columns 1 and 2.

% 2016 Yul Kang. hk2699 at columbia dot edu.

S = varargin2S(varargin, {
    'margin_left', 0.15
    'margin_bottom', 0.15
    'margin_right', 0.05
    'margin_top', 0.1
    ... % margin: a four-vector of [left, bottom, right, top].
    ... % Its non-NaN elements override margin_*
    'margin', nan(1,4) 
    'btw_row', 0.05 % if vector, btw_row(1) is between rows 1 and 2.
    'btw_col', 0.05 % if vector, btw_col(1) is between columns 1 and 2.
    });
n_row = size(ax, 1);
n_col = size(ax, 2);

names = {'left', 'bottom', 'right', 'top'};
for ii = 1:numel(names)
    name = names{ii};
    v = S.(['margin_' name]);
    if isnan(S.margin(ii))
        S.margin(ii) = v;
    end
end

S.btw_row = bml.matrix.rep2fit(S.btw_row(:), [n_row - 1, 1]);
S.btw_col = bml.matrix.rep2fit(S.btw_col(:), [n_col - 1, 1]);


width = (1 - sum(S.margin([1, 3])) - sum(S.btw_col)) / n_col;
height = (1 - sum(S.margin([2, 4])) - sum(S.btw_row)) / n_row;

for i_row = 1:n_row
    for i_col = 1:n_col
        left = S.margin(1) ...
             + sum(S.btw_col(1:(i_col - 1))) ...
             + width * (i_col - 1);
        bottom = S.margin(2) ...
               + sum(S.btw_row(i_row:(n_row - 1))) ...
               + height * (n_row - i_row);
        
        set(ax(i_row, i_col), 'Position', [left, bottom, width, height]);
    end
end
end