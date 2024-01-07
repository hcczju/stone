clc; clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 在这里修改图片参数：图片长nCols宽mRows，每个像素点编号1到mRows*nCols，
% 每个像素点之间的cost存储在Edges矩阵里
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mRows = 3; % grid height of image
% nCols = 3; % grid width of image
% % disjoint matrix of graph G, with mRows x nCols vertices
% Edges = zeros(mRows * nCols, mRows * nCols);
% % Test1
% Edges(1, 4) = inf;
% Edges(2, 5) = inf;
% Edges(6, 5) = inf;
% Edges(9, 8) = inf;
% Edges = Edges + Edges';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path = './maze.png';
[Edges, mRows, nCols] = img2edges(path);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source = [1, 1];
target = [mRows, nCols];

[dist, prev] = dijkstra(Edges, source, target, mRows, nCols);
path = shortestPath(source, target, prev);

figure;
imagesc(dist); colorbar; axis equal; axis tight; title('Cost map'); hold on;
plot(path(:,2), path(:,1), 'r', 'LineWidth', 2); hold off;

% See pseudo-code in https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
function [dist, prev] = dijkstra(Edges, source, target, m, n)
	dist = inf(m, n); % distance from source
	prev = nan(m, n);
	Q = 1:m * n; % number vertices from 1 to m x n
	dist(source) = 0;

	while ~isempty(Q)
		[~, u] = min(dist(Q)); u = Q(u);
		% uncomment this 3 lines 
		% if we are only interested in a shortest path between vertices source and target
		if u == sub2ind([m, n], target(1), target(2))
			break;
		end
		Q = Q(Q ~= u); % remove u from Q

		neighbors = Neighbor(Q, u, m, n);
		for i = 1:length(neighbors)
            v = neighbors(i); next = neighbors2ind(u, v, m, n);
			alt = dist(u) + Edges(u, next);
			if alt < dist(v)
				dist(v) = alt;
				prev(v) = u;
			end
		end
	end
end

function next = neighbors2ind(u, v, m, n)
	dirs = [
		[0, 1]; % 东
		[0, -1]; % 西
		[1, 0]; % 南
		[-1, 0]; % 北
		[1, 1]; % 东南
		[-1, 1]; % 东北
		[1, -1]; % 西南
		[-1, -1] % 西北
	];
	[row, col] = ind2sub([m, n], u); vec_u = [row, col];
    [row, col] = ind2sub([m, n], v); vec_v = [row, col];
	for i = 1:length(dirs)
		if isequal(dirs(i, :), vec_v-vec_u)
			break;
		end
	end
    next = i;
end

function neighbors = Neighbor(Q, u, m, n)
	[row, col] = ind2sub([m, n], u);
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
	neighbors = neighbors(ismember(neighbors, Q));
end

function S = shortestPath(source, target, prev)
    [m, n] = size(prev);
	S = [];
	u = target;
	% do-while is better
	while ~isequal(u, source)
		S = [u; S];
		[row, col] = ind2sub([m, n], prev(sub2ind([m, n], u(1), u(2))));
        u = [row, col];
	end
	S = [u; S];
end
