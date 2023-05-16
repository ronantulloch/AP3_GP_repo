pacman::p_load(
  tidyverse,
  readr,
  tidytext,
  strex
)

# Set the N for N-grams
N <- 3

#Clean the text after saving.
text <- read_file("R_Outputs/output.txt") |>
  gsub(
    pattern = "\r\r\n", replacement = "\r\n " #Remove the double newline characters
  ) |>
  strsplit( split = "\r\n")

# Place into a dataframe
text <- text[[1]] |>
  trimws() |>
  tibble()
colnames(text) = "text"
text$poem_length <- str_count(text$text, pattern = "ENDLINE NEWLINE") + 1
text$n_gram <- str_before_nth(text$text, pattern = " ", N + 1)

# Tokenize the words in the text into (n-1)grams
prev_ngrams <- text |>
  unnest_tokens(ngrams, text, token = "ngrams", n = N - 1, to_lower = FALSE) |>
  count(ngrams)

# Tokenize the words in the text into ngrams
n_grams <- text |>
  unnest_tokens(ngrams, text, token = "ngrams", n = N, to_lower = FALSE) |>
  count(ngrams)

# Seperate the individual words.
seps <- strsplit(as.character(n_grams$ngrams), " ") |>
  as.data.frame() |>
  t() |>
  as.data.frame()
rownames(seps) <- c(1:dim(n_grams)[1])
colnames(seps)[dim(seps)[2]] <- "final"

# Get the first/last (n-1)gram and final word.
if (N != 2) {
  start_ngrams <- unite(seps[, 1:(dim(seps)[2] - 1)], col = "start", sep = " ")
  end_ngrams <- unite(seps[, 2:(dim(seps)[2])], col = "final", sep = " ")
} else{
  start_ngrams <- seps[,1] |> tibble()
  end_ngrams <- seps[,2] |> tibble()
}

# Group the data frame.
n_grams <- tibble(n_grams, start_ngrams, end_ngrams, final_word = seps$final)
colnames(n_grams)[dim(n_grams)[2] - 1] <- "final"

# Add the counters of the final words.
n_grams <- left_join(
  n_grams,
  prev_ngrams,
  by = join_by(
    final == ngrams
  )
)

colnames(n_grams) <- c(
  paste(N, "_gram", sep = ""),
  paste("num_", N, "_gram", sep = ""),
  "start_ngram",
  "end_ngram",
  "final word",
  "num_end_ngram"
)

write_csv(n_grams, "R_outputs/output_ngrams.csv")

