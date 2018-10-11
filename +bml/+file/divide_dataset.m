function files = divide_dataset(file, varargin)
% divide datasets into multiple files
%
% files = divide_dataset(file, varargin)
%
% OPTION:
% 'rows_per_file', 100

S = varargin2S(varargin, {
    'rows_per_file', 100
    });

L = load(file);
[pth, nam, ext] = fileparts(file);
assert(strcmp(ext, '.mat'));

name = fieldnames(L);
if ~isscalar(name)
    error('The file must contain a single variable!');
end
name = name{1};

v = L.(name);
n_row = size(v, 1);
n_file = ceil(n_row / S.rows_per_file);

% prefix with 0's
n_digit = length(sprintf('%1.0f', n_file));
fmt = ['%s_%0', sprintf('%1.0f', n_digit), 'd'];

files = cell(1, n_file);
for i_file = 1:n_file
    row_st = (i_file - 1) * S.rows_per_file + 1;
    row_en = min(i_file * S.rows_per_file, n_row);
    
    v1 = v(row_st:row_en, :);
    
    L1 = struct;
    L1.(name) = v1;
    
    nam1 = sprintf(fmt, nam, i_file);
    file1 = fullfile(pth, 'div', [nam1, ext]);
    mkdir2(fileparts(file1));
    save(file1, '-struct', 'L1');
    fprintf('Saved rows %d-%d to %s\n', row_st, row_en, file1);
end
fprintf('Finished saving %d rows to %d files.\n', n_row, n_file);