classdef Rsync < matlab.mixin.Copyable
    % 2016 YK wrote the initial version.
methods (Static)
    function rsync_file_list(op, list_file)
        if ~exist('list_file', 'var')
            list_file = 'file_list.txt';
        end
        
        Rsync = bml.file.Rsync;
        switch op
            case 'pull'
                Rsync.pull_file_list(list_file);
            case 'push'
                error('Not implemented yet!');
        end
    end
    function remote = get_remote_mirror(rel_pth0)
        match_pattern = [filesep 'CodeNData' filesep];
        
        abs_pth = fullfile(pwd, rel_pth0);
        ix = strfind(abs_pth, match_pattern);
        assert(~isempty(ix));
        ix = ix(1);
        
        rel_pth = abs_pth((ix + length(match_pattern) - 1):end);
        
        remote = fullfile('yul@pat.shadlenlab.columbia.edu:~/CodeNData', ...
            rel_pth);
    end
    function files = pull_file_list(list_file)
        if ~exist('list_file', 'var')
            list_file = 'file_list.txt';
        end
        
        Rsync = bml.file.Rsync;
        Rsync.pull_files_one_by_one(list_file);
        
        files = Rsync.get_list_from_file(list_file);
        Rsync.pull_files(files);
    end
    function pull_files_mirror(files, rel_pth, varargin)
        % pull_files_mirror(files, rel_pth, ...)
        
        if ~exist('rel_pth', 'var'), rel_pth = ''; end
        
        Rsync = bml.file.Rsync;
        
        src = Rsync.get_remote_mirror(rel_pth);
        if ~strcmpLast(src, filesep)
            src = [src, filesep];
        end
        
        list_file = Rsync.write_list_to_file(files);
        system_prudent(sprintf( ...
            'rsync -avz -e ssh %s --files-from="%s" %s ./', ...
            Rsync.get_exclude_from, list_file, src));
        
        delete(list_file);
        fprintf('Deleted the temporary file list %s\n', list_file);
    end
    function pull_files_one_by_one(files)
        % slow
        bml.file.rsync_files('pull', files); 
    end
end
%% Exclude list
methods (Static)
    function exc = get_exclude_from
        exc = '--exclude-from "/Users/yulkang/Dropbox/CodeNData/Code/Bash/rsync_exclude/default.txt"';
    end
end
%% File list
methods (Static)
    function list = get_list_from_file(list_file)
        if ~exist('list_file', 'var')
            list_file = 'file_list.txt';
        end
        
        fid = fopen(list_file, 'r');
        list = cell(1e5, 1);
        n = 0;
        while ~feof(fid)
            s = fgetl(fid);
            if isequal(s, -1)
                break;
            else
                n = n + 1;
                list{n} = s;
            end
        end
        list = list(1:n);
    end
    function list_file = write_list_to_file(files, list_file)
        if ~exist('list_file', 'var')
            list_file = ['file_list_', randStr, '.txt'];
        end
        
        n = numel(files);
        
        fid = fopen(list_file, 'w');
        for ii = 1:n
            fprintf(fid, '%s\n', files{ii});
        end
        fclose(fid);
        
        fprintf('-----\n');
        fprintf('First ~5 files:\n');
        fprintf('    %s\n', files{1:min(end, 5)});
        fprintf('\n');
        fprintf('Wrote the list of %d files to %s\n', n, list_file);
        fprintf('-----\n');
    end
    function [files, info] = get_file_list(filt)
        info = rdir(filt);
        files = {info.name};
    end
end
%% Manage rsync
methods (Static)
    function update_rsync(rsync_ver)
        % Refer to the rsync homepage for the most recent version:
        % https://rsync.samba.org/
        if ~exist('rsync_ver', 'var')
            rsync_ver = '3.1.2';
        end
        
        pd = pwd;
        
        cd('~/Desktop');
        system(sprintf( ...
            'curl -O http://rsync.samba.org/ftp/rsync/rsync-%s.tar.gz', ...
            rsync_ver));
        system(sprintf('tar -xzvf rsync-%s.tar.gz', ...
            rsync_ver));
        system(sprintf('rm rsync-%s.tar.gz', ...
            rsync_ver));
        
        cd(sprintf('~/Desktop/rsync-%s', rsync_ver));
        system('./prepare-source');
        system('./configure');
        system('make');
        system('sudo make install');
        system('sudo mv /usr/local/bin/rsync /usr/bin');
        
        cd(pd);
    end
end
end