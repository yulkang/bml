function [h_bar, h_err, h_txt] = bar_err(est, le, ue, varargin)
% [h_bar, h_err, h_txt] = bar_err(est, le, ue, varargin)
% [h_bar, h_err, h_txt] = bar_err(est, err, [], varargin)
%
% OPTIONS:
% 'barwidth', 0.8
% 'color', [0 0 0] % 1x3 or n_bar x 3 matrix
% 'style', 'solid' % 'solid'|'frame'
% 'ax', gca
% 'print', false
% 'datatip', false % If true, display "est+-err" below the bar tip.
% 'sigstr', {} % String for significance. If nonempty, put above the bar tip.

% 2017 (c) Yul Kang. hk2699 at columbia dot edu.

S = varargin2S(varargin, {
    'barwidth', 0.8
    'color', [0 0 0] % 1x3 or n_bar x 3 matrix
    'style', 'solid' % 'solid'|'frame'
    'ax', gca
    'print', false
    'datatip', false % If true, display "est+-err" below the bar tip.
    'sigstr', {} % String for significance. If nonempty, put above the bar tip.
    });

if nargin < 3 || isempty(ue)
    ue = le;
    le = -le;
    err = ue;
    is_err = true;
else
%     le = bsxfun(@minus, lb, est);
%     ue = bsxfun(@minus, ub, est);
    is_err = false;
end
n_bar = numel(est);

ax = S.ax;

if S.print
    if is_err
        fprintf('mean:');
        disp(est);
        fprintf('err:');
        disp(err);
    else
        fprintf('mean:');
        disp(est);
        fprintf('le:');
        disp(le);
        fprintf('ue:');
        disp(ue);
    end
end

if size(S.color, 1) == 1
    S.color = repmat(S.color, [n_bar, 1]);
end

h_bar = gobjects(1, n_bar);
h_err = gobjects(1, n_bar);
h_txt = gobjects(1, n_bar);
for i_bar = 1:n_bar
    color = S.color(i_bar, :);
    switch S.style
        case 'frame'
            h_bar(i_bar) = bar(ax, i_bar, est(i_bar), S.barwidth, ...
                'FaceColor', 'none', ...
                'EdgeColor', color, ...
                'LineStyle', '-', ...
                'LineWidth', 2);
        case 'solid'
            h_bar(i_bar) = bar(ax, i_bar, est(i_bar), S.barwidth, ...
                'FaceColor', color, ...
                'LineStyle', 'none');
    end
    hold(ax, 'on');
    [~, h_err(i_bar)] = errorbar_wo_tick( ...
        i_bar, est(i_bar), le(i_bar), ue(i_bar), ...
        {'Marker', 'none'}, {'LineWidth', 2, 'Color', color}, ...
        'ax', ax);
    hold(ax, 'on');

    if S.datatip
        if is_err
            h_txt(i_bar) = text(ax, i_bar, est(i_bar), ...
                sprintf('%1.0f\\pm%1.0f', ...
                    est(i_bar), err(i_bar)), ...
                'Color', 'w', ...
                'FontSize', 9, ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'top', ...
                'Interpreter', 'tex');
        else
            error('Datatip is not supported yet for the le-ue format!');
        end
    end
    
    if ~isempty(S.sigstr)
        h_txt(i_bar) = text(ax, i_bar, est(i_bar) + ue(i_bar), ...
            S.sigstr{i_bar}, ...
            'FontSize', 9, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom');
    end
end
hold(ax, 'off');

xlim(ax, [0.25, n_bar + 0.75]); 
%             xlabel('Kind');
% bml.plot.beautify;
end