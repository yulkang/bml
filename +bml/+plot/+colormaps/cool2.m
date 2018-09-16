function colors = cool2(n)
if nargin < 1
    n = 256;
end

colors = linspaceN([0.4, 0, 1], [1, 0, 0], n);