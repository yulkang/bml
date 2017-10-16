function s = get_title(s, varargin)
% s = get_title(s, varargin)
s = bml.str.wrap_text(strrep(s, '_', '-'), varargin{:});