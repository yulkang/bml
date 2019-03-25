function tbl = cell2mat(tbl, varargin)
% apply cell2mat2() and/or char() to fields of a table.
%
% tbl = cell2mat(tbl, varargin)
%
% Operations are applied only to fields that are cell arrays.
% char() is applied if every row of the field is char or empty.
% cell2mat2() is applied if every row of the field is a vector
% of the same size.
% cell2mat2() is not applied with char(), unless enforced by use_cell2mat2.
% 
% OPTIONS: provide field names to enforce a certain operation.
% 'dont_change', {}
% 'use_char', {}
% 'use_cell2mat2', {}

S = varargin2S(varargin, {
    'dont_change', {}
    'use_cell2mat2', {}
    'use_char', {}
    });

for f = tbl.Properties.VariableNames(:)'
    if ismember(f{1}, S.dont_change) || ~iscell(tbl.(f{1}))
        continue;
    end
    
    if ismember(f{1}, S.use_char)
        to_char = true;
    else
        to_char = all( ...
            cellfun(@ischar, tbl.(f{1})) | cellfun(@isempty, tbl.(f{1})));
    end
    if ismember(f{1}, S.use_cell2mat2)
        to_cell2mat2 = true;
    elseif ~to_char
        to_cell2mat2 = all(cellfun(@isvector, tbl.(f{1})));
        if size(tbl, 1) > 0
            to_cell2mat2 = to_cell2mat2 ...
                && all(cellfun(@length, tbl.(f{1})) ...
                        == length(tbl.(f{1})(1)));
        end
    else
        to_cell2mat2 = false;
    end   
    
    if to_char
        tbl.(f{1}) = cellfun(@char, tbl.(f{1}), 'UniformOutput', false);        
    end
    if to_cell2mat2
        tbl.(f{1}) = cell2mat2(tbl.(f{1}));
    end
end
