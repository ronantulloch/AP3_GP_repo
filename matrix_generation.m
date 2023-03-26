% Read in the ngrams data frame
ngrams = readcell("output_ngrams.csv");
ngrams = ngrams(2:end, :); %Remove the headers that aren't needed

% Get the number of ngrams.
N = size(ngrams, 1);

% Get the reference text
ref_text = fileread("output.txt");

% Initialise the transition matrix.
P = zeros(N);

for row = 1:N
	for col = 1:N
		% Get the count of the next ngram and the first word of the ngram.
		next_ngram_count = ngrams{col, 3};
		next_ngram_first = string(ngrams{col, 4});

		% Get the last of the next ngram and the count of the last of the
		% next ngram.
		current_ngram_last = string(ngrams{row, end - 1});
		current_ngram_last_count = ngrams{row, end};

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
p_0 = zeros(1, N);
count_newline = 0;
count_start = 0;

% Calculate column transitions.
for row = 1:N
	if sum(P(row, :)) ~= 1
		end_new_col(row) = 1;
	end

	if  string(ngrams{row, 4}) == "NEWLINE"
		count_newline = count_newline +1;
	end

	if  string(ngrams{row, 4}) == "START"
		count_start = count_start +1;
	end
	
end

% Calculate row transitions
for row = 1:N
	if string(ngrams{row, 4}) == "NEWLINE"
		end_new_row(row) = ngrams{row, 3}/count_newline;
	end

	if string(ngrams{row, 4}) == "START"
		p_0(row) = ngrams{row, 3}/count_start;
	end
end

% Add these values to P
P = [P ; end_new_row]; P = [P, end_new_col];


writematrix(P, "P.csv")