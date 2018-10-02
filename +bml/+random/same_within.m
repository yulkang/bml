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

[dist_by_item, dist_by_id] = same_within(id);
