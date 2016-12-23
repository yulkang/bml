function varargout = rows_w_no_nan(varargin)
% varargout = rows_w_no_nan(varargin)

varargin_double = cellfun(@double, varargin, ...
    'UniformOutput', false);
no_nan = all(~isnan(cell2mat(varargin_double)), 2);
varargout = cellfun(@(v) v(no_nan,:), varargin, ...
    'UniformOutput', false);
end