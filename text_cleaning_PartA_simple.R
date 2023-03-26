# This script will clean the text from the chosen poems.

pacman::p_load(
  tidyverse,
  readr,
  tm,
  tidytext
)

text <- read_file("Raw_Text/Sylvia Plath Poems.txt") |>
  removePunctuation(ucp = TRUE) |> #Remove the punctuation
  gsub(
    pattern = "\r\n\r\n", replacement = "\r\n" #Remove the double newline characters
  ) |>
  gsub(
    pattern = "  ", replacement = "" # Remove the tabs
  ) |>
  removeNumbers() # Remove the numbers

writeLines(text, con = "output.txt")
