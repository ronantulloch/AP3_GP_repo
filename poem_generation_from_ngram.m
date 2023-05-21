% This file will use the stochastic matrix generated as a csv and will use
% it to generate text.
clc;

% Load the stochastic matrices
ngrams = load("Matlab_Outputs/ngrams.mat"); ngrams = ngrams.ngrams;
P = load("Matlab_Outputs/P.mat"); P = P.P;
p_0 = load("Matlab_Outputs/p_0.mat"); p_0 = p_0.p_0;

% Get the previously computed line length and syllable counts.
expected_line_length = readcell("R_Outputs\mean_line_lengths.csv");
expected_line_length = string(expected_line_length(2:end, :));
mean_syllables = load("Matlab_Outputs/syllables.mat", "lengths");
mean_syllables = string(mean_syllables.lengths);

% the n for n-grams, we will default to tri-grams.
n = 3;

% Some endline setup states
N = length(p_0);
rng("shuffle")
ngrams{N, 1} = N;
ngrams{N, 2} = 'ENDLINE NEWLINE';
ngrams{N, 4} = 'ENDLINE';
ngrams{N, end - 1} = 'NEWLINE';


% Initialsise the phrase to be generated.
starting_word_index = randsample(N, 1, true, p_0);
starting_phrase =  string(ngrams{starting_word_index, 1});
phrase = starting_phrase;
phrase_words = split(starting_phrase)';
total_phrase = "";
final = false;
old_word_index = starting_word_index;

% start the generation process
while final == false
	is_valid = false;
	while is_valid == false
		new_word_index = randsample(N, 1, true, P(old_word_index, :));
		new_word = string(ngrams{new_word_index, 5});

		current_final_ngram = string(ngrams{new_word_index, 4});
		phrase_words = [phrase_words, new_word];

		if contains(current_final_ngram, "FINAL")
			is_valid = true;
			final = true;
			phrase = phrase + " ENDLINEFINAL\n";
		else
			phrase = phrase + " " + new_word;
		end

		old_word_index = new_word_index;

		if contains(phrase, "ENDLINE")
			ngram = phrase_words(1) + " " + phrase_words(2) ...
				+ " "  + phrase_words(3);

			mean_line_length = double(expected_line_length(expected_line_length(:,1) == ngram, 2));
			if isempty(mean_line_length)
				mean_line_length = mean(double(expected_line_length(:,2)));
			elseif length(mean_line_length) > 1
				mean_line_length = mean(mean_line_length);
			end
			current_line_length = count(phrase, " ") - 2;

			if contains(phrase, "START")
				current_syllables = syllabals(phrase) - 3;
			elseif contains(phrase, "FINAL")
				current_syllables = syllabals(phrase) - 3;
			else
				current_syllables = syllabals(phrase) - 4;
			end

			mean_line_syllables = double(mean_syllables(mean_syllables(:,3) == ngram, 5))';
			if isempty(mean_line_syllables)
				mean_line_syllables = mean(double(mean_syllables(:,3)));
			elseif length(mean_line_syllables) > 1
				mean_line_syllables = mean(mean_line_syllables);
			end

			if (current_line_length <= mean_line_length + 2) && ...
					(current_line_length >= mean_line_length - 2) && ...
					(current_syllables <= mean_line_syllables + 2) && ...
					(current_syllables >= mean_line_syllables - 2)
				total_phrase = total_phrase + " " +  strtrim(phrase);
				phrase_words = [];
				is_valid = true;
				phrase = "";
			else
				phrase = ngram;
				phrase_words = phrase_words(1:3);
				final_phrase = phrase_words(end-2) + " " + phrase_words(end-1) + ...
					" " + phrase_words(end);
				old_word_index = find(string(ngrams(:,1)) == final_phrase);
			end
		end
	end
end

phrase = total_phrase;
% Clean up the text.
phrase = replace(phrase, " ENDLINE NEWLINE ", "\n");
phrase = replace(phrase, " START ", "");
phrase = replace(phrase, "ENDLINEFINAL", "\n");
phrase = replace(phrase, "ENDLINE", "");
phrase = replace(phrase, " i ", " I ");

fprintf(phrase)
