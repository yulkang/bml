classdef MCMultiChainMvn < bml.stat.mcmc.MCMC
    % Multiple chains with multivariate normal proposal distribution.
    
%% Props - Settings - Required
properties 
    th0 = []; 
    
    mu_proposal = [];
    sigma_proposal = [];
    
    fun_nll_targ % function(th) % neg log likelihood
end
%% Props - Settings - Optional
properties
    n_MCs = 10;
    MC_class = 'MetroMvnAdaCov';
    MC_props = {}; % Properties
    MCs = {}; % MCMCs

    thres_convergence = 1.1; % As in Gelman et al., 2004
    
    lb = [];
    ub = [];
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    nonlcon = [];
    
    n_samp_max = 2e4;
    n_samp_burnin = 5e3;
    n_samp_per_check_convergence = 1e3; % after n_samp_burnin.

    parallel_mode = 'chain';
end
%% Props - Results
properties
    th0s = []; 
    th_samp = [];    
end
%% Props - Intermediate
properties
    fun_proposal % function(th_src, n) % gives th_mat
    fun_nll_proposal % function(th_src, th_dst) % gives p (column vec)    

    n_samp = 0;
    
    th_now = [];
    nll_now = [];
end
properties (Dependent)
    n_th
end

%% Main
methods
    function init(MC, varargin)
        bml.oop.varargin2props(MC, varargin, true);
        
        % Required inputs
        assert(~isempty(MC.th0));
        assert(~isempty(MC.sigma_proposal));

        MC.mu_proposal = zeros(1, MC.n_th);
        
        MC.fun_proposal = @(th_src, n) bsxfun(@plus, th_src, ...
            mvnrnd(MC.mu_proposal, MC.sigma_proposal, n));
        MC.fun_nll_proposal = @(th_src, th_dst) bml.stat.logmvnpdf( ...
            bsxfun(@minus, th_dst, th_src), MC.mu_proposal, MC.sigma_proposal);
        
        MC.th0s = bml.stat.mcmc.importance_resampling_mvn( ...
            MC.mu_proposal, MC.sigma_proposal, ... 
            @(th) -MC.fun_nll_proposal(MC.th0, th), ...
            'constr', {MC.lb, MC.ub, MC.A, MC.b, MC.Aeq, MC.beq, MC.nonlcon}, ...
            'n_initial_sample', MC.n_MCs * 200, ...
            'n_subsample', MC.n_MCs);
        
        switch MC.MC_class
            case 'MetroMvnAdaCov'
                for ii = 1:MC.n_MCs
                    C = varargin2C(MC.MC_props, {
                        'th0', MC.th0s(ii, :)
                        'mu_proposal', MC.mu_proposal
                        'sigma_proposal', MC.sigma_proposal
                        });
                    MC.MCs{ii} = bml.stat.mcmc.(MC.MC_class)(C{:});
                end
                
            otherwise % generic interface
                for ii = 1:MC.n_MCs
                    C = varargin2C(MC.MC_props, {
                        'fun_proposal', MC.fun_proposal
                        'fun_nll_proposal', MC.fun_nll_proposal
                        });
                    MC.MCs{ii} = bml.stat.mcmc.(MC.MC_class)(C{:});
                end
        end
    end
    function main(MC)
        tf_converged = false;
        while ~tf_converged && (MC.n_samp < MC.n_samp_max)
            tf_converged = MC.append;
        end
    end
    function tf_converged = append(MC, n_samp_to_append)
        n_samp_bef_append = MC.n_samp;
        if ~exist('n_samp_to_append', 'var')
            n_samp_min = MC.n_samp_burnin + MC.n_samp_per_check_convergence;
            if MC.n_samp < n_samp_min
                n_samp_to_append = n_samp_min - MC.n_samp;
            else
                n_samp_to_append = MC.n_samp_per_check_convergence;
            end
        end            
        
        MCs = MC.MCs;
        if strcmp(MC.parallel_mode, 'chain')
            parfor i_chain = 1:MC.n_MCs
                MCs{i_chain}.append(n_samp_to_append);
            end
        else
            for i_chain = 1:MC.n_MCs
                MCs{i_chain}.append(n_samp_to_append);
            end
        end
        
        n_samp_aft_append = MC.n_samp;
        tf_converged = MC.is_converged( ...
            (n_samp_bef_append + 1):n_samp_aft_append);
    end
    function tf_converged = is_converged(MC, ix_samp)
        if ~exist('ix_samp', 'var')
            ix_samp = max( ...
                MC.n_samp_burnin + 1, ...
                MC.n_samp - MC.n_sampper_check_convergence + 1):MC.n_samp;
        end
        if isempty(ix_samp)
            tf_converged = false;
            return;
        end
        
        n_samp_to_test = length(ix_samp);
        samp = zeros(n_samp_to_test, MC.n_th, MC.n_MCs);
        
        for i_chain = 1:MC.n_MCs
            samp(:,:,i_chain) = MC.MCs{i_chain}.samp(ix_samp, :);
        end
        
        tf_converged = all(bml.stat.mcmc.is_converged( ...
            samp, MC.thres_convergence));
    end
    function v = get.n_th(MC)
        v = length(MC.th0);
    end
end
end