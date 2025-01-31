
library(tidyverse)
library(here)
library(brms)
library(rstan)
library(rstanarm)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

expt_1 <- "data/expt_1"
expt_2 <- "data/expt_2"
mod_loc <- "code/models"
mod_results <- "code/models/summary"
mod_form <- "code/models/formulae"

source(here("code/paper_helper.R"))

### accuracy expt 1

acc_priors <- c(
  set_prior("normal(0,1)", class = "b"),
  set_prior("normal(0,1)", class = "sd"),
  set_prior("lkj(1)", class = "cor")
)

acc_mod_data_1 <- clean_1 |>
  mutate(
    correct.num = ifelse(correct == TRUE, 1, 0),
    trial.num = trial - 2
  ) |>
  filter(type != "practice")
acc_mod_1 <- brm(correct.num ~ trial.num + (trial.num | game) + (1 | target),
                 family = bernoulli(link = "logit"),
                 data = acc_mod_data_1,
                 file = here(mod_loc, "acc_1.rds"),
                 prior = acc_priors,
                 control = list(adapt_delta = .95)
)

### speed expt 1

speed_priors <- c(
  set_prior("normal(60,100)", class = "Intercept"),
  set_prior("normal(0,20)", class = "b"),
  set_prior("normal(0,20)", class = "sd"),
  set_prior("lkj(1)", class = "cor")
)

speed_mod_data_1 <- clean_1 |>
  mutate(
    time.sec = time / 1000,
    trial.num = trial - 2
  ) |>
  filter(type != "practice")

speed_mod_1 <- brm(time.sec ~ trial.num + (trial.num | game) + (1 | target),
                   data = speed_mod_data_1,
                   file = here(mod_loc, "speed_1.rds"),
                   prior = speed_priors,
                   control = list(adapt_delta = .95)
)

#### description expt 1
description_priors <- c(
  set_prior("normal(5,10)", class = "Intercept"),
  set_prior("normal(0,5)", class = "b"),
  set_prior("normal(0,5)", class = "sd"),
  set_prior("lkj(1)", class = "cor")
)

description_mod_data_1 <- clean_1 |>
  mutate(
    trial.num = trial - 2
  ) |>
  filter(type != "practice")

description_mod_1 <- brm(words ~ trial.num + (trial.num | game) + (1 | target),
                         data = description_mod_data_1,
                         file = here(mod_loc, "description_1.rds"),
                         prior = description_priors,
                         control = list(adapt_delta = .95)
)


### conv expt 1

conv_priors <- c(
  set_prior("normal(.5,.2)", class = "Intercept"),
  set_prior("normal(0,.1)", class = "b"),
  set_prior("normal(0,.05)", class = "sd")
)

sim_across_between_data_1 <- sims_1 |>
  mutate(same_game = case_when(
    game1 == game2 ~ 1,
    T ~ 0
  )) |>
  mutate(same_speaker = ifelse(speaker1 == speaker2, 1, 0))


sim_across_between_mod_1 <- brm(sim ~ same_game + same_speaker + (1 | target),
                                data = sim_across_between_data_1,
                                file = here(mod_loc, "sim_across_between_1.rds"),
                                prior = conv_priors,
                                control = list(adapt_delta = .95)
)


##### Expt 2 #######

## accuracy 
acc_priors <- c(
  set_prior("normal(0,1)", class = "b"),
  set_prior("normal(0,1)", class = "sd"),
  set_prior("lkj(1)", class = "cor")
)

acc_mod_data <- clean_2 |>
  mutate(
    correct.num = ifelse(correct == TRUE, 1, 0),
    trial.num = trial - 4
  ) |>
  filter(type != "practice")
acc_mod <- brm(correct.num ~ trial.num + (trial.num | gameId) + (1 | target),
               family = bernoulli(link = "logit"),
               data = acc_mod_data,
               file = here(mod_loc, "acc_2.rds"),
               prior = acc_priors,
               control = list(adapt_delta = .95)
)

