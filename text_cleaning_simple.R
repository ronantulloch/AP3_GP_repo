# This script will clean the text from the chosen poems.

pacman::p_load(
  tidyverse,
  readr,
  tm,
  tidytext
)

text <- read_file("Raw_Text_Input/Sylvia Plath Poems - Small.txt") |>
  gsub(
    pattern = "- ", replacement = "" #Remove the double newline characters
  ) |>
  gsub(
    pattern = "\r\n\r\n", 
    replacement = "\r\n " #Remove the double newline characters
  ) |>
  gsub(
    pattern = "\r\n", 
    replacement = " ENDLINE NEWLINE " #Remove the double newline characters
  ) |>
  gsub(
    pattern = "ENDLINE NEWLINE @ ENDLINE NEWLINE", 
    replacement = "FINAL\r\nSTART" #Remove the double newline characters
  ) |>
  gsub(
    pattern = "-", replacement = " " #Remove the double newline characters
  ) |>
  gsub(
    pattern = "--", replacement = " " #Remove the double newline characters
  ) |>
  removePunctuation(
    preserve_intra_word_contractions = FALSE,
    preserve_intra_word_dashes = FALSE,
    ucp = FALSE
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
  ) |>
  gsub(
    pattern = "ENDLINE NEWLINE  ENDLINE NEWLINE", 
    replacement = "ENDLINE NEWLINE" #Remove the double newline characters
  ) |>
  gsub(
    pattern = "ENDLINE NEWLINE  ENDLINE NEWLINE", 
    replacement = "ENDLINE NEWLINE" #Remove the double newline characters
  ) |>
  gsub(
    pattern = "START  ENDLINE NEWLINE", 
    replacement = "START" #Remove the double newline characters
  )


text <- paste("START", text, "FINAL")


writeLines(text, con = "R_Outputs/output.txt", sep = " ")
