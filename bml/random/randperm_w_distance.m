function [ix, id, i_attempt] = randperm_w_distance(id, min_dist, k)
% [ix, id, i_attempt] = randperm_w_distance(id, min_dist, k)
%
% id: vector of unique natural numbers from 1:numel(unique(id)).
% min_dist: scalar minimum distance. 1 allows the same contiguous ids.
% k: number of items to choose. See randperm.
%
% ix: permuted order.
% id: permuted ID.
% i_attempt: number of attempts made.
%
% See also: same_within, randperm
%
% 2018 (c) Yul Kang. yul dot kang dot on at gmail.

n_attempt = 100;

assert(isvector(id));
is_row = isrow(id);
if ~is_row
    id = id(:);
end

n_id = max(id);
n = numel(id);
if nargin < 3
    k = n;
end

assert(isscalar(min_dist));
assert(min_dist >= 1);
assert(n_id >= min_dist, 'n_id=%d must be >= min_dist=%d', ...
    n_id, min_dist);

ix0 = (1:n)';
ix = (1:n)';

i_attempt = 0;
succeeded = false;
while ~succeeded && i_attempt < n_attempt
    i_attempt = i_attempt + 1;
    succeeded = true;
    for ii = 1:k
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

ix = ix(1:k);
id = id(1:k);

if is_row
    ix = ix';
    id = id';
end

return;

%% Test
max_dist = 10;
for dist = 1:max_dist
    a = [1:max_dist, (max_dist-1):-1:1]'; 
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