## speed

speed_priors <- c(
  set_prior("normal(60,100)", class = "Intercept"),
  set_prior("normal(0,20)", class = "b"),
  set_prior("normal(0,20)", class = "sd"),
  set_prior("lkj(1)", class = "cor")
)

speed_mod_data_2 <- clean_2 |>
  mutate(
    time.sec = time / 1000,
    trial.num = trial - 2
  ) |>
  filter(type != "practice")

speed_mod_2 <- brm(time.sec ~ trial.num + (trial.num | gameId) + (1 | target),
                   data = speed_mod_data_2,
                   file = here(mod_loc, "speed_2.rds"),
                   prior = speed_priors,
                   control = list(adapt_delta = .95)
)

## description
description_priors <- c(
  set_prior("normal(5,10)", class = "Intercept"),
  set_prior("normal(0,5)", class = "b"),
  set_prior("normal(0,5)", class = "sd"),
  set_prior("lkj(1)", class = "cor")
)

description_mod_data_2 <- clean_2 |>
  mutate(
    trial.num = trial - 2
  ) |>
  filter(type != "practice")

description_mod_2 <- brm(words ~ trial.num + (trial.num | gameId) + (1 | target),
                         data = description_mod_data_2,
                         file = here(mod_loc, "description_2.rds"),
                         prior = description_priors,
                         control = list(adapt_delta = .95)
)

## convergence 

conv_priors <- c(
  set_prior("normal(.5,.2)", class = "Intercept"),
  set_prior("normal(0,.1)", class = "b"),
  set_prior("normal(0,.05)", class = "sd")
)

sim_across_between_data_2 <- sims_2 |>
  mutate(same_game = case_when(
    game1 == game2 ~ 1,
    T ~ 0
  )) |>
  mutate(same_speaker = ifelse(speaker1 == speaker2, 1, 0))


sim_across_between_mod_2 <- brm(sim ~ same_game + same_speaker + (1 | target),
                                data = sim_across_between_data_2,
                                file = here(mod_loc, "sim_across_between_2.rds"),
                                prior = conv_priors,
                                control = list(adapt_delta = .95)
)

sim_to_last_data_2 <- sims_2 |>
  filter(game1 == game2) |>
  mutate(later = ifelse(block1 > block2, block1, block2), earlier = ifelse(block1 > block2, block2, block1)) |>
  filter(later == 4) |>
  mutate(
    same_speaker = ifelse(speaker1 == speaker2, 1, 0),
    earlier_block.num = earlier - 1
  )

sim_to_last_mod_2 <- brm(sim ~ earlier_block.num + same_speaker + (1 | game1) + (1 | target),
                         data = sim_to_last_data_2,
                         file = here(mod_loc, "sim_to_last_2.rds"),
                         prior = conv_priors,
                         control = list(adapt_delta = .95)
)

sim_to_next_data_2 <- sims_2 |>
  filter(game1 == game2) |>
  mutate(later = ifelse(block1 > block2, block1, block2), earlier = ifelse(block1 > block2, block2, block1)) |>
  filter(later == earlier + 1) |>
  mutate(
    same_speaker = ifelse(speaker1 == speaker2, 1, 0),
    earlier_block.num = earlier - 1
  )

sim_to_next_mod_2 <- brm(sim ~ earlier_block.num + same_speaker + (1 | game1) + (1 | target),
                         data = sim_to_next_data_2,
                         file = here(mod_loc, "sim_to_next_2.rds"),
                         prior = conv_priors,
                         control = list(adapt_delta = .95)
)

sim_across_data_2 <- sims_2 |>
  filter(game1 != game2) |>
  filter(block1 == block2) |>
  mutate(block.num = block1 - 1)

sim_across_mod_2 <- brm(sim ~ block.num + (1 | target),
                        data = sim_across_data_2,
                        file = here(mod_loc, "sim_across_2.rds"),
                        prior = conv_priors,
                        control = list(adapt_delta = .95)
)


