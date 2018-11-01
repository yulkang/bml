function tbl = add_rows(tbl, tbl2)
% tbl = add_rows(tbl, tbl2)
n1 = size(tbl, 1);
n2 = size(tbl, 2);

for col = tbl2.Properties.VariableNames(:)'
    col_width = size(tbl2.col, 2);
    tbl.(col{1})(n1 + (1:n2), 1:col_width) = tbl2.col;
end