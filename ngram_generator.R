pacman::p_load(
  tidyverse,
  readr,
  tidytext
)

# Set the N for N-grams
N = 2

#Clean the text after saving.
text <- read_file("output.txt") |>
  strsplit( split = "\r\n")

# Place into a dataframe
text <- text[[1]] |>
  tibble()
colnames(text) = "text"

# Tokenize the words in the text into ngrams
unigrams <- text |>
  unnest_tokens(words, text, token = "words", to_lower = FALSE) |>
  count(words)

# Tokenize the words in the text into ngrams
n_grams <- text |>
  unnest_tokens(ngrams, text, token = "ngrams", n = N, to_lower = FALSE) |>
  count(ngrams)

# Seperate the individual words.
seps <- strsplit(as.character(n_grams$ngrams), split = " ") |>
  as.data.frame() |>
  t() |>
  as.data.frame()
rownames(seps) <- c(1:dim(n_grams)[1])
colnames(seps)[dim(seps)[2]] <- "final"

# Output the data frame
n_grams <- tibble(n_grams, seps)

# Add the counters of the final words.
n_grams <- left_join(
  n_grams,
  unigrams,
  by = join_by(
    final == words
  )
)
n_grams <- n_grams |>
  add_column(
    final_word = n_grams$final,
    .after = 2 + N
  ) |>
  add_column(
    id = 1:dim(n_grams)[1],
    .before = 1
  )

colnames(n_grams) <- c(
  "id",
  paste(N, "_gram", sep = ""),
  paste("num_", N, "_gram", sep = ""),
  c(
    paste("word_", 1:N)
  ),
  "final_word",
  "num_final_word"
)


write_csv(n_grams, "output_ngrams.csv")

