function tbl = struct2row(tbl, row, S)
% Copy each field of S to the corresponding column of tbl at row.
% All columns should be a cell column vector. 
%
% struct2row(tbl, row, S)
for f = fieldnames(S)'
    tbl.(f{1}){row,1} = S.(f{1});
end
end