function tbl = set_rows(tbl, ix_rows, tbl1)
if islogical(ix_rows)
    ix_rows = find(ix_rows);
end
assert(numel(ix_rows) == size(tbl1, 1));
if isstruct(tbl1)
    fs = fieldnames(tbl1);
else
    fs = tbl1.Properties.VariableNames;
end
for col = fs(:)'
    col_width = size(tbl1.(col{1}), 2);
    tbl.(col{1})(ix_rows, 1:col_width) = tbl1.(col{1});
%     for ii = sort(ix_rows(:)', 'descend')
%         col_width = size(tbl1.(col{1}), 2);
%         tbl.(col{1})(ii, 1:col_width) = tbl1.(col{1})(ii,:);
%     end
end
end