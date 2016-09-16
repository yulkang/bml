function varargout = factorizeC(varargin)
% C: struct or cell array with name-value pairs.
% When C is a struct, identical to factorizeS.
% When C is a N-by-2 cell array with C(:,1) names and C(:,2) values,
% similar to factorizeS except that
% C(k,1) can be a cell array of names (instead of one name),
% in which case the fields will change values together.
%
% fields: fields to include or exclude
% to_exclude
% : if true, exclude the specified fields.
% : if false (default), include only the specified fields.
%
% EXAMPLE:
% 
[varargout{1:nargout}] = factorizeC(varargin{:});