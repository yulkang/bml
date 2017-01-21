function S = diff_fields(S, S1, varargin)
% diff_fields removes overlapping fields.
%
% S = diff_fields(S, S1, ...)
%
% OPTIONS:
% 'only_if_equal', true

% 2016 (c) Yul Kang. hk2699 at columbia dot edu.

opt = varargin2S(varargin, {
    'only_if_equal', true
    });

if opt.only_if_equal
    fs = intersect(fieldnames(S), fieldnames(S1));
    for f = fs(:)'
        if isequal(S.(f{1}), S1.(f{1}))
            S = rmfield(S, f{1});
        end
    end
else
    S = bml.struct.rmfield(S, fieldnames(S1));
end
end