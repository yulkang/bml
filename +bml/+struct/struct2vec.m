function v = struct2vec(S)
% v = struct2vec(S)
C = struct2cell(S);
v = cell2mat(C);