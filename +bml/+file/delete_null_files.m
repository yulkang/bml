function delete_null_files(pth)
% Delete files with zero size.
%
% delete_null_files(pth)

if exist(pth, 'dir')
    pth0 = pth;
else
    pth0 = fileparts(pth);
    assert(exist(pth0, 'dir') ~= 0, 'Cannot parse the folder name!');
end
    
info = dir(pth);
is_null = ([info.bytes] == 0) & (~[info.isdir]);
info_null = info(is_null);
n_null = numel(info_null);
for ii = 1:n_null
    info1 = info_null(ii);
    if isfield(info1, 'folder')
        pth1 = info1;
    else
        pth1 = pth0;
    end
    file = fullfile(pth1, info1.name);
    delete(file);
    fprintf('Deleted %d/%d: %s\n', ii, n_null, file);
end

if n_null == 0
    fprintf('No null file was found at %s\n', pth);
end