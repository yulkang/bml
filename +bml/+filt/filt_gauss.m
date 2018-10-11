function varargout = filt_gauss(varargin)
% [f, n, x] = filt_gauss(sig, w=6)
%
% sig: in the unit of number of elements.
% w: width of the filter in the unit of sigma.
% f: filter.
% n: total number of elements.
%
% Example
% -------
% dt = 0.01;
% t = 0:dt:1;
% nt = length(t);
% sig = 0.1;
% f = filt_gauss(round(sig/dt));
% s = double(t == 0);
% ss = conv(s,f,'same');
% plot(t,s,t,ss);

% 2015 (c) Yul Kang. hk2699 at cumc dot columbia dot edu.

[varargout{1:nargout}] = filt_gauss(varargin{:});