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

n_attempt = 100;

assert(isvector(id));
siz0 = size(id);
id = id(:);
% id0 = id;

n_id = max(id);
n = numel(id);

assert(isscalar(min_dist));
assert(min_dist >= 1);
assert(n_id >= min_dist);

ix0 = (1:n)';
ix = (1:n)';

i_attempt = 0;
succeeded = false;
while ~succeeded && i_attempt < n_attempt
    i_attempt = i_attempt + 1;
    succeeded = true;
    for ii = 1:n
        % Choose ids in the preceding min_dist elements.
        id_to_excl = unique(id(max(ii - min_dist + 1, 1):ii - 1))';
        
        % What indices can come to the current element.
        ix_incl = find((ix0 >= ii) & (~bsxEq(id, id_to_excl)));
        if isempty(ix_incl)
            succeeded = false;
%             disp('-');
            break;
        end
        ix1 = ix_incl(randi(numel(ix_incl)));
        
        % Swap index
        [ix(ii), ix(ix1)] = swap(ix(ii), ix(ix1));
        
        % Swap id
        [id(ii), id(ix1)] = swap(id(ii), id(ix1));
    end
end
if ~succeeded
    error(['%d attempts to permute with min_dist = %d failed! ' ...
           '(It may not be impossible though.)\n'], n_attempt, min_dist);
end

ix = reshape(ix, siz0);
id = reshape(id, siz0);

return;

%% Test
max_dist = 10;
for dist = 1:max_dist
    a = [1:max_dist, (max_dist-1):-1:1]; 
    fprintf('Dist: %d\n', dist);
    [id, ix, i_attempt] = randperm_w_distance(a, dist)
    assert(all(a(ix) == id), '~all(a(ix) == id)');
    if i_attempt > 1
        warning('i_attempt = %d\n', i_attempt);
    end
    
    [dist_by_item, dist_by_id] = same_within(id)
    disp(min(dist_by_id));
    assert(min(dist_by_id) >= dist, 'min(dist_by_id) < dist!');
end
disp('Passed all tests!');