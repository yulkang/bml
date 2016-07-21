classdef MetropolisHastings < DeepCopyable
    % Metropolis-Hastings sampling.
    
%% Settings
properties
    seed = 'shuffle';
    
    fun_nll_targ = []; % function(th) % neg log likelihood
    fun_proposal = []; % function(th_src, n) % gives th_mat
    fun_nll_proposal = []; % function(th_src, th_dst) % gives p (column vec)

    th0 = []; % row vector
    nll0 = nan; % scalar
    
    n_samp_max = 1e4;
    n_samp_burnin = 5e3;
    n_samp_btw_plot = 100; % Set > 0 to plot online
    
    verbose = false;
end
%% For bounded proposal
properties
    th_lb = [];
    th_ub = [];
    th_constr = {}; % {A, b, Aeq, beq, c, ceq}
    th_scale_factor = 1e-5;
end
properties (Dependent)
    th_scale
end
%% Intermediate variables
properties    
    th_now = []; % row vector
    nll_now = nan;
end
properties (Dependent)
    n_th
end
%% Results
properties (Dependent)
    th_samp
    nll_samp
    
    th_proposal_all
    nll_proposal_all
    p_accept_all
    p_accept_aft_burnin
    
    th_mean
    th_std
    th_cov
    
    th_median
    th_pmil025 % 25 permil = 2.5 percentile
    th_pmil975 % 975 permil = 97.5 percentile
end
properties (Dependent)
    th_samp_aft_burnin
end
properties
    n_samp = 0;

    th_samp_
    nll_samp_
    
    th_proposal_all_
    nll_proposal_all_
    p_accept_all_
end
%% Main
methods
    function MH = MetropolisHastings(varargin)
        if nargin > 0
            MH.init(varargin{:});
        end
    end
    function init(MH, fun_nll_targ, th0, lb, ub, varargin)
        % init(MH, fun_nll_targ, th0, lb, ub, ...)
        MH.fun_nll_targ = fun_nll_targ;
        MH.th0 = th0;
        MH.th_now = th0;
        MH.th_lb = lb;
        MH.th_ub = ub;
        
        bml.oop.varargin2props(MH, varargin);

        MH.nll0 = MH.get_nll_targ(th0);
        MH.nll_now = MH.nll0;

        MH.reset_samp;
        MH.add_samp(MH.th_now, MH.nll0);        
    end
    function main(MH)
        rng(MH.seed);
        MH.mcmc_iso_normrnd;
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
            
            th_proposal = MH.propose_mvnrnd(th0, cov_mat);
            nll_proposal = MH.get_nll_targ(th_proposal);

            th0 = MH.transition(nll_proposal, th_proposal);
            MH.plot_online;
        end
    end
end
%% Initial points
% [th0, cov_mat] = init_*(MH)
methods
    function [th0, cov_mat] = init_iso_sd_typical_scale(MH, varargin)
        % [th0, cov_mat] = init_iso_sd_typical_scale(MH, ...)
        
        S = varargin2S(varargin, {
            'th0', MH.th0
            'scale', MH.th_scale
            });
        
        th0 = S.th0;
        cov_mat = diag(S.scale);
    end
end
%% Proposal - not used
methods
    function th_proposal = get_proposal(MH, th0)
        th_proposal = MH.fun_proposal(th0);
    end
    function nll_proposal = get_nll_proposal(MH, th0, th_proposal)
        nll_proposal = MH.fun_nll_proposal(th0, th_proposal);
    end
end
%% Propose around th0 given scale
% [nll, th_mat_free] = sample_*(MH, th0, ...)
methods
    function th_proposal = propose_mvnrnd(MH, th0, cov_mat)
        % th_proposal = propose_mvnrnd(MH, th0, cov_mat)
        n_th = length(th0);
        
        met_constraints = false;
        while ~met_constraints
            r0 = mvnrnd(zeros(1, n_th), cov_mat);
            th_proposal = bsxfun(@plus, th0, r0);
            
            met_constraints = bml.stat.is_constr_met(th_proposal, ...
                MH.th_lb, MH.th_ub, MH.th_constr{:});
        end
    end
