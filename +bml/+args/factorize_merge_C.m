function [Cs, n] = factorize_merge_C(C_factors, C_common)
% C_factors: {C_factor1, C_factor2, ..., C_factorK}
% C_common: cell array of name-value pair suited as an input to varargin2C.
%
% Cs{1} = varargin2C(C_common, ...
%           varargin2C(C_factorK{1}, ...
%             varargin2C( ..., C_factor1{1})));
% Cs{prod(cellfun(@numel, C_factors))} = ...
%           varargin2C(C_common, ...
%             varargin2C(C_factorK{end}, ...);

% 2016 (c) Yul Kang. hk2699 at columbia dot edu.

    if nargin < 2
        C_common = {}; 
    end

    [Cs0, n] = factorize(C_factors);
    Cs = cell(n, 1);
    for ii = 1:n
        C1 = {};
        for jj = 1:size(Cs0, 2)
            C1 = varargin2C(Cs0{ii,jj}, C1); 
        end
        Cs{ii} = varargin2C(C_common, C1);
    end
end