function [files_dst, files_src] = rename_files(op, op_args, varargin)
% [files_dst, files_src] = rename_files(op, op_args, varargin)
%
% op, op_args
% -----------
% 'strrep', {src, dst}
% 'prefix', {prefix}
% 'postfix', {postfix} 
%
% OPTIONS:
% 'filt', '*.*'
% 'files', []
% 'confirm', true
%
% 2016 (c) Yul Kang. hk2699 at columbia dot edu.

S = varargin2S(varargin, {
    'filt', '*.*'
    'files', []
    'confirm', true
    });
if isequal(S.files, [])
    S.files = uigetfileCell(S.filt);
end
if isequal(S.files, {})
    files_src = {};
    files_dst = {};
    return;
end
n = numel(S.files);

files_src = S.files;
files_dst = cell(size(files_src));
for ii = 1:n
    [pth, nam0, ext] = fileparts(files_src{ii});
    
    switch op
        case 'strrep'
            nam1 = strrep(nam0, op_args{1}, op_args{2});
            
        case 'prefix'
            nam1 = [op_args{1}, nam0];
            
        case 'postfix'
            nam1 = [nam0, op_args{1}];
            
        otherwise
            error('Unknown op=%s\n', op);
    end
    
    files_dst{ii} = fullfile(pth, [nam1, ext]);
end

if S.confirm
    for ii = 1:n
        fprintf('%s => %s\n', files_src{ii}, files_dst{ii});
    end
    fprintf('%d files are selected.\n', n);
    if ~inputYN_def('Do you want to rename the files', true)
        files_dst = {};
        return;
    end
end

if n > 100
    fprintf('Renaming %d:\n', n);
end
for ii = 1:n
    if ~strcmp(files_src{ii}, files_dst{ii})
        movefile(files_src{ii}, files_dst{ii});
    end
    if mod(ii, 100) == 0
        fprintf(' %d', ii);
    end
    if mod(ii, 1000) == 0
        fprintf('\n');
    end
end
if n > 100
    fprintf('Done.\n');
end