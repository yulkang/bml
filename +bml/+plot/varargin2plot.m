function C = varargin2plot(C, defC)
% C = varargin2plot(C, defC)
%
% EXAMPLES:
% varargin2plot({'r-'}, {'b*--'})
% ans = 
%     'LineStyle'    '-'    'Marker'    '*'    'Color'    'r'
% 
% varargin2plot({'r--'}, {'b*:'})
% ans = 
%     'LineStyle'    '--'    'Marker'    '*'    'Color'    'r'
% 
% varargin2plot({'--'}, {'b*:'})
% ans = 
%     'LineStyle'    '--'    'Marker'    '*'    'Color'    'b'
% 
% varargin2plot({'--'}, {'b:', 'Marker', '*'})
% ans = 
%     'LineStyle'    '--'    'Color'    'b'    'Marker'    '*'
% 
% varargin2plot({'--+'}, {'b:', 'Marker', '*'})
% ans = 
%     'LineStyle'    '--'    'Color'    'b'    'Marker'    '+'
% 
% varargin2plot({'+', 'LineStyle', '--'}, {'b:', 'Marker', '*'})
% ans = 
%     'LineStyle'    '--'    'Color'    'b'    'Marker'    '+'
%
% 2015 (c) Yul Kang. hk2699 at cumc dot columbia dot edu.
    
if ~isempty(C) && isLineSpec(C{1})
    C = [linespec2C(C{1}), hVec(C(2:end))];
end
if nargin < 2
    defC = {};
elseif ~isempty(defC) && isLineSpec(defC{1})
    defC = [linespec2C(defC{1}), hVec(defC(2:end))];
end

C = varargin2C(C, defC);
    