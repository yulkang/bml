function v = cat_pad(c, dim_cat, dim_pad)
% concatenate cell into array on dim_cat after padding dim_pad with NaN
% v = cat_pad(c, dim_cat, dim_pad)

len_max = max(cellfun(@(v) size(v, dim_pad), c));
siz = size(c{1});
siz(dim_pad) = len_max;
for ii = 1:numel(c)
    siz1 = siz;
    siz1(dim_pad) = max(0, len_max - size(c{ii}, dim_pad));
    c{ii} = cat(dim_pad, c{ii}, nan(siz1));
end
v = cat(dim_cat, c{:});