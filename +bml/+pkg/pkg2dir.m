function pth = pkg2dir(pkg)
% pth = pkg2dir(pkg)
%
% 2015 (c) Yul Kang. hk2699 at columbia dot edu.

if isempty(pkg)
    pth = '';
else
    top_pkg = strsep(pkg, '.', 1);
    info_top = what(top_pkg);
    
    if isempty(info_top)
        error('pkg2dir:NOTFOUND', ...
            ['''%s'' is not found in the MATLAB path ' ...
               'or in the current directory!\n'], ...
            pkg);
    elseif ~isscalar(info_top)
        error('pkg2dir:NOTUNIQUE', ...
            '''%s'' is not unique!\n', pkg);
    end
    
    pth_rel = ['+', strrep(pkg, '.', [filesep, '+'])];
    
    pth = fullfile(fileparts(info_top.path), pth_rel);
end
