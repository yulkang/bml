function color = image_p_color(p, varargin)
% color = image_p_color(p, varargin)
%
% INPUT:
% p(row,column,i_color)
%
% OUTPUT:
% color(row,column,RGB): can be used in image()
% 
% OPTIONS:
% 'colors', [ % colors(i_color, RGB)
%     1, 0, 0
%     0, 1, 0
%     0, 0, 0.75
%     ]
% 'color_background', [1, 1, 1]

S = varargin2S(varargin, {
    'colors', [ % colors(i_color, RGB)
        1, 0, 0
        0, 1, 0
        0, 0, 0.75
        ]
    'color_background', [1, 1, 1]
    }, true);

n_color = size(p, 3);
color = zeros(size(p, 1), size(p, 2), 3);

for i_color = 1:n_color
    color1 = reshape2vec(S.colors(i_color,:), 3);
    color = color + color1 .* p(:, :, i_color);
end

p_bkd = 1 - sum(p, 3);
color = color + reshape2vec(S.color_background, 3) .* p_bkd;
end