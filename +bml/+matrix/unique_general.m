function v = unique_general(v0)
% v = unique_general(v0)
%
% EXAMPLE:
% >> bml.matrix.unique_general({2, 1, 4, 'a', 'b', 'a', 4})
% ans = 
%     [2]    [1]    [4]    'a'    'b'
% 
% >> bml.matrix.unique_general([2 1 4 3 4 1])
% ans =
%      2     1     4     3
%
% Yul Kang. hk2699 at columbia dot edu.

if isempty(v0)
    if iscell(v0)
        v = {};
    else
        v = [];
    end
    return;
end

n = numel(v0);
% v = repmat(feval(class(v0)), size(v0));

is_unique = false(size(v0));
is_unique(n) = true;

for ii = n:-1:1
    is_unique1 = true;
    for jj = 1:(ii-1)
        if isequal(v0(jj), v0(ii))
            is_unique1 = false;
            break;
        end
    end
    is_unique(ii) = is_unique1;
end
v = v0(is_unique);
if all(is_unique(:))
    v = reshape(v, size(v0));
end


% v(1) = v0(1);
% n_unique = 1;
% for ii = 2:n
%     is_unique = true;
%     for jj = 1:n_unique
%         if isequal(v(jj), v0(ii))
%             is_unique = false;
%             break;
%         end
%     end
%     
%     if is_unique
%         n_unique = n_unique + 1;
%         v(n_unique) = v0(ii);
%     end
% end
% 
% v = v(1:n_unique);