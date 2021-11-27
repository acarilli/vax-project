library(tidyverse)

demographics <-
  here::here("data",
             "social-capital-project-social-capital-index-data .xlsx") %>%
  readxl::read_xlsx(sheet = "County Benchmarks", skip = 2) %>%
  janitor::clean_names() %>%
  select(-c(
    starts_with("x"),
    alt_fips_code,
    contains("county"),
    state,
    contains("state_abbreviation")
  )) %>% 
  rename(fips = fips_code)

county_index <-
  here::here("data",
             "social-capital-project-social-capital-index-data .xlsx") %>%
  readxl::read_xlsx(sheet = "County Index", skip = 2) %>%
  janitor::clean_names() %>%
  select(
    fips = fips_code,
    county_level_index,
    family_unity,
    community_health,
    institutional_health,
    collective_efficacy
  )

restrictions <- 
  here::here("data", "restriction_days.csv") %>% 
  read_csv() %>% 
  mutate(stringency = rowSums(across(where(is.numeric))))

vax <- 
  here::here("data", "vax-data.csv") %>% 
  read_csv()

rep_pres <- 
  here::here("data", "republican_president.csv") %>% 
  read_csv()

penn_state <- 
  here::here("data", "penn-state-social-k.csv") %>% 
  read_csv()

data <- 
  vax %>% 
  right_join(restrictions) %>% 
  right_join(county_index) %>% 
  right_join(demographics) %>% 
  right_join(rep_pres) %>% 
  right_join(penn_state)

write_csv(data, "data/vax-data.csv")