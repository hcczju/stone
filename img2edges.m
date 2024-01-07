function [Edges, mRows, nCols] = img2edges(path)
    bw_img = img_binary(path);
    [m, n] = size(bw_img);
    % [
    %   [east; west; sourth; north; eastnorth; eastsourth; westsourth; westnorth]
    %   ......
    %   ......
    %   ......
    %   [east; west; sourth; north; eastnorth; eastsourth; westsourth; westnorth]
    % ] (m*n) rows, 8 cols
    Edges = Inf(m*n, 8); 
    mRows = m; nCols = n;
    for row = 1:m
        for col = 1:n
            curind = sub2ind([m, n], row, col);

            east = [row, col + 1];
            west = [row, col - 1];
            sourth = [row + 1, col];
            north = [row - 1, col];
            eastsourth = [row + 1, col + 1];
            eastnorth = [row - 1, col + 1];
            westsourth = [row + 1, col - 1];
            westnorth = [row - 1, col - 1];
            dirs = [east; west; sourth; north; eastsourth; eastnorth; westsourth; westnorth];
            neighbors = zeros(length(dirs), 1);
            for i = 1:length(dirs)
                dir = dirs(i, :);
                if validDir(dir, m, n)
                    neighbors(i) = sub2ind([m, n], dir(1), dir(2));
                end
            end
            % neighbors = neighbors(neighbors ~= 0);

            for i = 1:length(neighbors)
                next = neighbors(i);
                if next == 0
                    continue;
                end
                if bw_img(next) == 1
                    % channel
                    Edges(curind, i) = 1;
                elseif bw_img(next) == 0
                    % stones boundary
                    Edges(curind, i) = inf;
                else
                    % error
                    ; %#ok<NOSEMI>
                end
            end
        end
    end
end