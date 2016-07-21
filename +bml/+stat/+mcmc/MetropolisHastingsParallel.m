classdef MetropolisHastingsParallel < DeepCopyable
    % Implements Calderhead 2014.
    
properties (Dependent)
    n_proposal1 % n_proposal + 1
end
%% Main
methods
    function MH = MetropolisHastingsParallel( ...
            fun_nll_targ, fun_proposal, fun_p_proposal, th0)
        if nargin > 0
            MH.fun_nll_targ = fun_nll_targ;
            MH.fun_proposal = fun_proposal;
            MH.fun_p_proposal = fun_p_proposal;
            MH.th_now = th0;
            
            nll0 = MH.get_nll_targ(th0);
            
            MH.reset_samp;
            MH.add_samp(th_now, nll0);
        end
    end
    function main(MH)
        MH.mcmc_iso_normrnd;
    end
end
%% MCMC - init, sample, and transition, until convergence.
methods
    function mcmc_iso_normrnd(MH)
        [th0, cov_mat] = MH.init_iso_sd_typical_scale;
        th0_prev = nan(size(th0));
        
        for i_samp = 1:MH.n_samp_max
            if MH.verbose
                fprintf('-----\n');
                fprintf('Step %d\n', i_samp);
            end
            
            if ~all(th0_prev == th0)
            	[nll, th_mat_free] = MH.propose_mvnrnd(th0, cov_mat, ...
                	'n_proposal', 1);
            end
            
            th0_prev = th0;
            th0 = MH.transition(nll, th_mat_free);
        end
    end
end
%% Target & Proposal distributiosn
methods
    function nll = get_nll_targ(MH, th)
        n = size(th, 1);
        nll = zeros(n, 1);
        for ii = 1:n
            nll(ii,1) = MH.fun_nll_targ(th(ii,:));
        end
    end
    function th_proposal = get_proposal(MH, th0, n_proposal)
        if nargin(MH.fun_proposal) == 1
            n_th = size(th0, 2);
            th_proposal = zeros(n_proposal, n_th);
            for ii = 1:n_proposal
                th_proposal(ii, :) = MH.fun_proposal(th0);
            end
        else
            th_proposal = MH.fun_proposal(th0, n);
        end
    end
    function p = get_p_proposal(MH, th0, th_proposal)
        p = MH.fun_p_proposal(th0, th_proposal);
    end
end
%% Transition
methods
    function [th_new, nll_new] = transition(MH, ...
            nll_proposal, th_proposal, varargin)
        % [th_vec_new, nll_new] = transition(MH, nll1, th_mat_proposal)
        
        assert(isscalar(nll_proposal), 'Only can handle scalar for now!');
        
        S = varargin2S(varargin, {
            'nll_old', MH.nll_now
            'th_old', MH.th_now
            });
        
        nll_proposal1 = [S.nll_old; nll_proposal];
        th_proposal1 = [S.th_old; th_proposal];
        
        p_acceptance = MH.get_p_acceptance([S.nll_old; nll_proposal1(:)]);
        ix_new = randsample(1:(n_proposal + 1), 1, true, p_acceptance);
        
        nll_new = nll_proposal1(ix_new);
        th_new = th_proposal1(ix_new, :);
        
        MH.nll_now = nll_new;
        MH.th_now = th_new;

        MH.add_samp(th_new, nll_new);
    end
    function p = get_p_acceptance(~, nll_proposal)
        % Symmetric case: R(i,j) = pi(x_j) / pi(x_i)
        log_r = bsxfun(@minus, nll_proposal(:), nll_proposal(:)');
        r = exp(log_r);
        
        n = length(nll_proposal);
        p_all = min(r - diag(r), 1) ./ n;
        p_all = p_all + diag(1 - sum(p_all, 2));
        p = sum(p_all, 1);
    end
end
%% Utilities
methods
    function v = get.n_proposal1(MH)
        v = MH.n_proposal + 1;
    end
end
%% Demo
methods
    function demo(MH)
        file = 'Data/Fit.D2.RT.Inh.MainBatch/sbj=DX+prd=RT+dtb=DnIvJt+dft=Const+bnd=Const+ssq=Const+tnd=gamma+kb=0+p1=50+d1=0+d2=0+s1=16+s2=16+fn1=50+fn2=50+ntnd=4+pf=0+d1f=0+d2f=0+db1f=0+db2f=0+s1f=0+s2f=0+bif1=0+baif1=0+bif2=0+baif2=0+fn1f=1+fn2f=1+msf=0+cv=1+ncv=2+ist=0.mat';
        L = load(file);
        Fl = L.Fl;
        Fl.W.Dtb.DEBUG_THRES = 1e-4;

        %%
        MH.Fl = Fl;
        
        %%
        MH.main;
        
        disp('-----');
        disp('nll_samp:');
        disp(MH.nll_samp);
    end
end
end