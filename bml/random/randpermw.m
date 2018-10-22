function v = randpermw(w, n, offset)
% Weighted randperm
%
% v = randpermw(w, n, offset)
%
% w: weight for each category. A vector of length k.
% n: number of samples
% offset: integer between 0 and k-1.
%
% See also: RANDPERM
%
% EXAMPLE:
% >> for ii = 1:3, sort(randpermw([1, 2, 3], 6, ii)), end
% ans =
%      1     2     2     3     3     3
% ans =
%      1     2     2     3     3     3
% ans =
%      1     2     2     3     3     3
%      
% >> for ii = 1:3, sort(randpermw([1, 2, 3], 7, ii)), end
% ans =
%      1     2     2     2     3     3     3 
% ans =
%      1     2     2     3     3     3     3
% ans =
%      1     1     2     2     3     3     3

% Yul Kang (c) 2018. yul dot kang dot on at gmail dot com.

assert(isvector(w));
siz = size(w);
w = w / sum(w);
k = length(w);

if nargin < 3
    offset = randi(k) - 1;
end
w = circshift(w, -offset); 
cw = cumsum(w);
cw = [0; cw(:)];

r = (randperm(n) - 1) / n;
v = zeros(siz);
for kk = 1:k
    v((r >= cw(kk)) & (r < cw(kk + 1))) = mod(kk - 1 - offset, k) + 1;
end

v = mod(v - offset - 1, k) + 1;
