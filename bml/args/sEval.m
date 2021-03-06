function W = sEval(W, f, varargin)
% W = sEval(W, func, varargin)
%
% Evaluates W = (W.class).(func)(W, varargin{:})
% W.class tells which class the static method belongs to.
%
% See also: staticEval
%
% 2015 (c) Yul Kang. hk2699@cumc.columbia.edu

W = feval([W.class, '.', f], W, varargin{:});
end