end
%% Cost, Transition
methods
    function nll = get_nll_targ(MH, th)
        n = size(th, 1);
        nll = zeros(n, 1);
        for ii = 1:n
            is_met = bml.stat.is_constr_met(th(ii,:), ...
                MH.th_lb, MH.th_ub, MH.th_constr{:});
            if ~is_met
                nll(ii,1) = inf;
            else
                nll(ii,1) = MH.fun_nll_targ(th(ii,:));
            end
        end
    end
    function [th_new, nll_new] = transition(MH, ...
            nll_proposal, th_proposal, varargin)
        % [th_vec_new, nll_new] = transition(MH, nll1, th_mat_proposal)
        
        assert(isscalar(nll_proposal), 'Only can handle scalar for now!');
        
        S = varargin2S(varargin, {
            'nll_old', MH.nll_now
            'th_old', MH.th_now
            });
        
        [to_transition, p_accept] = ...
            MH.get_to_transition(S.nll_old, nll_proposal);
        
        if to_transition
            nll_new = nll_proposal;
            th_new = th_proposal;
        else
            nll_new = S.nll_old;
            th_new = S.th_old;
        end
        
        MH.nll_now = nll_new;
        MH.th_now = th_new;
        MH.add_samp(th_new, nll_new, th_proposal, nll_proposal, p_accept);
    end
    function [tf, p_accept] = get_to_transition(MH, nll_old, nll_new)
        % [tf, p_accept] = get_to_transition(~, nll_old, nll_new)
        
        if MH.verbose
            fprintf('nll dif: %1.2g  old: %1.2g\n', ...
                nll_new - nll_old, nll_old);
        end
        
        if nll_new == inf
            p_accept = 0;
            tf = false;
            
        elseif nll_new < nll_old
            p_accept = 1;
            tf = true;
            
        else % nll_new >= nll_old
            p_accept = exp(nll_old - nll_new); % <= 1
            r = rand;
            tf = r <= p_accept;
            
            if MH.verbose
                fprintf('alpha: %1.2f, r: %1.2f\n', p_accept, r);
            end
        end
        
        if MH.verbose
            if tf
                fprintf('Transition!\n');
            else
                fprintf('No transition!\n');
            end
        end
    end
end
%% Utilities
methods
    function v = get.n_th(MH)
        v = length(MH.th_now);
    end
    function reset_samp(MH)
        MH.th_samp_ = zeros(MH.n_samp_max, MH.n_th);
        MH.nll_samp_ = zeros(MH.n_samp_max, 1);
        
        MH.th_proposal_all_ = zeros(MH.n_samp_max, MH.n_th);
        MH.nll_proposal_all_ = zeros(MH.n_samp_max, 1);
        
        MH.n_samp = 0;
    end
    function add_samp(MH, th, nll, th_proposal, nll_proposal, p_accept)
        n_new = size(th, 1);
        ix_new = MH.n_samp + (1:n_new);
        
        MH.th_samp_(ix_new, :) = th;
        MH.nll_samp_(ix_new, 1) = nll;
        
        if nargin >= 4
            MH.th_proposal_all_(ix_new, :) = th_proposal;
            MH.nll_proposal_all_(ix_new, :) = nll_proposal;
            MH.p_accept_all_(ix_new, :) = p_accept;
        end
        
        MH.n_samp = ix_new(end);
    end
    
    function v = get.th_samp(MH)
        v = MH.th_samp_(1:MH.n_samp, :);
    end
    function v = get.nll_samp(MH)
        v = MH.nll_samp_(1:MH.n_samp, :);
    end
    function v = get.th_proposal_all(MH)
        v = MH.th_proposal_all_(1:MH.n_samp, :);
    end
    function v = get.nll_proposal_all(MH)
        v = MH.nll_proposal_all_(1:MH.n_samp, :);
    end
        
    function v = get.th_samp_aft_burnin(MH)
        v = MH.th_samp_((MH.n_samp_burnin + 1):MH.n_samp, :);
    end
    
    function v = get.p_accept_all(MH)
        v = MH.p_accept_all_(1:min(MH.n_samp, end), :);
    end
    function v = get.p_accept_aft_burnin(MH)
        v = MH.p_accept_all_((MH.n_samp_burnin + 1):MH.n_samp, :);
    end
    
    function v = get.th_scale(MH)
        th_ub = MH.th_ub;
        th_lb = MH.th_lb;

        pos_only = th_lb >= 0;
        neg_only = th_ub <= 0;
        both = (~pos_only) & (~neg_only);

        dispersion = (th_ub - th_lb) ./ 4;
        middle = (th_ub + th_lb) ./ 2;

        v = ones(size(th_ub));

        v(pos_only | neg_only) = middle(pos_only | neg_only);
        v(both) = dispersion(both);
        
        v = abs(v) * MH.th_scale_factor;
    end
    function v = get.th_mean(MH)
        v = mean(MH.th_samp_aft_burnin);
    end
    function v = get.th_std(MH)
        v = std(MH.th_samp_aft_burnin);
    end
    function v = get.th_cov(MH)
        v = cov(MH.th_samp_aft_burnin);
    end
    function v = th_prctile(MH, incl_th, prct)
        if ischar(incl_th) && isequal(incl_th, ':')
            incl_th = 1:MH.n_th;
        end
        samp = MH.th_samp_aft_burnin(:, incl_th);
        v = prctile(samp, prct);
    end
    function v = get.th_median(MH)
        v = median(MH.th_samp_aft_burnin);
    end
    function v = get.th_pmil025(MH)
        v = MH.th_prctile(':', 2.5);
    end
    function v = get.th_pmil975(MH)
        v = MH.th_prctile(':', 97.5);
    end
