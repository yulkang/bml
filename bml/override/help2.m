function varargout = help2(varargin)
% help2(obj, [meth])
% help2('class', [meth])
% help2(file)
% [...] = help2(...)

% 2015-2016 (c) Yul Kang. hk2699 at columbia dot edu.

[varargout{1:nargout}] = bml.override.help2(varargin{:});