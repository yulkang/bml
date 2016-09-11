function x = interpolate(x1, x2, prop)
% x = interpolate(x1, x2, prop)
%
% x1, x2: Numerical arrays of the same size.
% prop  : A scalar. A number between 0-1 produces interpolation.
%
% x     : Linearly inter(extra)polated numerical array.

x = (x2 - x1) .* prop + x1;
end