## read in all the data stuff
# experiment 1 imports
transcript_1 <- read_csv(here(expt_1, "timed_transcript.csv"))
dat_1 <- read_csv(here(expt_1, "clean_data.csv")) |> rename(trial = trialNum)
exclusion_1 <- transcript_1 %>%
  filter(!is.na(description)) %>%
  filter(role == "S") %>%
  select(game, trial) %>%
  unique() %>%
  mutate("S_talked" = 1)

words_1 <- transcript_1 |>
  filter(!is.na(description)) |>
  mutate(words = description |> str_count("\\S+")) |>
  filter(role == "S") |>
  group_by(game, trial) |>
  summarize(words = sum(words))

clean_1 <- dat_1 %>%
  left_join(exclusion_1) %>%
  filter(S_talked == 1) |>
  left_join(words_1) |>
  mutate(type = case_when(
    trial < 2 ~ "practice",
    trial < 6 ~ "block 1",
    trial < 10 ~ "block 2",
    trial < 14 ~ "block 3"
  ))


sims_1 <- read_rds(here(expt_1, "similarities.rds")) |>
  as_tibble() |>
  inner_join(clean_1 |> select(game1 = game, trial1 = trial, target1 = target, speaker1 = speaker)) |>
  inner_join(clean_1 |> select(game2 = game, trial2 = trial, target2 = target, speaker2 = speaker)) |>
  filter(target1 == target2) |>
  filter(trial1 > 1) |>
  filter(trial2 > 1) |>
  mutate(
    trial1 = trial1 + 2,
    trial2 = trial2 + 2
  ) |>
  mutate(block1 = trial1 %/% 4, block2 = trial2 %/% 4) |>
  mutate(
    same_speaker = (speaker1 == speaker2) |> as.numeric(),
    same_game = (game1 == game2) |> as.numeric(),
    later = ifelse(block1 > block2, block1, block2),
    earlier = ifelse(block1 > block2, block2, block1)
  ) |>
  mutate(target = target1)


# expt 2 imports
transcript_2 <- read_csv(here(expt_2, "transcripts.csv"))
link <- read_csv(here(expt_2, "link_transcripts.csv"))

exclude_2 <- transcript_2 |>
  filter(!is.na(echo)) |>
  select(gameId, trial)

data_2 <- read_csv(here(expt_2, "clean_data.csv")) |>
  rename(trial = trialNum) |>
  anti_join(exclude_2)

transcript_2 <- transcript_2 |>
  anti_join(exclude_2) |>
  filter(!is.na(description))

words_2 <- transcript_2 |>
  mutate(words = description |> str_count("\\S+")) |>
  filter(role == "S") |>
  group_by(gameId, gameConfig, trial) |>
  summarize(words = sum(words))

clean_2 <- data_2 |>
  left_join(words_2) |>
  filter(!is.na(words)) |>
  mutate(type = case_when(
    trial < 4 ~ "practice",
    trial < 8 ~ "block 1",
    trial < 12 ~ "block 2",
    trial < 16 ~ "block 3",
    trial < 20 ~ "block 4"
  )) |>
  filter(!is.na(response)) |>
  mutate(correct = as.numeric(correct))

sims_2 <- read_rds(here(expt_2, "similarities.rds")) |>
  as_tibble() |>
  inner_join(clean_2 |> select(game1 = gameId, trial1 = trial, target1 = target, speaker1 = speaker)) |>
  inner_join(clean_2 |> select(game2 = gameId, trial2 = trial, target2 = target, speaker2 = speaker)) |>
  filter(target1 == target2) |>
  mutate(block1 = trial1 %/% 4, block2 = trial2 %/% 4) |>
  mutate(
    same_speaker = (speaker1 == speaker2) |> as.numeric(),
    same_game = (game1 == game2) |> as.numeric(),
    later = ifelse(block1 > block2, block1, block2),
    earlier = ifelse(block1 > block2, block2, block1)
  ) |>
  mutate(target = target1)

# demographics file has sensitive info
# demo <- read_csv(here("demographics.csv")) |>
#   filter(included == "x") |>
#   mutate(date_test = mdy(date_test), date_birth = mdy(date_birth)) |>
#   select(date_test, date_birth, gender) |>
#   mutate(
#     age = date_test - date_birth,
#     age = as.numeric(age) / 365.25 * 12
#   ) |>
#   mutate(expt=ifelse(date_test>ymd("2024-01-01"), "expt2", "expt1")) |>
#   group_by(expt) |>
#   summarize(female=sum(gender=="female"),
#             total=n(),
#             median=median(age),
#             min=min(age),
#             max=max(age))




### functions for printing things nicely!
stats <- function(model, row, decimal = 2) {
  model <- model |>
    mutate(
      Estimate = round(Estimate, digits = decimal),
      Lower = round(lower, digits = decimal),
      Upper = round(upper, digits = decimal),
      `Credible Interval` = str_c("[", Lower, ", ", Upper, "]")
    ) |>
    select(Term, Estimate, `Credible Interval`)
  str_c(model[row, 1], ": ", model[row, 2], " ", model[row, 3])
}

stats_text <- function(model, row, decimal = 2) {
  model <- model |>
    mutate(
      Estimate = round(Estimate, digits = decimal) |> formatC(format = "f", digits = decimal),
      Lower = round(lower, digits = decimal) |> formatC(format = "f", digits = decimal),
      Upper = round(upper, digits = decimal) |> formatC(format = "f", digits = decimal),
      `Credible Interval` = str_c("[", Lower, ", ", Upper, "]")
    ) |>
    select(Term, Estimate, `Credible Interval`)
  str_c(model[row, 2], "  ", model[row, 3])
}

form <- function(model_form) {
  dep <- as.character(model_form$formula[2])
  ind <- as.character(model_form$formula[3])

  str_c(dep, " ~ ", ind) |>
    str_replace_all(" ", "") |>
    str_replace_all("\\*", " $\\\\times$ ") |>
    str_replace_all("\\+", "&nbsp;+ ") |>
    str_replace_all("~", "$\\\\sim$ ")
}
