function valid = validDir(dir, m, n)
	valid = ~(dir(1) < 1 | dir(1) > m | dir(2) < 1 | dir(2) > n);
end