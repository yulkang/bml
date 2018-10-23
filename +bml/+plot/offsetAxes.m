function offsetAxes(ax, reloffset)
% this function 'despines' the x- and y-axes, letting them begin at the
% first tick mark
%
% offsetAxes(ax, reloffset)
%
% thanks to Pierre Morel & undocumented Matlab
% and https://stackoverflow.com/questions/38255048/separating-axes-from-plot-area-in-matlab
%
% by Anne Urai, 2016

% reloffset added by Yul Kang, 2018

if nargin < 1 || isempty(ax)
    ax = gca;
end
% if ~exist('ax', 'var'), ax = gca; end

% % modify the x and y limits to below the data (by a small amount)
% ax.XLim(1) = ax.XLim(1)-(ax.XTick(2)-ax.XTick(1))/4;
% ax.YLim(1) = ax.YLim(1)-(ax.YTick(2)-ax.YTick(1))/4;

if nargin < 2 || isempty(reloffset)
    reloffset = ones(1,2) / 20;
elseif isscalar(reloffset)
    reloffset = reloffset + zeros(1,2);
else
    assert(isnumeric(reloffset));
    assert(numel(reloffset) == 2);
end

% % if isempty(ax.UserData)
% %     ax.UserData = struct;
% % end
% % if isstruct(ax.UserData)
% %     if ~isfield(ax.UserData, 'XLim')
% %         ax.UserData.XLim0 = ax.XLim;
% %     end
% %     if ~isfield(ax.UserData, 'YLim')
% %         ax.UserData.YLim0 = ax.YLim;
% %     end
% % else
% %     error([
% %         'UserData exists but not a struct! ' ...
% %         'Original XLim & YLim cannot be saved ' ...
% %         'and may cause repeated rescaling!']);
% % end
% % xlim0 = ax.UserData.XLim0;
% % ylim0 = ax.UserData.YLim0;
xlim0 = ax.XLim;
ylim0 = ax.YLim;

% % this will keep the changes constant even when resizing axes
% addlistener(ax, 'MarkedClean', @(obj,event)resetVertex(ax));

% modify the x and y limits to below the data (by a small amount) 
% w.r.t. the x and y range, rather than ticks (YK)
ax.XLim(1) = ax.XLim(1) - diff(xlim0) .* reloffset(1);
ax.YLim(1) = ax.YLim(1) - diff(ylim0) .* reloffset(2);

% this will keep the changes constant even when resizing axes
addlistener(ax, 'MarkedClean', @(obj,event)resetVertex(ax));

end

function resetVertex ( ax )
% extract the x axis vertext data

% X, Y and Z row of the start and end of the individual axle.
ax.XRuler.Axle.VertexData(1,1) = min(get(ax, 'Xtick'));
% repeat for Y (set 2nd row)
ax.YRuler.Axle.VertexData(2,1) = min(get(ax, 'Ytick'));

end