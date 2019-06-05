
# Render Xaringan Presentations -------------------------------------------

library(here)
library(rmarkdown)
memes <- FALSE

# render markdown presentation
rmarkdown::render(input = here::here("markdown", "first_meeting_20190502.Rmd"), 
                  output_file = "first_meeting_20190502.html",
                  params = list(memes=memes, ani=FALSE))

# move file to slides
if (!memes) {
  file.copy(
    from = list.files(here::here("markdown"), pattern = "first_meeting_20190502\\.html$", full.names = TRUE),
    to = here::here("docs", "slides"),
    overwrite = TRUE
  )
}

rmarkdown::render(input = here::here("markdown", "data_str_20190606.Rmd"),
                  output_file = "data_str_20190607.html",
                  params = list(memes = memes, ani = FALSE))

