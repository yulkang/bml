function [h, ax_dst_new] = openfig_to_axes(file, ax_dst, varargin)
% [h, ax_dst_new] = openfig_to_axes(file, ax_dst, varargin)
%
% file: .fig file
% ax_dst: old axes
%
% h : struct containing handles
% ax_dst_new: the new, merged axes.

% 2016 Yul Kang. hk2699 at columbia dot edu.

loadedfig = openfig(file, 'invisible');

ax_src = findobj(loadedfig, 'Type', 'Axes');
[h, ax_dst_new] = bml.plot.copyaxes(ax_src, ax_dst);

delete(loadedfig);
end