# This script will clean the text from the chosen poems.

pacman::p_load(
  tidyverse,
  readr,
  tm,
  tidytext
)

text <- read_file("Raw_Text/Sylvia Plath Poems - Small.txt") |>
  gsub(
    pattern = "\r\n\r\n", replacement = "\r\n " #Remove the double newline characters
  ) |>
  gsub(
    pattern = "\r\n", replacement = "ENDLINE\r\nNEWLINE" #Remove the double newline characters
  ) |>
  gsub(
    pattern = "ENDLINE\r\nNEWLINE@ENDLINE\r\nNEWLINE", replacement = "FINAL\r\nSTART" #Remove the double newline characters
  ) |>
  removePunctuation(
    preserve_intra_word_contractions = TRUE,
    preserve_intra_word_dashes = TRUE,
    ucp = TRUE
  ) |> #Remove the punctuation
  gsub(
    pattern = "  ", replacement = "" # Remove the tabs
  ) |>
  gsub(
    pattern = "START", replacement = "!" #Add starting states.
  ) |>
  gsub(
    pattern = "NEWLINE", replacement = "@" #Add starting states.
  ) |>
  gsub(
    pattern = "ENDLINE", replacement = "#" #Add starting states.
  ) |>
  gsub(
    pattern = "FINAL", replacement = "%" #Add starting states.
  ) |>
  removeNumbers() |> # Remove the numbers
  tolower()  |>
  gsub(
    pattern = "!", replacement = "START " #Add starting states.
  ) |>
  gsub(
    pattern = "@", replacement = "NEWLINE " #Add starting states.
  ) |>
  gsub(
    pattern = "#", replacement = " ENDLINE" #Add starting states.
  ) |>
  gsub(
    pattern = "%", replacement = " FINAL" #Add starting states.
  ) |>
  gsub(
    pattern = "  ", replacement = " " #Add starting states.
  )


text <- paste("START", text, "FINAL")


writeLines(text, con = "output.txt", sep = " ")
