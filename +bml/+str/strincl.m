function varargout = strincl(varargin)
% res = strincl(txt, ptn)
% res(i_txt, i_ptn) = true if ~isempty(strfind(txt{i_txt}, ptn{i_ptn}))
[varargout{1:nargout}] = strincl(varargin{:});