### joint across expts

acc_priors <- c(
  set_prior("normal(0,1)", class = "b"),
  set_prior("normal(0,1)", class = "sd"),
  set_prior("lkj(1)", class = "cor")
)


acc_mod_data_meta <-  clean_1 |>
  mutate(
    correct.num = ifelse(correct == TRUE, 1, 0),
    trial.num = trial - 2,
    expt="expt1"
  ) |>
  filter(type != "practice") |> mutate(gameId=game) |> bind_rows(clean_2 |>
                                                                   mutate(
                                                                     correct.num = ifelse(correct == TRUE, 1, 0),
                                                                     trial.num = trial - 4,
                                                                     expt="expt2"
                                                                   ) |>
                                                                   filter(type != "practice"))

# acc_mod_data_meta |> summarize(m=mean(correct.num))

acc_mod_both <- brm(correct.num ~ trial.num + (trial.num | gameId) + (1 | target) + (1|expt),
                    family = bernoulli(link = "logit"),
                    data = acc_mod_data_meta,
                    file = here(mod_loc, "acc_meta.rds"),
                    prior = acc_priors,
                    control = list(adapt_delta = .95)
)

description_priors <- c(
  set_prior("normal(5,10)", class = "Intercept"),
  set_prior("normal(0,5)", class = "b"),
  set_prior("normal(0,5)", class = "sd"),
  set_prior("lkj(1)", class = "cor")
)

description_mod_data_meta <- clean_1 |>
  mutate(
    trial.num = trial - 2,
    expt="expt1"
  ) |>
  filter(type != "practice")|> mutate(gameId=game) |> bind_rows(
    clean_2 |>
      mutate(
        trial.num = trial - 2,
        expt="expt2"
      ) |>
      filter(type != "practice"))

description_mod_meta <- brm(words ~ trial.num + (trial.num | gameId) + (1 | target) + (1|expt),
                            data = description_mod_data_meta,
                            file = here(mod_loc, "description_meta.rds"),
                            prior = description_priors,
                            control = list(adapt_delta = .95)
)

conv_priors <- c(
  set_prior("normal(.5,.2)", class = "Intercept"),
  set_prior("normal(0,.1)", class = "b"),
  set_prior("normal(0,.05)", class = "sd")
)

sim_across_between_data_2 <- sims_2 |>
  mutate(same_game = case_when(
    game1 == game2 ~ 1,
    T ~ 0
  )) |>
  mutate(same_speaker = ifelse(speaker1 == speaker2, 1, 0)) |> 
  mutate(expt="expt2")

sim_across_between_data_1 <- sims_1 |>
  mutate(same_game = case_when(
    game1 == game2 ~ 1,
    T ~ 0
  )) |>
  mutate(same_speaker = ifelse(speaker1 == speaker2, 1, 0)) |> 
  mutate(expt="expt1")

sim_across_between_data_meta <- sim_across_between_data_2 |> bind_rows(sim_across_between_data_1)

sim_across_between_mod_meta <- brm(sim ~ same_game + same_speaker + (1 | target) + (1|expt),
                                   data = sim_across_between_data_meta,
                                   file = here(mod_loc, "sim_across_between_meta.rds"),
                                   prior = conv_priors,
                                   control = list(adapt_delta = .95)
)



sim_to_next_data_meta <- sims_2 |> mutate(expt="expt2") |> bind_rows(sims_1 |> mutate(expt="expt1")) |> 
  filter(game1 == game2) |>
  mutate(later = ifelse(block1 > block2, block1, block2), earlier = ifelse(block1 > block2, block2, block1)) |>
  filter(later == earlier + 1) |>
  mutate(
    same_speaker = ifelse(speaker1 == speaker2, 1, 0),
    earlier_block.num = earlier - 1
  )

