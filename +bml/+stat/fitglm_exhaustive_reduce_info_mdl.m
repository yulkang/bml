function info_mdl = fitglm_exhaustive_reduce_info_mdl(info_mdl)

if ~isnumeric(info_mdl.param_incl_all)
    info_mdl.n_param = size(info_mdl.param_incl_all, 2);
    info_mdl.param_incl_all = uint64(bin2dec(char(info_mdl.param_incl_all + '0')));
end
if ~isnumeric(info_mdl.param_incl)
    info_mdl.param_incl = uint64(bin2dec(char(info_mdl.param_incl + '0')));
end
if ~strcmp(info_mdl.model_criterion, 'crossval')
    info_mdl.ic_all_se = [];
    info_mdl.ic_all0 = {};
elseif ~isfield(info_mdl, 'save_ic_all0') || ~info_mdl.save_ic_all0
    info_mdl.ic_all0 = {};
end
end