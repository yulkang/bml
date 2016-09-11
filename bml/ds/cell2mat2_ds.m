function ds = cell2mat2_ds(ds, cols)
% ds = cell2mat2_ds(ds, [cols])

if nargin < 2 || isempty(cols)
    cols = ds.Properties.VarNames;
end
for col = cols(:)'
    ds.(col{1}) = cell2mat2(ds.(col{1}));
end