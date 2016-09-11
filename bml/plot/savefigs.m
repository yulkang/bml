function files = savefigs(file, varargin)
% Save a figure in multiple formats.
%
% files = savefigs(file, varargin)
%
% OPTIONS
% 'ext', {'.fig', '.png'}
% 'subdir_w_ext', false % e.g., png/*.png
% 'size', [400 300] % Set empty to keep original.
% 'h_fig', [] % Use gcf if empty
% 'verbose', 1

S = varargin2S(varargin, {
    'ext', {'.fig', '.png'}
    'subdir_w_ext', false % e.g., png/*.png
    'size', [400 300] % Set empty to keep original.
    'h_fig', [] % Use gcf if empty
    'verbose', 1
    'resolution', 300
    'PaperUnit', 'centimeters'
    'PaperPosition', [] % If given, uses PaperPositionMode = 'manual'
    'PaperMargin', [0 0 0 0] % [left bottom right top]
    });

C_opt = {sprintf('-r%d', S.resolution)};

if isempty(S.h_fig)
    S.h_fig = gcf;
end

mkdir2(fileparts(file));

if ~isempty(S.size) && isempty(S.PaperPosition)
    set_size(S.h_fig, S.size);
end
if ~isempty(S.PaperPosition)
    paper_size = S.PaperPosition(3:4) ...
               + S.PaperPosition(1:2) ...
               + S.PaperMargin(1:2) ...
               + S.PaperMargin(3:4);
    set(S.h_fig, 'PaperPositionMode', 'manual');
    set(S.h_fig, 'PaperUnit', S.PaperUnit);
    set(S.h_fig, 'PaperSize', paper_size);
    set(S.h_fig, 'PaperPosition', S.PaperPosition);
end

files = cell(1,length(S.ext));
for i_ext = 1:length(S.ext)
    ext = S.ext{i_ext};
    if ext(1) ~= '.', ext = ['.', ext]; end %#ok<AGROW>
    S.ext{i_ext} = ext;
    
    if S.subdir_w_ext
        files{i_ext} = bml.file.add_subdir_ext( ...
            files{i_ext}, ext(2:end), ext);
    else
        files{i_ext} = [file, ext];
    end
    
    switch ext
        case '.fig'
            savefig(S.h_fig, files{i_ext});
        case '.png'
            print(S.h_fig, files{i_ext}, '-dpng2', C_opt{:});
        case '.tif'
            print(S.h_fig, files{i_ext}, '-dtiff', C_opt{:});
        case '.eps'
            print(S.h_fig, files{i_ext}, '-depsc2', C_opt{:});
        case '.pdf'
            print(S.h_fig, files{i_ext}, '-dpdf', C_opt{:});
        otherwise
            error('%s is not supported!', ext);
    end
end

if S.verbose
    fprintf('Saved figure to %s\n', file);
end