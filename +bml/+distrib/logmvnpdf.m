function l = logmvnpdf(x, mu, sigma)
% l = logmvnpdf(x, mu, sigma)
%
% x: (n x d) matrix
% mu: (1 x d) vector
% sigma: (d x d) matrix
%
% l: (n x 1) vector
d = size(x, 2);
if nargin < 2
    mu = zeros(1, d);
end
if nargin < 3
    sigma = eye(d);
end

n = size(x, 1);
l = zeros(n, 1);
z = -log((2 * pi).^d * det(sigma)) / 2;
for ii = 1:size(x, 1)
    l(ii) = z - (x(ii,:) - mu) / sigma * (x(ii,:) - mu)' / 2;
end