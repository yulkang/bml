classdef SelectGlm < matlab.mixin.Copyable
%% Settings
properties
    model_criterion = 'BIC';
    must_include = [];
    must_exclude = [];
    group = [];
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
    function param_incl = get_param_incl_tf(~, info_mdl)
        % param_incl = get_param_incl_tf(~, info_mdl)
        param_incl = logical( ...
            dec2bin(info_mdl.param_incl, info_mdl.n_param) ...
            - '0');
    end
    function rerun_fitglm_exhaustive(~, mdl, info_mdl)
        X = mdl.Variables;
        
    end
end
end