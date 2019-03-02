function [n_tr, cond_sim, outcome_sim] = sim_tr(p, n_tr_in_cond)
% [n_tr, cond_sim, outcome_sim] = sim_tr(p, n_tr_in_cond)
%
% INPUT:
% p(cond,outcome) is P(outcome|condition)
% p(cond,:) sums to 1 (within each row)
% n_tr_in_cond(cond) is an integer number of trials within that condition
%
% OUTPUT:
% n_tr(cond, outcome) is the number of trials with (cond, outcome) pair
% cond_sim(tr) is the tr-th trial's condition
% outucome_sim(tr) is the tr-th trial's outcome

n_cond = size(p, 1);
n_outcome = size(p, 2);
if nargin < 2
    n_tr_in_cond = ones(n_cond, 1);
end

% initialize output
n_tr = zeros(n_cond, n_outcome);

if nargout >= 2
    cond_sim = cell(n_cond, 1);
    outcome_sim = cell(n_cond, 1);
end

for i_cond = 1:n_cond
    sim1 = randsample(n_outcome, n_tr_in_cond(i_cond), true, ...
        p(i_cond, :));
    n_tr(i_cond, :) = accumarray(sim1(:), 1, [n_outcome, 1], @sum)';
    
    if nargout >= 2
        cond_sim{i_cond} = i_cond + zeros(n_tr_in_cond(i_cond), 1);
        outcome_sim{i_cond} = sim1(:);
    end
end
if nargout >= 2
    cond_sim = vVec(cell2vec(cond_sim));
    outcome_sim = vVec(cell2vec(outcome_sim));
end
    