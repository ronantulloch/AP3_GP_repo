% This file will use the stochastic matrix generated as a csv and will use
% it to generate text.

ngrams = load("ngrams.mat"); ngrams = ngrams.ngrams;
P = load("P.mat"); P = P.P;
p_0 = load("p_0.mat"); p_0 = p_0.p_0;

N = length(p_0);
rng("shuffle")

ngrams{N, 1} = N;
ngrams{N, 2} = 'ENDLINE NEWLINE';
ngrams{N, 4} = 'ENDLINE';
ngrams{N, end - 1} = 'NEWLINE';


% Initialsise the prhrase to be generated.
phrase = "";
starting_word_index = randsample(N, 1, true, p_0);
starting_phrase =  string(ngrams{starting_word_index, 1});
phrase = phrase + starting_phrase;
final = false;
old_word_index = starting_word_index;
while final == false
	
	new_word_index = randsample(N, 1, true, P(old_word_index, :));
	new_word = string(ngrams{new_word_index, 5});
	
	current_final_ngram = string(ngrams{new_word_index, 4});

	if contains(current_final_ngram, "FINAL")
		final = true;
		phrase = phrase + " FINAL\n";
	else
		phrase = phrase + " " + new_word;
	end
	
	old_word_index = new_word_index;

end

% Clean up the text.
phrase = replace(phrase, " ENDLINE NEWLINE ", "\n");
phrase = replace(phrase, "ENDLINE NEWLINE", "");
phrase = replace(phrase, "NEWLINE", "");
phrase = replace(phrase, "  ", " ");
phrase = replace(phrase, "START ", "");
phrase = replace(phrase, " FINAL", ".");
clc
fprintf(phrase)