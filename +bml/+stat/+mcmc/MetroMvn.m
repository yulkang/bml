classdef MetroMvn < bml.stat.mcmc.MCMC
    % Metropolis sampling with multivariate normal proposal distribution.
    
%% Props - Settings - Required
properties
    th0
    
    mu_proposal
    sigma_proposal
    
    fun_nll_targ
    
    Constr
end
%% Props - Settings - Optional
properties
    n_samp_max = 2e4;
    n_samp_burnin = 5e3;
    
    to_plot_online = true;
end
%% Props - Results
properties (Dependent)
    th_samp
    nll_samp
    p_accept
    transitioned
end
properties
    th_samp_ = [];
    nll_samp_ = [];
    p_accept_ = [];
    transitioned_ = [];
end
%% Props - Intrmediate
properties 
    fun_proposal % function(th_src, n) % gives th_mat
    fun_nll_proposal % function(th_src, th_dst) % gives p (column vec)
    
    n_samp = 0;
    
    th_now
    nll_now
end
properties (Dependent)
    n_th
end
%% Init
methods
    function MC = MetroMvn(varargin)
        MC.Constr = VectorConstraints;
        if nargin > 0
            MC.init(varargin{:});
        end
    end
    function init(MC, varargin)
        bml.oop.varargin2props(MC, varargin, true);
        
        % Required inputs
        for th = {'th0', 'sigma_proposal', 'fun_nll_targ'}
            assert(~isempty(MC.(th{1})), '%s is required!', th{1});
        end
        
        % Random number generator
        rng('shuffle');
        
        % Preallocate
        MC.n_samp = 0;
        MC.th_samp_ = nan(MC.n_samp_max, MC.n_th);
        MC.nll_samp_ = nan(MC.n_samp_max, 1);
        MC.p_accept_ = nan(MC.n_samp_max, 1);
        MC.transitioned_ = fals(MC.n_samp_max, 1);
        
        % Initial point
        MC.th_now = MC.th0;
        MC.nll_now = MC.fun_nll_targ(MC.th_now);
        MC.add_samp(MC.th_now, MC.nll_now, 1, true);
        
        % Multivariate normal proposal
        MC.mu_proposal = zeros(1, MC.n_th);
        MC.fun_proposal = @(th_src, n, mu, sigma) bsxfun(@plus, th_src, ...
            mvnrnd(mu, sigma, n));
        MC.fun_nll_proposal = @(th_src, th_dst, mu, sigma) ...
            bml.stat.logmvnpdf(bsxfun(@minus, th_dst, th_src), mu, sigma);
    end
end
%% Main
methods
    function main(MC)
        MC.Constr = VectorConstraints;
        if MC.n_samp < MC.n_samp_max
            MC.append(MC.n_samp_max - MC.n_samp);
        end
    end
    function append(MC, n_samp)
        for i_samp = 1:n_samp
            th_proposal = MC.get_proposal;
            nll_proposal = MC.fun_nll_targ(th_proposal);
            MC.transition(nll_proposal, th_proposal);
            
            MC.plot_online;
        end
    end
    function get_proposal(MC)
        all_met = false;
        while ~all_met
            th_proposal = MC.fun_proposal(MC.th_now, 1, ...
                MC.mu_proposal, MC.sigma_proposal);
            all_met = MC.Constr;
        end
    end
    function transition(MC, nll_proposal, th_proposal)
        assert(isscalar(nll_proposal));
        assert(isvector(th_proposal));
        
        [to_transition, p_accept] = MC.get_to_transition( ...
            MC.nll_now, MC.nll_proposal);
        if to_transition
            MC.th_now = th_proposal;
            MC.nll_now = th_proposal;
        end
        MC.add_samp(MC.th_now, MC.nll_now, p_accept, to_transition);
    end
    function [to_transition, p_accept]= get_to_transition(~, ...
            nll_now, nll_proposal)
        
        if nll_new == inf
            p_accept = 0;
            to_transition = false;
            
        elseif nll_new < nll_old
            p_accept = 1;
            to_transition = true;
            
        else % nll_new >= nll_old
            p_accept = exp(nll_old - nll_new); % <= 1
            r = rand;
            to_transition = r <= p_accept;
        end
    end
    function add_samp(MC, th, nll, p_accept, transitioned)
        MC.n_samp = MC.n_samp + 1;
        
        MC.th_samp_(MC.n_samp, :) = th;
        MC.nll_samp_(MC.n_samp) = nll;
        MC.p_accept_(MC.n_samp) = p_accept;
        MC.transitioned_(MC.n_samp) = transitioned;
    end
end
%% Plot
methods
    function plot_online(MC)
        if MC.to_plot_online && ~is_in_parallel
            MC.plot_all;
        end
    end
    function plot_all(MC)
    end
end
%% Utilities
methods
    function v = get.n_th(MC)
        v = length(MC.th0);
    end
    function v = get.th_samp(MC)
        v = MC.th_samp_(1:MC.n_samp, :);
    end
    function v = get.nll_samp(MC)
        v = MC.nll_samp_(1:MC.n_samp);
    end
    function v = get.p_accept(MC)
        v = MC.p_accept_(1:MC.n_samp);
    end
    function v = get.transitioned(MC)
        v = MC.transitioned_(1:MC.n_samp);
    end
end
%% Adaptors
methods
    
end
%% Demo
methods
    
end
end