classdef MetropolisHastingsAdaCov < bml.stat.mcmc.MetropolisHastings
    % Metropolis-Hastings sampling with adaptive proposal covariance.
    
%% For AdaCov
properties
    n_samp_bef_cov_update = 200;
    n_samp_btw_cov_update = 40;
    n_samp_cov_update_max = 1000; % was 200 for 2D
    
    cov_mat = [];
end
%% Main
methods
    function MH = MetropolisHastingsAdaCov(varargin)
        if nargin > 0
            MH.init(varargin{:});
        end
    end
end
%% MCMC - init, sample, and transition, until convergence.
methods
    function mcmc_iso_normrnd(MH)
        [th0, cov_mat] = MH.init_iso_sd_typical_scale;
        
        assert(bml.stat.is_constr_met(th0, ...
            MH.th_lb, MH.th_ub, MH.th_constr{:}), ...
            'initial point violates constraints!');
        
        for i_samp = 1:MH.n_samp_max
            if MH.verbose
                fprintf('-----\n');
                fprintf('Step %d\n', i_samp);
            end
            
            if (i_samp >= MH.n_samp_bef_cov_update) ...
                    && (mod(i_samp - MH.n_samp_bef_cov_update, ...
                            MH.n_samp_btw_cov_update) == 0) ...
                    && (i_samp <= MH.n_samp_burnin)
                
                cov_mat = MH.update_cov;
            end
            
            th_proposal = MH.propose_mvnrnd(th0, cov_mat);
            nll_proposal = MH.get_nll_targ(th_proposal);
            th0 = MH.transition(nll_proposal, th_proposal);
            
            MH.plot_online;
        end
    end
end
%% Adapt cov
methods
    function cov_mat = update_cov(MH)
        n_th = MH.n_th;
        n_samp = MH.n_samp;
        if n_samp >= MH.n_samp_bef_cov_update
            incl = n_samp + 1 - (1:min(n_samp, MH.n_samp_cov_update_max));
            
            % following Haario 2006 and Gelman 1995
            [~, cov_mat0] = MH.init_iso_sd_typical_scale;
            cov_mat = nan0(cov(MH.th_samp(incl,:))) .* 2.4^2 ./ n_th ...
                + cov_mat0;
        end
    end
end
%% Demo
methods
    function demo(MH)
        %%
        fun_nll_targ = @(x) ...
            -bml.stat.logmvnpdf(x, [1 2], [3 1; 1 2]);
        th0 = [1, 0];
        lb = [-1, -1];
        ub = [3, 3];
        
        MH.th_scale_factor = 1e-4;
        MH.n_samp_max = 1e4;
        MH.n_samp_burnin = 5e3;
        MH.n_samp_bef_cov_update = 100;
        MH.n_samp_btw_cov_update = 20;
        MH.n_samp_btw_plot = 1e3;
        MH.verbose = false;
        
        MH.init(fun_nll_targ, th0, lb, ub, ...
            'th_constr', {[1 1], 3, [], [], ...
            @(v) [v(1) - v(2) - 2, 0]});
%             'th_constr', {[], [], [], [], ...
%             @(v) [v(1) - v(2) - 2, 0]});
%             'th_constr', {[1 1], 3, [], [], ...
%             @(v) [(v(1) + 1) .* (v(2) -2), 0]});
        
        %%
        MH.main;
        
        %%
        MH.plot_all;
        
        %%
        fig_tag('joint');
        clf;
        plot(MH.th_samp_aft_burnin(:,1), MH.th_samp_aft_burnin(:,2), 'o');
        grid on;
    end
end
end