function C1 = dealDefCell(C, default_values, empty_if_no_default, n_arg_out)
% C1 = dealDefCell(C, default_values, empty_if_no_default, n_arg_out)
%
% Same as dealDef except this outputs a cell array, not varargout.
%
% See also: dealDef

if nargin < 3, empty_if_no_default = false; end
if nargin < 4
    n_arg_out = numel(default_values);
end
nd = n_arg_out;
C1 = cell(1, nd);



% Copy inputs
for ii = 1:length(C)
    C1{ii} = C{ii};
    
    % If empty2d is true, empty inputs are replcaed with the default.
    if empty_if_no_default && isempty(C1{ii}) && (ii <= nd)
        C1{ii} = default_values{ii};
    end
end

% Copy defaults
for ii = (length(C)+1):min(n_arg_out, nd)
    C1{ii} = default_values{ii};
end