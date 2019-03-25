function v_py = var2py(v_matlab)

switch class(v_matlab)
    case 'table'
        v_py = bml.py.var2py(table2struct(v_matlab, 'ToScalar', true));
    case 'struct'
        if ~isscalar(v_matlab)
            v_py = bml.py.var2py(num2cell(v_matlab));
            return
        end
        % First convert values within the cell to python
        for f = fieldnames(v_matlab)'
            v_matlab.(f{1}) = bml.py.var2py(v_matlab.(f{1}));
        end
        v_py = py.dict(v_matlab);
        
    case 'cell'
        if ~isvector(v_matlab)
            assert(ismatrix(v_matlab), ...
                'Only 1D & 2D cell arrays are supported!');
            v_matlab = row2cell(v_matlab);
        end
        
        % First convert values within the cell to python
        v_matlab = cellfun(@bml.py.var2py, v_matlab, 'UniformOutput', false);
        try
            v_py = py.list(v_matlab(:)');
        catch err
            warning(err_msg(err));
        end
        
    case 'char'
        if isrow(v_matlab)
            v_py = py.str(v_matlab);
        else
            v_py = py.numpy.array(v_matlab);
        end
        
    otherwise
        v_py = py.numpy.array(v_matlab);        
end
end