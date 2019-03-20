function v = var4py(v)
% Convert variables to a format easier for python

switch class(v)
    case 'table'
        v = bml.py.var4py(table2struct(bml.tbl.cell2mat(v), ...
            'ToScalar', true));
    case 'struct'
        if ~isscalar(v)
            v = bml.py.var4py(num2cell(v));
            return
        end
        % Convert values within the cell for python
        for f = fieldnames(v)'
            v.(f{1}) = bml.py.var4py(v.(f{1}));
        end
        
    case 'cell'
        if ~isvector(v)
            assert(ismatrix(v), ...
                'Only 1D & 2D cell arrays are supported!');
            v = row2cell(v);
        end
        
        % Convert values within the cell for python
        v = cellfun(@bml.py.var4py, v, 'UniformOutput', false);
end
end