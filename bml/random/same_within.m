function [dist_by_item, dist_by_id] = same_within(id)
% [dist_by_item, dist_by_id] = same_within(id)
%
% id: vector of unique natural numbers from 1:numel(unique(id)).
%
% dist_by_item(location): vector of the same size as id. Minimum distance to the
%                         same ID.
% dist_by_id(id): minimum distance for each unique ID.
%
% EXAMPLE:
% >> [dist_by_item, dist_by_id] = same_within([1, 2, 3, 2, 1])
% dist_by_item =
%      4     2   Inf     2     4
% dist_by_id =
%      4     2   Inf
%
% See also: randperm_w_distance
%
% 2018 (c) Yul Kang. yul dot kang dot on at gmail.

assert(isvector(id));
is_row = isrow(id);
[~, ~, ix] = unique(id);

n = numel(id);
dist_by_item = zeros(n, 1);

n_id = max(ix);
dist_by_id = zeros(n_id, 1);

idx = 1:numel(id);
for ii = 1:n_id
    idx1 = idx(ix == ii);
    if isempty(idx1) || isscalar(idx1)
        dist_by_id(ii) = inf;
        dist_by_item(idx1) = inf;
    else   
        dist1 = diff(idx1);
        dist_by_id(ii) = min(dist1);
        
        dist_by_item(idx1) = min([
            dist1(1), dist1(:)'
            dist1(:)', dist1(end)
            ], [], 1)';
    end
end

if is_row
    dist_by_item = dist_by_item';
    dist_by_id = dist_by_id';
end