function h = plot_centroid(mu, sig, varargin)

%%
[u, s] = svd(sig);

%%
deg = 0:360;
x0 = cosd(deg); %  * ev(1);
y0 = sind(deg); %  * ev(2);

%%
xy = bsxfun(@plus, u * sqrt(s) * [x0; y0], mu(:))';
h = plot(xy(:,1), xy(:,2), varargin{:});
% axis equal