pacman::p_load(
  tidyverse,
  readr,
  tidytext,
  strex
)

# Set the N for the n-gram
N <- 3

# Input the cleaned output file and do some minor adjustments before separating the lines
text <- read_file("R_Outputs/output.txt") |>
  str_replace_all(pattern = "\r\r\n", replacement = " ") |>
  str_replace_all(pattern = "ENDLINE NEWLINE",
                  replacement = "ENDLINE ENDLINE NEWLINE NEWLINE") |>
  str_replace_all(pattern = "FINAL START",
                  replacement = "FINAL ENDLINE NEWLINE START") |>
  str_replace_all(pattern = "\r\n", replacement = " ") |>
  strsplit( split = "ENDLINE NEWLINE")



new_text <- text[[1]] |>
  str_trim() |>
  tibble()
colnames(new_text) <- ("text")

new_text$line_length <- new_text$text |>
  str_replace(pattern = "NEWLINE ", replacement = "") |>
  str_replace(pattern = " ENDLINE", replacement = "") |>
  str_replace(pattern = "START ", replacement = "") |>
  str_replace(pattern = " FINAL", replacement = "") |>
  str_count(pattern = " ")

new_text$n_gram <- str_before_nth(new_text$text, pattern = " ", N)
new_text$line_id <- 0

counter = 1
for(i in 1:length(new_text$line_id)){
  new_text$line_id[i] <- counter

  if(str_detect(new_text$text[i], "FINAL")){
    counter = 1
  } else{
    counter = counter + 1
  }
}

length_per_row_id <- new_text |>
  select(
    line_id,
    line_length
  ) |>
  group_by(line_id) |>
  summarise(
    line_length = round(mean(line_length))
  )

line_lengths <- new_text |>
  filter(
    str_detect(n_gram, "START") | str_detect(n_gram, "NEWLINE")
  ) |>
  select(
    ngram = n_gram,
    line_length
  ) |>
  group_by(ngram) |>
  summarise(
    mean(line_length)
  )
colnames(line_lengths) <- c("ngram", "line_length")

line_lengths$line_length <- round(line_lengths$line_length)

write_csv(length_per_row_id, "R_outputs/id_length.csv")
write_csv(new_text, "R_outputs/total_line_lengths.csv")
write_csv(line_lengths, "R_outputs/mean_line_lengths.csv")

