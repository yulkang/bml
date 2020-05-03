function [id, ix, i_attempt] = randperm_w_distance(id, min_dist)
% [id, ix, i_attempt] = randperm_w_distance(id, min_dist)
%
% id: vector of unique natural numbers from 1:numel(unique(id)).
% min_dist: scalar minimum distance. 1 allows the same contiguous ids.
%
% id: permuted ID.
% ix: permuted order.
% i_attempt: number of attempts made.
%
% See also: same_within
%
% 2018 (c) Yul Kang. yul dot kang dot on at gmail.

[id, ix, i_attempt] = randperm_w_distance(id, min_dist);
