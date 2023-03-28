% Read in the ngrams data frame
ngrams = readcell("output_ngrams.csv");
ngrams = ngrams(2:end, :); %Remove the headers that aren't needed

% Get the number of ngrams.
N = size(ngrams, 1);

% Initialise the transition matrix.
P = zeros(N);

for row = 1:N
	for col = 1:N
		% Get the count of the next ngram and the first word of the ngram.
		next_ngram_count = ngrams{col, 2};
		next_ngram_first = string(ngrams{col, 3});

		% Get the last of the next ngram and the count of the last of the
		% next ngram.
		current_ngram_last = string(ngrams{row, 4});
		current_ngram_last_count = ngrams{row, 6};

		% If the ngrams are related then calculate the probability.
		if next_ngram_first == current_ngram_last
			P(row, col) = next_ngram_count/current_ngram_last_count;
		end
	end
end

% Add the endline to newline transitions and calculate the initial
% distribution.
end_new_col = zeros(N+1, 1);
end_new_row = zeros(1, N);
p_0 = zeros(1, N );
count_newline = 0;
count_start = 0;

% Calculate column transitions.
for row = 1:N
	% if round(sum(P(row, :)), 15) ~= 1
	% 	end_new_col(row) = 1;
	% end
	% 
	% if contains(string(ngrams{row, 3}), "NEWLINE")
	% 	count_newline = count_newline + ngrams{row, 2};
	% end

	if contains(string(ngrams{row, 3}), "START")
		count_start = count_start + ngrams{row, 2};
	end
	
end

% Calculate row transitions
for row = 1:N
	% if contains(string(ngrams{row, 3}), "NEWLINE")
	% 	end_new_row(row) = ngrams{row, 2}/count_newline;
	% end

	if contains(string(ngrams{row, 3}), "START")
		p_0(row) = ngrams{row, 2}/count_start;
	end
end

% Add these values to P
% P = [P ; end_new_row]; P = [P, end_new_col];

save("ngrams.mat", "ngrams")
save("P.mat", "P")
save("p_0.mat", "p_0")