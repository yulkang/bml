function file_out = combine_dataset(files_or_pth)
% Combine datasets or matrices vertically across files and save.
%
% files_or_pth: {'pth/file_001.mat', ...} or 'pth'
%
% file_out = combine_dataset(files_or_pth)

if ischar(files_or_pth)
    assert(exist(files_or_pth, 'dir') ~= 0);
    files = dirfiles(files_or_pth);
elseif iscell(files_or_pth)
    files = files_or_pth;
else
    error('Give a path to a folder or a cell array of file paths!');
end

[pth0, nam0, ext0] = fileparts(files{1});
pth1 = fileparts(pth0);
st_num = regexp(nam0, '_0*1$', 'once');
if ~isempty(st_num)
    nam1 = nam0(1:(st_num - 1));
    assert(~isempty(nam1));
else
    nam1 = nam0;
end

file_out = fullfile(pth1, [nam1, ext0]);

n_file = numel(files);
file1 = files{1};
L = load(file1);
name = fieldnames(L);
if ~isscalar(name)
    error('The file must contain a single variable!');
end
name = name{1};
v1 = L.(name);
n_row = 0;

n_row1 = size(v1, 1);
fprintf('Loaded %d rows (%d-%d) of %s from %s\n', ...
    n_row1, n_row + 1, n_row + n_row1, name, file1);
n_row = n_row + n_row1;

v = v1;

for i_file = 2:n_file
    file1 = files{i_file};
    L = load(file1);
    v1 = L.(name);
    
    n_row1 = size(v1, 1);
    fprintf('Loaded %d rows (%d-%d) of %s from %s\n', ...
        n_row1, n_row + 1, n_row + n_row1, name, file1);
    n_row = n_row + n_row1;
    
    v = [v
        v1];
end

L1 = struct;
L1.(name) = v;
save(file_out, '-struct', 'L1');
fprintf('Saved %d rows of %s to %s\n', size(v, 1), name, file_out);
end