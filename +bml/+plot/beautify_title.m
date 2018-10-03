function str = beautify_title(str, varargin)
% str = beautify_title(str0)
str = bml.str.wrap_text(bml.plot.strrep_label(str), varargin{:});
end