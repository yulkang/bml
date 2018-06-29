function [b, res] = glmfit_lapse(X0, y0, varargin)
% [b, res] = glmfit_lapse(X0, y0, varargin)
%
% b(1) : offset
% b(1 + (1:size(X0,2))): beta
% b(end) : logit(p_lapse)
%
% X0 : design matrix (trial, regressor)
% y0 : logical column vector
%
% OPTIONS
% 'lapse0', logit(1e-3)
% 'lapse_min', logit(1e-5)
% ...
% ... 'lapse_max'
% ... if using logit(1 - 1e-5), consider fixing slope by
% ... setting slope0 = slope_min = slope_max
% 'lapse_max', logit(0.2) 
% 'bias0', 0
% 'bias_min', -1
% 'bias_max', 1
% 'slope0', 5
% 'slope_min', -5
% 'slope_max', 50
% 'opt', {}
    
% 2016 Yul Kang. hk2699 at columbia dot edu.

S = varargin2S(varargin, {
    'lapse0', logit(1e-3)
    'lapse_min', logit(1e-5)
    ...
    ... 'lapse_max'
    ... if using logit(1 - 1e-5), consider fixing slope by
    ... setting slope0 = slope_min = slope_max
    'lapse_max', logit(0.5) % logit(0.2) 
    'bias0', 0
    'bias_min', -1
    'bias_max', 1
    'slope0', 5
    'slope_min', -5
    'slope_max', 50
    'asym_lapse', false
    'opt', {}
    });

n_tr = size(X0, 1);
n_col = size(X0, 2);
assert(iscolumn(y0) && length(y0) == n_tr);

if S.asym_lapse
    b0 = [S.bias0, zeros(1, n_col) + S.slope0, S.lapse0 + [0, 0]];
    lb = [S.bias_min, zeros(1, n_col) + S.slope_min, S.lapse_min + [0, 0]];
    ub = [S.bias_max, zeros(1, n_col) + S.slope_max, S.lapse_max + [0, 0]];

    opt = optimoptions('fmincon', S.opt{:});

    f = @(b) -bml.stat.glmlik_lapse_asym(b, X0, y0);
%     disp(f(b0)); % DEBUG

    [b, fval, exitflag, output, lambda, grad, hessian] = ...
        FminconReduce.fmincon(f, ...
            b0, [], [], [], [], lb, ub, [], opt);

    se = sqrt(diag(inv(hessian)));
else
    b0 = [S.bias0, zeros(1, n_col) + S.slope0(:)', S.lapse0];
    lb = [S.bias_min, zeros(1, n_col) + S.slope_min(:)', S.lapse_min];
    ub = [S.bias_max, zeros(1, n_col) + S.slope_max(:)', S.lapse_max];

    opt = optimoptions('fmincon', S.opt{:});

    f = @(b) -bml.stat.glmlik_lapse(b, X0, y0);
%     disp(f(b0)); % DEBUG

    [b, fval, exitflag, output, lambda, grad, hessian] = ...
        FminconReduce.fmincon(f, ...
            b0, [], [], [], [], lb, ub, [], opt);

    se = sqrt(diag(inv(hessian)));
end
res = packStruct(b, se, fval, exitflag, output, lambda, grad, hessian);
