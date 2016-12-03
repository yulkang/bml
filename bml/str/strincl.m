function res = strincl(txt, ptn)
% res = strincl(txt, ptn)
% res(i_txt, i_ptn) = true if ~isempty(strfind(txt{i_txt}, ptn{i_ptn}))

% 2016 (c) Yul Kang. hk2699 at columbia dot edu.

if ischar(txt)
    txt = {txt};
end
if ischar(ptn)
    ptn = {ptn};
end

n_txt = numel(txt);
n_ptn = numel(ptn);

res = false(n_txt, n_ptn);

for ii = 1:n_ptn
    res(:, ii) = ~vVec(cellfun(@isempty, strfind(txt, ptn{ii})));
end
end