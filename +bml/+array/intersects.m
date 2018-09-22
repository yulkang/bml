function [c, ixs] = intersects(vs)
% [c, ixs] = intersects(vs)
% c = intersect(intersect(vs{1}, vs{2}), vs{3}), ...
% vs{ii}(ixs{ii}) == c

n = numel(vs);
c = vs{1};
for ii = 2:n
    c = intersect(c, vs{ii});
end

ixs = cell(1, n);
for ii = 1:n
    [~, ~, ixs{ii}] = intersect(c, vs{ii});
end