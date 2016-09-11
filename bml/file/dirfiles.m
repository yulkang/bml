function [f, n] = dirfiles(d)
% Full path to files (not folders) within the given folder.
%
% [F, N] = dirfiles(D)
%
% D: Path to a folder.
% F: Cell array of full paths.
% N: Cell array of file names.

if nargin < 1, d = pwd; end
info = dir(d);
if ~exist(d, 'dir')
    % extract path part
    d = fileparts(d);
end
n    = {info.name};
n    = n(~[info.isdir] & ~strcmps({'.DS_Store'}, n));
f    = fullfile(d, n(:));