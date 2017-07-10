function [h_line, h_face] = box3d(xyz1, xyz2, opt_line, opt_face)
% [h_line, h_face] = box3d(xyz1, xyz2, opt_line, opt_face)

if nargin < 3
    opt_line = {};
end
opt_line = varargin2plot(opt_line, {
    });

if nargin < 4
    opt_face = {};
end
opt_face = varargin2C(opt_face, {
    'FaceColor', 'w'
    'FaceAlpha', 0.5
    'EdgeColor', 'none'
    });

x1 = xyz1(1);
y1 = xyz1(2);
z1 = xyz1(3);
x2 = xyz2(1);
y2 = xyz2(2);
z2 = xyz2(3);

lines = {
        [x1, y1, z1; x2, y1, z1]
        [x1, y1, z1; x1, y2, z1]
        [x1, y1, z1; x1, y1, z2]
        [x2, y2, z2; x1, y2, z2]
        ...
        [x2, y2, z2; x2, y1, z2]
        [x2, y2, z2; x2, y2, z1]
        [x1, y1, z2; x1, y2, z2]
        [x1, y1, z2; x2, y1, z2]
        ...
        [x2, y2, z1; x2, y1, z1]
        [x2, y2, z1; x1, y2, z1]
        [x1, y2, z1; x1, y2, z2]
        [x2, y1, z1; x2, y1, z2]
        };
for ii = numel(lines):-1:1
    l = lines{ii};
    h_line(ii) = plot3(l(:,1), l(:,2), l(:,3), opt_line{:});
    hold on;
end

faces = {
    [x1, y1, z1; x2, y1, z1; x2, y2, z1; x1, y2, z1]
    [x1, y1, z2; x2, y1, z2; x2, y2, z2; x1, y2, z2]
    [x1, y1, z1; x2, y1, z1; x2, y1, z2; x1, y1, z2]
    [x1, y2, z1; x2, y2, z1; x2, y2, z2; x1, y2, z2]
    [x1, y1, z1; x1, y1, z2; x1, y2, z2; x1, y2, z1]
    [x2, y1, z1; x2, y1, z2; x2, y2, z2; x2, y2, z1]
    };
for ii = numel(faces):-1:1
    f = faces{ii};
    h_face(ii) = patch( ...
        'XData', f([1:end,1],1), ...
        'YData', f([1:end,1],2), ...
        'ZData', f([1:end,1],3), ...
        opt_face{:});
end