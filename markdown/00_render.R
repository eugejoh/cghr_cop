
# Render Xaringan Presentations -------------------------------------------

library(here)
library(rmarkdown)

rmarkdown::render(input = here::here("markdown", "first_meeting_20190502.Rmd"))

file.copy(
  from = list.files(here::here("markdown"), pattern = "20190502.*\\.html$", full.names = TRUE),
  to = here::here("slides")
          )
