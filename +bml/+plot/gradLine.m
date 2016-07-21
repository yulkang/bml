function h = gradLine(x,y,c,varargin)
% Line with gradual change in color
%
% h = gradLine(x,y,c=[0 0 0],varargin)
%
% Options
% -------
% 'EdgeAlpha', 0.5

% 2015-2016 (c) Yul Kang. hk2699 at columbia dot edu.

if nargin < 3 || isempty(c)
    c = [0 0 0];
end

if ~isvector(x) && size(x, 2) > 1
    for ii = size(x, 2):-1:1
        h(ii) = bml.plot.gradLine(x(:,ii), y(:,ii), c, varargin{:});
        hold on;
    end
    hold off;
    return;
end

z = [(1:numel(x))'; NaN];

C = varargin2C(varargin, {
    'EdgeAlpha', 0.8
    });

if size(c,1) == 1 && size(c,2) == 3
    c = linspaceN(0.9+zeros(1,3), c, numel(x)+1); % ; nan(1,3)];
elseif size(c,1) == 2 && size(c,2) == 3
    c = linspaceN(c(1,:), c(2,:), numel(x)+1); % ; nan(1,3)];
end

h = patch([x(:);NaN],[y(:);NaN],z, 'CData', permute(c, [1 3 2]), ...
    'FaceColor','none','EdgeColor','interp', C{:});

view(2);