sim_to_next_mod_meta <- brm(sim ~ earlier_block.num + same_speaker + (1 | game1) + (1 | target) + (1|expt),
                            data = sim_to_next_data_meta,
                            file = here(mod_loc, "sim_to_next_meta.rds"),
                            prior = conv_priors,
                            control = list(adapt_delta = .95)
)


### joint similarity & accuracy link


acc_sim_1 <- clean_1 |>
  filter(type != "practice") |> mutate(game1=game) |> 
  mutate(correct=ifelse(correct, 1,0),
         earlier_trial=trial+2) |> 
  select(earlier_trial, target, correct, game1) |> 
  mutate(expt="expt1")

acc_sim_2 <- clean_2 |>
  filter(type != "practice") |> select(earlier_trial=trial, target, correct, game1=gameId) |> 
  mutate(expt="expt2")

sim_acc_2 <- sims_2 |> 
  filter(game1 == game2) |>
  mutate(later = ifelse(block1 > block2, block1, block2), earlier = ifelse(block1 > block2, block2, block1)) |>
  mutate(earlier_trial = ifelse(trial1 > trial2, trial2, trial1)) |>
  filter(later == earlier + 1) |>
  mutate(
    same_speaker = ifelse(speaker1 == speaker2, 1, 0),
    earlier_block.num = earlier - 1
  ) |> 
  select(earlier_trial, target, game1, earlier, later, sim, earlier_block.num, same_speaker) |> 
  left_join(acc_sim_2)

sim_acc_1 <- sims_1 |> 
  filter(game1 == game2) |>
  mutate(later = ifelse(block1 > block2, block1, block2), earlier = ifelse(block1 > block2, block2, block1)) |>
  mutate(earlier_trial = ifelse(trial1 > trial2, trial2, trial1)) |>
  filter(later == earlier + 1) |>
  mutate(
    same_speaker = ifelse(speaker1 == speaker2, 1, 0),
    earlier_block.num = earlier - 1
  ) |> 
  select(earlier_trial, target, game1, earlier, later, sim, earlier_block.num, same_speaker) |> 
  left_join(acc_sim_1)

conv_priors <- c(
  set_prior("normal(.5,.2)", class = "Intercept"),
  set_prior("normal(0,.1)", class = "b"),
  set_prior("normal(0,.05)", class = "sd")
)
sim_acc_to_next_data <- sim_acc_1 |> bind_rows(sim_acc_2)
sim_acc_to_next_mod_meta <- brm(sim ~ earlier_block.num*correct + same_speaker*correct + (1 | game1) + (1 | target) + (1|expt),
                                data = sim_acc_to_next_data,
                                file = here(mod_loc, "sim_acc_to_next_meta.rds"),
                                prior = conv_priors,
                                control = list(adapt_delta = .95)
)

# more stickiness if correct, no clear interactions 
# being correct has a similar size effect to same speaker




### save summaries for paper 
library(tidybayes)

save_summary <- function(model) {
  intervals <- gather_draws(model, `b_.*`, regex = T) %>% mean_qi()
  
  stats <- gather_draws(model, `b_.*`, regex = T) %>%
    mutate(above_0 = ifelse(.value > 0, 1, 0)) %>%
    group_by(.variable) %>%
    summarize(pct_above_0 = mean(above_0)) %>%
    left_join(intervals, by = ".variable") %>%
    mutate(
      lower = .lower,
      upper = .upper,
      Term = str_sub(.variable, 3, -1),
      Estimate = .value
    ) %>%
    select(Term, Estimate, lower, upper)
  
  stats
}

do_model <- function(path) {
  model <- read_rds(here(mod_loc, path))
  save_summary(model) |> write_rds(here(mod_loc, "summary", path))
  model$formula |> write_rds(here(mod_loc, "formulae", path))
  print(summary(model))
}


mods <- list.files(path = here(mod_loc), pattern = ".*rds") |> walk(~ do_model(.))