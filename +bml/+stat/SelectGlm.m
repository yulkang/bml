classdef SelectGlm < DeepCopyable
%% Settings
properties
    glm_args = {'Distribution', 'binomial'};
    model_criterion = 'BIC';
    must_include = [];
    must_exclude = [];
    group = [];
    crossval_args = {};
    UseParallel = 'auto';
    verbose = 1;
    return_mdls = false;
    var_names = {};
    n_param = 0;
end
%% Results
properties
    mdl
    param_incl_all
    param_incl
    ic_all
    ic_all0 = {};
    ic_all_se
    ic_min
    ic_min_ix
    mdls = {};
end
%% Methods
methods
    function Glm = SelectGlm(varargin)
        if nargin > 0
            Glm.init(varargin{:});
        end
    end
    function init(Glm, varargin)
        varargin2props(Glm, varargin, true);        
    end
    function import_L(Glm, L)
        % L: a struct with mdl and info_mdl as fields.
        C = varargin2C(L.info_mdl);
        Glm.init(C{:});
        Glm.mdl = L.mdl;
        if isfield(L, 'mdls')
            Glm.mdls = L.mdls;
        end
    end
    function param_incl = get_param_incl_tf(Glm, param_incl)
        % param_incl = get_param_incl_tf(~, info_mdl)
        if nargin < 2
            param_incl = Glm.param_incl;
        end
        param_incl = logical( ...
            dec2bin(param_incl, Glm.n_param) ...
            - '0');
    end
    function Glm = rerun_fitglm_exhaustive_w_selected_param_incl(Glm0, ...
            varargin)
        X = Glm0.mdl.Variables;
        y = Glm0.mdl.ResponseName;
        param_incl = Glm0.get_param_incl_tf;
        must_include = find(param_incl);
        must_exclude = find(~param_incl);
        
        Glm = Glm0.deep_copy;
        Glm.init(varargin{:});
        Glm.fit(X, y, {
            'must_include', must_include
            'must_exclude', must_exclude
            });
    end
    function fit(Glm, X, y, varargin)
        C = varargin2C(varargin2C(varargin, {
                    'UseParallel', 'never'
                }), ...
                copyprops(struct, Glm, 'props', {
                    'model_criterion'
                    'must_include'
                    'must_exclude'
                    'group'
                    'crossval_args'
                    'UseParallel'
                    'verbose'
                    'return_mdls'
                    'var_names'
                    'n_param'
                    }));
        [mdl, info, mdls] = fitglm_exhaustive(X, y, Glm.glm_args, C{:});
        copyprops(Glm, info, true);
        Glm.mdl = mdl;
        Glm.mdls = mdls;
    end
end
end