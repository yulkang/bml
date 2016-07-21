function h = children2struct(ax)
% Put line, text, and legend of an axes into a struct.
% Additionally finds markers (line with LineStyle = 'none'),
% segments (line with only two coordinates), 
% vertical and horizontal segments, 
% crosslines (line that spans at least one axis),
% and nonsegments.
%
% h = children2struct(h_src)
%
% h_src : handle of an axes or handles of its children.

% Yul Kang 2016. hk2699 at columbia dot edu.

if isscalar(ax) && strcmpi(get(ax, 'Type'), 'axes')
    h.axes = ax;
    h.children = get(ax, 'Children');
else
    h.axes = [];
    h.children = ax;
    if ~isempty(h.children)
        ax = get(h.children(1), 'Parent');
        h.axes = ax;
        assert(strcmpi(get(ax, 'Type'), 'axes'));
    end
end
for kind = {'line', 'text', 'legend'}
    if ismember(kind{1}, {'legend'})
        if ~isempty(ax)
            parent = get(ax(1), 'Parent');
        end
    else
        parent = ax;
    end

    h.(kind{1}) = findobj(parent, 'Type', kind{1});
end

% Find markers without line
h.marker = findobj(h.line, 'LineStyle', 'none');

% Find line segments (with only two coordinates)
for kind = {'segment', 'segment_vert', 'segment_horz', ...
        'crossline', 'nonsegment'}
    h.(kind{1}) = ghandles(0,0);
end

if ~isempty(ax)
    x_lim = xlim(ax);
    y_lim = ylim(ax);
end

for ii = 1:numel(h.line)
    line1 = h.line(ii);
    x = get(line1, 'XData');
    y = get(line1, 'YData');
    
    if numel(x) == 2
        h.segment(end+1,1) = line1;
        
        if ((x(1) == x_lim(1)) && (x(2) == x_lim(2))) ...
                || ((y(1) == y_lim(1)) && (y(2) == y_lim(2)))
            h.crossline(end+1,1) = line1;
        end
        if x(1) == x(2)
            h.segment_vert(end+1,1) = line1;
        end
        if y(1) == y(2)
            h.segment_horz(end+1,1) = line1;
        end
    elseif ~strcmpi(get(line1, 'LineStyle'), 'none')
        h.nonsegment(end+1,1) = line1;
    end
end
end