end
%% Demo
methods
    function demo(MH)
        %%
        fun_nll_targ = @(x) ...
            -bml.stat.logmvnpdf(x, [1 2], [3 1; 1 3]);
        th0 = [0, 0];
        lb = [-2, -2];
        ub = [6, 6];
        
        MH.th_scale_factor = 1e-3;
        MH.n_samp_max = 1e3;
        
        MH.init(fun_nll_targ, th0, lb, ub);
        
        %%
        MH.main;
        
        %%
        MH.plot_stat;
    end
end
%% Plot
methods
    function plot_online(MH)
        if (MH.n_samp_btw_plot > 0) ...
                && (mod(MH.n_samp, MH.n_samp_btw_plot) == 0) ...
                && ~is_in_parallel

            try
                fprintf('Plotting up to sample %d\n', MH.n_samp);
                MH.plot_all;
                drawnow;
            catch err
                warning(err_msg(err));
            end
        end
    end
    function plot_all(MH)
        tags = {'nll', 'samp', 'cov', 'split', 'p_accept'};
        for tag = tags(:)'
            try
                fig_tag(tag{1});
                MH.(['plot_' tag{1}]);
            catch err
                warning(err_msg(err));
            end
        end
        MH.print_stat;
    end
    function plot_nll(MH)
        plot(MH.nll_samp);
        ylabel('NLL');
        xlabel('Step');
    end
    function plot_samp(MH)
        samp_z = standardize(MH.th_samp);
        n_samp = size(samp_z, 1);
        n_th = size(samp_z, 2);
        
        win = 1;
        samp_incl = round(win/2):round(n_samp - win/2);
        
        if win > 1
            for ii = 1:n_th
                samp_z(:,ii) = smooth(samp_z(:,ii), win);
            end
        end
        
        n_th_per_plot = 5;
        n_plot = ceil(n_th / n_th_per_plot);
        
        for i_plot = 1:n_plot
            subplot(n_plot, 1, i_plot);
            
            plot_incl_min = (i_plot - 1) * n_th_per_plot + 1;
            plot_incl_max = min(plot_incl_min + n_th_per_plot - 1, n_th);
            plot_incl = plot_incl_min:plot_incl_max;
            
            plot(samp_incl, samp_z(samp_incl, plot_incl));
            xlim([0, samp_incl(end)]);
            
            title(sprintf('Param %d-%d', plot_incl(1), plot_incl(end)));
            if i_plot == n_plot
                xlabel('Step');
                ylabel('Param (Z-score)');
            end
        end
    end
    function plot_cov(MH)
        slice = [
            1
            ceil(min(MH.n_samp, MH.n_samp_burnin) / 2)
            min(MH.n_samp, MH.n_samp_burnin)
            max(MH.n_samp_burnin, ceil((MH.n_samp + MH.n_samp_burnin) / 2))
            MH.n_samp + 1
            ];
        slice = min(slice, MH.n_samp + 1);
        n_slice = length(slice) - 1;
            
        n_th = MH.n_th;
        cov_all = nan(n_th, n_th, n_slice);
        
        samp_z = standardize(MH.th_samp);
        
        for i_slice = n_slice:-1:1
            h(i_slice) = subplot(n_slice, 1, i_slice);
            
            tr_st = slice(i_slice);
            tr_en = max(slice(i_slice + 1) - 1, slice(i_slice));
            
            if tr_en - tr_st < n_th * 3
                continue;
            end
            
            samp = samp_z(tr_st:tr_en, :);
            cov_mat = cov(samp);
            cov_all(:,:,i_slice) = cov_mat;
            
            imagesc(cov_mat);
            colorbar;
            axis square;
            title(sprintf('Trials %d-%d', tr_st, tr_en));
        end
        c_lim = prctile(cov_all(:), [5, 95]);
        set(h, 'CLim', c_lim);
    end
    function plot_split(MH)
        slice = [
            1
            ceil(min(MH.n_samp, MH.n_samp_burnin) / 2)
            min(MH.n_samp, MH.n_samp_burnin)
            max(MH.n_samp_burnin, ceil((MH.n_samp + MH.n_samp_burnin) / 2))
            MH.n_samp + 1
            ];
        slice = min(slice, MH.n_samp + 1);
        n_slice = length(slice) - 1;

        n_th = MH.n_th;
        trs = cell(1, n_slice);
        for i_slice = 1:n_slice
            tr_st = slice(i_slice);
            tr_en = max(slice(i_slice + 1) - 1, slice(i_slice));
            if tr_en - tr_st < n_th * 3
                continue;
            end
            trs{i_slice} = tr_st:tr_en;
        end
        
        if MH.n_samp > MH.n_samp_burnin + MH.n_samp_burnin / 2
            samp0 = MH.th_samp_aft_burnin;
        else
            samp0 = MH.th_samp;
        end
        mu_samp = mean(samp0);
        std_samp = std(samp0);

        samp_all = bsxfun(@rdivide, bsxfun(@minus, ...
            MH.th_samp, mu_samp), std_samp);
        
        f_shift = @(ii) (ii - (n_slice + 1) / 2) / n_slice / 20;
        
        n_row = 2;
        row = 0;
        row = row + 1;
        for i_slice = 1:n_slice
            samp = samp_all(trs{i_slice}, :);
            m = mean(samp);
            s = sem(samp);
            
            subplotRC(n_row, 1, row, 1);
            
            shift = f_shift(i_slice);
            h(i_slice) = errorbar((1:n_th) + shift, m, s);
            hold on;
        end
        hold off;
        legend(h, {'burnin1', 'burnin2', 'aft1', 'aft2'}, ...
            'Location', 'EastOutside');
        title('mean');
        grid on;
        
        row = row + 1;
        for i_slice = 1:n_slice
            samp = samp_all(trs{i_slice}, :);
            m = std(samp);
            s = sestd(samp);
            
            subplotRC(n_row, 1, row, 1);
            
            shift = f_shift(i_slice);
            h(i_slice) = errorbar((1:n_th) + shift, m, s);
            hold on;
        end
        hold off;
        legend(h, {'burnin1', 'burnin2', 'aft1', 'aft2'}, ...
            'Location', 'EastOutside');
        title('std');
        grid on;
    end
    function plot_p_accept(MH)
        subplot(3,1,1);
        title('p accept by sample');
        plot(MH.p_accept_all);    
        xlabel('Sample');
        ylabel('p accept');
        axis tight;
        
        subplot(3,1,2);
        ecdf(MH.p_accept_all);
        title('p accept all');
        grid on;
        
        subplot(3,1,3);
        ecdf(MH.p_accept_aft_burnin);
        title('p accept aft burnin');
        grid on;
    end
    function print_stat(MH)
        disp('cov');
        disp(cov(MH.th_samp_aft_burnin));
        
        disp('mean');
        disp(mean(MH.th_samp_aft_burnin));
        
        disp('std');
        disp(std(MH.th_samp_aft_burnin));

        disp('mean p_accept_all');
        disp(mean(MH.p_accept_all));
        
        disp('mean p_accept_all after burnin');
        disp(mean(MH.p_accept_aft_burnin));
    end
end
end