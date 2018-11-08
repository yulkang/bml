function tbl = set_rows(tbl, ix_rows, tbl1)
if islogical(ix_rows)
    ix_rows = find(ix_rows);
end
assert(numel(ix_rows) == size(tbl1, 1));
for ii = ix_rows(:)'
    for col = tbl1.Properties.VariableNames(:)'
        col_width = size(tbl1.(col{1}), 2);
        tbl.(col{1})(ii, 1:col_width) = tbl1.(col{1});
    end
end
end