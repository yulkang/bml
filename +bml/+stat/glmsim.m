function [ySim, b1, ci, bSim] = glmsim(b0, x, link, varargin)
% Given 'true' beta estimates and x, simulate what the estimates of b would be,
% had the experiment been repeated.
%
% [ySim, b1, se, bAll] = glmsim(b0, x, link='logit', varargin)
%
% For the older version, see GLMSIM_OLD.
%
% 2015 (c) Yul Kang. hk2699 at columbia dot edu.

if nargin < 3 || isempty(link), link = 'logit'; end

S = varargin2S(varargin, {
    'nSim',  100
    'alpha', normcdf(-1)*2 % 0.05 % To match the convention to plot one standard error.
    });

nDat  = size(x,1);

switch link
    case 'logit'
        pSim = glmval(b0(:), x, link);
        ySim = binornd(1,repmat(pSim, [1, S.nSim]));
        
        if nargout >= 2
            bSim = glmfits(x, ySim, 'binomial');
            bSim = {bSim.b};
            bSim = cat(2,bSim{:});

            b1 = median(bSim(2,:));
            ci = prctile(bSim(2,:), [S.alpha/2, 1-S.alpha/2].*100);
        end
end