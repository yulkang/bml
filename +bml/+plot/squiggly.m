function h = squiggly(x, y, varargin)
% h = squiggly(x, y, varargin)
%
% OPTION:
% 'x_shifts', 0:0.01:0.1

S = varargin2S(varargin, {
    'x_shifts', 0:0.01:0.1
    });

squigs = 0.95-[-.04, -.01, 0, -.01, -.04, -.05, -.04, -.01]*.7;
n_squigs = length(squigs);

for x_shift = S.x_shifts
    x_squig = squigs + x_shift;
    y_squig = linspace(-0.55, 0.55, n_squigs) + 0.01;
    plot(x * x_squig, y + y_squig, 'w-', 'LineWidth', 3);
end
