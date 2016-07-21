function [dst, info] = copyprops(dst, src, varargin)
% [dst, info] = copyprops(dst, src, ...)
%
% src, dst : struct or an object
%
% info.handles.(prop) : handle properties, when skip_handle = true
%
% OPTIONS
% -------
% 'props', [] % Give names {'prop1', ...}, [] (all except skipped), or {} (none).
% 'props_to_skip', {}
% 'only_public', false % skip_internal and skip_protected
% 'skip_absent', true
% 'skip_dependent', true
% 'skip_transient', true
% 'skip_hidden', false
% 'skip_protected', false
% 'skip_error', true
% 'skip_handle', false
% 'skip_internal', false % skip properties with a name that end with '_'
% 'hide_error', false
%
% 2015 (c) Yul Kang. yul dot kang dot on at gmail.
S = varargin2S(varargin, {
    'props', [] % Give names {'prop1', ...}, [] (all except skipped), or {} (none).
    'props_to_skip', {}
    'only_public', false % skip_internal and skip_protected
    'skip_absent', true
    'skip_dependent', true
    'skip_transient', true
    'skip_hidden', false
    'skip_protected', false
    'skip_error', true
    'skip_handle', false
    'skip_internal', false % skip properties with a name that end with '_'
    'hide_error', false
    });
info = struct;

if S.only_public
    S.skip_internal = true;
    S.skip_protected = true;
end

if S.hide_error
    S.skip_error = true;
end

isstruct_src = isstruct(src);

props = S.props;
if isequal(props, [])
    if isstruct_src
        props = fieldnames(src);
    else
        mc = metaclass(src);
        props_list = mc.PropertyList;
        incl = true(numel(props_list), 1);

        if S.skip_dependent
            incl = incl & ~vVec([props_list.Dependent]);
        end
        if S.skip_transient
            incl = incl & ~vVec([props_list.Transient]);
        end
        if S.skip_hidden
            incl = incl & ~vVec([props_list.Hidden]);
        end
        props_list = props_list(incl);
        props = {props_list.Name};
        
        if S.skip_internal
            is_internal = cellfun(@(s) s(end) == '_', props);
            props = props(~is_internal);
        end
    end
end

props = setdiff(props, S.props_to_skip, 'stable');

assert(iscell(props));
assert(all(cellfun(@ischar, props(:))));

n = numel(props);
for ii = 1:n
    prop = props{ii};
    
    if S.skip_absent
        if isstruct_src
            if ~isfield(src, prop)
                continue;
            end
        else
            if ~isprop(src, prop)
                continue;
            end
        end
    end
    
    try
        v = src.(prop);
    catch
        if S.skip_protected
            continue;
        end
        try
            v = src.(['get_' prop]);
        catch err
            if S.skip_error
                if ~S.hide_error
                    warning(err_msg(err));
                end
            else
                rethrow(err);
            end
        end
    end
    
    if S.skip_handle && isa(v, 'handle')
        info.handles.(prop) = v;
        continue;
    end
    
    if isstruct(dst) ...
            || (isa(dst, 'dataset') && ismember(prop, dst.Properties.VarNames)) ...
            || (istable(dst) && ismember(prop, dst.Properties.VariableNames)) ...
            || isequal(isprop(dst, prop), true)
        try
            dst.(prop) = v;
        catch
            if S.skip_protected
                continue;
            end
            try
                dst.(['set_' prop])(v);
            catch err
                if S.skip_error
                    if ~S.hide_error
                        warning(err_msg(err));
                    end
                else
                    rethrow(err);
                end
            end
        end
    elseif ~S.skip_error
        error('Class %s does not have a proprty %s!\n', ...
            class(dst), prop);
    end
end