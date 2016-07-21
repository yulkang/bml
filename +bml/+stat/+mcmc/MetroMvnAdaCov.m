classdef MetroMvnAdaCov < bml.stat.mcmc.MetroMvn
    % Metropolis sampling with multivariate normal proposal distribution.
    
    % 2016 (c) Yul Kang. hk2699 at columbia dot edu.
    
%% Intermediate variables
properties
    n_samp_bef_adapt_cov = 1e2;
    n_samp_btw_adapt_cov = 50;
    n_samp_max_adapt_cov = 1e3; % max number of trials to calculate cov with.
end
    
%% Main
methods
    function MC = MetroMvnAdaCov(varargin)
        if nargin > 0
            MC.init(varargin{:});
        end
    end
    function init(MC, varargin)
        MC.init@bml.stat.mcmc.MetroMvn(varargin{:});
    end
    function append(MC, n_samp)
        for i_samp = 1:n_samp
            MC.append@bml.stat.mcmc.MetroMvn(1);
            
            if (MC.n_samp <= MC.n_samp_burnin) ...
                    && (MC.n_samp >= MC.n_samp_bef_adapt_cov) ...
                    && (mod(MC.n_samp - MC.n_samp_bef_adapt_cov, ...
                            MC.n_samp_btw_adapt_cov) == 0)
                MC.adapt_cov;
            end
        end
    end
    function adapt_cov(MC, varargin)
        ix_samp_incl = max(1, MC.n_samp - MC.n_samp_max_adapt_cov):MC.n_samp;
        samp = MC.th_samp(ix_samp_incl, :);
        
        % Following Haario 2006 and Gelman 1995
        sigma = nan0(cov(MH.th_samp(incl,:))) .* 2.4^2 ./ MC.n_th + sigma0;
        MC.sigma_proposal = sigma;
    end
end
end