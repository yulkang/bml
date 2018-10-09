function c = pcolor_given_p(p, colors)
% c = pcolor_given_p(p, colors)
%
% p(x,y,k)
% colors(k,rgb)
% c(x,y,rgb)

assert(ismatrix(colors));
assert(size(colors, 1) == size(p, 3));

n_color_elem = size(colors, 2);
siz0 = size(p);
c = zeros([siz0(1:2), n_color_elem]);

p = max(p, eps);
p = bsxfun(@rdivide, p, sum(p, 3));

for ii = 1:n_color_elem
    c(:,:,ii) = sum(bsxfun(@times, p, ...
        reshape2vec(colors(:,ii), 3)), ...
        3);
end