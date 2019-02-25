function log_p = logmvnpdf(x, mu, covmat)
% log(mvnpdf(x, mu, covmat)).
% x(i,j): i-th sample on j-th dimension.
% mu: row vector.
% covmat: square matrix.

n_dim = size(x, 2);
assert(isequal(size(mu), [1, n_dim]));
assert(isequal(size(covmat), [n_dim, n_dim]));

x = bsxfun(@minus, x, mu);
n = size(x, 1);
log_p = zeros(n, 1);
for ii = 1:n
    log_p(ii) = -(x(ii,:) / covmat * x(ii,:)') ./ 2;
end
log_p = log_p - (log(norm(covmat)) + n_dim * (2 * pi)) ./ 2;

% log_p = -(x * covmat * x') ./ 2 ...
%     - (log(norm(covmat)) + n_dim * (2 * pi)) ./ 2;
end