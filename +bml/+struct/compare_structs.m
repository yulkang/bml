function ds_dif = compare_structs(S1, S2)
% ds_dif = compare_structs(S1, S2)
fs = union(fieldnames(S1), fieldnames(S2), 'stable');

n_dif = 0;
C_dif = {};
f_dif = {};

for f = fs(:)'
    if ~isfield(S1, f{1})
        n_dif = n_dif + 1;
        f_dif{n_dif, 1} = f{1};
        C_dif(n_dif, :) = {[], S2.(f{1})};
    elseif ~isfield(S2, f{1})
        n_dif = n_dif + 1;
        f_dif{n_dif, 1} = f{1};
        C_dif(n_dif, :) = {S1.(f{1}), []};
    elseif ~isequal(S1.(f{1}), S2.(f{1}))
        n_dif = n_dif + 1;
        f_dif{n_dif, 1} = f{1};
        C_dif(n_dif, :) = {S1.(f{1}); S2.(f{1})};
    end
end
ds_dif = bml.ds.cell2ds2([
        {'field', 'value1', 'value2'}
        f_dif(:), C_dif
    ], 'get_rowname', false, 'get_colname', true);
end