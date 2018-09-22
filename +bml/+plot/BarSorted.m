classdef BarSorted < matlab.mixin.Copyable
properties
    y0
    y
    
    bar_args = {'BarWidth', 1, 'EdgeColor', 'none', 'FaceColor', 'k'};
    sort_args = {'descend'};
end
properties
    h_bar
end
properties (Dependent)
    n
end
methods
    function Bar = BarSorted(y, bar_args, sort_args)
        if nargin < 1
            y = [];
        end
        if nargin < 2
            bar_args = {};
        end
        if nargin < 3
            sort_args = Bar.sort_args;
        end
        
        Bar.y0 = y;
        Bar.bar_args = varargin2C(bar_args, Bar.bar_args);
        Bar.sort_args = sort_args;
        
        Bar.y = sort(y, Bar.sort_args{:});
        Bar.h_bar = bar(Bar.y, Bar.bar_args{:});
        
        x = 1:Bar.n;
        xlim([0.5 - (Bar.n * 0.01), Bar.n + 0.5]); % + Bar.n * 0.01]);
    end
    function h = bar_focal(Bar, y_focal, bar_args)
        y_focal = sort(y_focal, Bar.sort_args{:});
        bar_args = varargin2C(bar_args, Bar.bar_args);
        
        [~, ix] = ismember(y_focal, Bar.y);
        if isscalar(y_focal) && ~isscalar(ix)
            y_focal = y_focal + zeros(size(ix));
        end
        
        hold on;
        h = bar(ix, y_focal, bar_args{:});
        hold off;
    end
    function h = horzline_focal(~, y_focal, line_args)
        if nargin < 3
            line_args = {};
        end
        h = bml.plot.crossLine('h', y_focal, line_args);
    end
    function relabel_y(Bar, y_baseline)
    end
end
%% Internal
methods
    function v = get.n(Bar)
        v = numel(Bar.y);
    end
end
end
