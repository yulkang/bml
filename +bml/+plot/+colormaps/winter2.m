function colors = winter2(n)
if nargin < 1
    n = 256;
end

colors = linspaceN([0, 0.4, 1], [0, 0.8, 0.25], n);