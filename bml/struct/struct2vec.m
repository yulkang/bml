function v = struct2vec(S, fields)
% v = struct2vec(S, [fields])
C = struct2cell(S);

if nargin < 2
    v = cell2mat(C);
    return;
elseif ~iscell(fields)
    assert(ischar(fields));
    fields = {fields};
else
    assert(iscell(fields));
    assert(all(cellfun(@ischar, fields(:))));
end
fields0 = fieldnames(fields);
incl = ismember(fields0, fields);
v = cell2mat(C(incl));