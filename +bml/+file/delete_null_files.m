function delete_null_files(pth)
% Delete files with zero size.
%
% delete_null_files(pth)

info = dir(pth);
is_null = ([info.bytes] == 0) & (~[info.isdir]);
info_null = info(is_null);
n_null = numel(info_null);
for ii = 1:n_null
    info1 = info_null(ii);
    file = fullfile(info1.folder, info1.name);
    delete(file);
    fprintf('Deleted %d/%d: %s\n', ii, n_null, file);
end