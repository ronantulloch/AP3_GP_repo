pacman::p_load(
  tidyverse,
  readr,
  tidytext,
  strex
)

row_expected_vals <- read_csv("Matlab_Outputs/lengths_and_syllables.csv", col_names = FALSE)
colnames(row_expected_vals) <- c("text", "expected_word_count",
                                 "ngram", "line_id", "expected_syll")

row_expected_vals <- row_expected_vals |>
  select(
    line_id, expected_word_count, expected_syll
  ) |>
  mutate(
    line_id_2 = line_id
  ) |>
  group_by(
    line_id
  ) |>
  summarise(
    mean_syl = round(mean(expected_syll)),
    mean_line = round(mean(expected_word_count)),
    line_prob = n()/(dim(row_expected_vals)[1])
  )

write_csv(row_expected_vals, "R_outputs/row_vals.csv")

