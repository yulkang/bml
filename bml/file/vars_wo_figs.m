function vars_to_save = vars_wo_figs(allvars)
% tosave = vars_wo_figs(whos)
%
% Run save(file, vars_to_save.name) afterwards.
%
% Adapted from https://stackoverflow.com/a/38131385/2565317

% Get a list of all variables
if nargin < 1
    allvars = evalin('caller', 'whos');
end

% Identify the variables that ARE NOT graphics handles. This uses a regular
% expression on the class of each variable to check if it's a graphics object
tosave = cellfun(@isempty, regexp({allvars.class}, '^matlab\.(ui|graphics)\.'));

vars_to_save = allvars(tosave);