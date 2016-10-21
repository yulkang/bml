function info_mdl = fitglm_exhaustive_reduce_info_mdl(info_mdl)

if ~iscolumn(info_mdl.param_incl)
    info_mdl.param_incl = bin2dec(char(info_mdl.param_incl + '0'));
end
if ~strcmp(info_mdl.model_criterion, 'crossval')
    info_mdl.ic_all_se = [];
    info_mdl.ic_all0 = {};
end
end