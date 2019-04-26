
# Render Xaringan Presentations -------------------------------------------

library(here)
library(rmarkdown)
memes <- TRUE
# render markdown presentation
rmarkdown::render(input = here::here("markdown", "first_meeting_20190502.Rmd"), 
                  params = list(memes=memes, ani=FALSE))

# move file to slides
if (!memes) {
  file.copy(
    from = list.files(here::here("markdown"), pattern = "20190502.*\\.html$", full.names = TRUE),
    to = here::here("docs", "slides"),
    overwrite = TRUE
  )
}

