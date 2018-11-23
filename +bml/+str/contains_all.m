function tf = contains_all(str, patterns)
% tf = contains_all(str, patterns)
% tf(ix) = true if str{ix} contains all patterns.
if ischar(str)
    str = {str};
else
    assert(iscell(str));
end

tf = true(size(str));
for pattern = patterns(:)'
    tf = tf & contains(str, pattern{1});
end