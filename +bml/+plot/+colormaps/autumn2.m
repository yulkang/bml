function colors = autumn2(n)
if nargin < 1
    n = 256;
end

colors = linspaceN([0.5, 0.5, 0], [1, 0, 0], n);