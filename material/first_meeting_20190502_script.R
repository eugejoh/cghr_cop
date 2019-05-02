
# R Script for CGHR R Tutorial CoP ----------------------------------------
# Eugene Joh
# 2019-04-26
# R version 3.5.1 (2018-07-02)

# you can use hash or pound symbol to comment code

# Data: WHO Global Health Repository
# Link: http://apps.who.int/gho/data/node.main.A1367?lang=en (accessed April 12, 2019)

# Research Question:
# What are the national trends in malaria deaths that are reported to the WHO 
#  from 2007 to 2017 in Sierra Leone, Mozambique, Ethiopia, and India?  

# Load Packages
# eg use install.packages("dplyr") to install "dplyr" package (if not already)
library(here) #0.1.0
library(readr) #1.3.1
library(dplyr) #0.7.8
library(tidyr) #0.8.1
library(ggplot2) #3.1.0
library(scales) # 1.0.0
library(gganimate) #1.0.0
# fyi no breaking changes with most recent versions of packages

# Data Import -------------------------------------------------------------
file_name <- "MALARIA001"

the_file <- list.files(path = here::here("data"), 
                       pattern = paste0(file_name, "\\.csv"),
                       full.names = TRUE)
# if not using RStudio or here package, use setwd() to set working directory then run:
# the_file <- list.files(path = file.path(getwd(), "data"), 
#                        pattern = paste0(file_name, "\\.csv"),
#                        full.names = TRUE)

the_file

my_data <- readr::read_csv(file = the_file, skip = 1)

head(my_data, 5)
dim(my_data)


# Data Processing ---------------------------------------------------------
# 1. Gather wide to long format
l_data <- gather(my_data, "Year", "Deaths", -"Country")

head(l_data, 3) #sanity check 1
dim(l_data) #old dim() was 105 19

# 2. Specify Data Types
head(l_data, 3)
l_data <- mutate(l_data, Year = as.numeric(Year))
head(l_data, 3)

# 3. Filter Years
range(l_data$Year) #range of years
l_data <- filter(l_data, Year >= 2007)
range(l_data$Year) #sanity check 2

# 4. Filter Countries
filter(l_data, Country == "Sierra Leone" & Country == "Mozambique" & 
         Country == "Ethiopia" & Country == "India")

my_countries <- c("Sierra Leone", "Mozambique", "Ethiopia", "India")
l_data <- filter(l_data, Country %in% my_countries)

# Chaining Steps
l_data_pipe <- my_data %>% 
  gather("Year", "Deaths", -"Country") %>% 
  mutate(Year = as.numeric(Year)) %>% 
  filter(Year >= 2007) %>% 
  filter(Country %in% my_countries)

identical(l_data, l_data_pipe)



# Communicate/Data Viz ----------------------------------------------------
p1 <- l_data %>% 
  ggplot(aes(x = Year, y = Deaths, colour = Country)) +
  geom_point() +
  geom_line(size = 1.2, alpha = 0.9) +
  scale_x_continuous(breaks = c(2007:2017)) +
  scale_y_continuous(breaks = scales::pretty_breaks(8)) +
  coord_cartesian(ylim = c(0, 8200)) +
  labs(title = "Reported Malaria Deaths from 2007 to 2017",
       caption = "Data: WHO Global Health Repository") +
  scale_color_brewer(type = "qual", palette = 2, direction = -1, name = NULL) +
  theme_classic(base_size = 18, base_line_size = 1) +
  theme(legend.text = element_text(size = 16),
        panel.grid.major = element_line(colour = "grey80", size = 0.1))

p1 #show plot

# chaining from file path to data viz (not in presentation)
p2 <- the_file %>% 
  read_csv(skip = 1) %>%
  gather("Year", "Deaths", -"Country") %>% 
  mutate(Year = as.numeric(Year)) %>% 
  filter(Year >= 2007) %>% 
  filter(Country %in% my_countries) %>% 
  ggplot(aes(x = Year, y = Deaths, colour = Country)) +
  geom_point() +
  geom_line(size = 1.2, alpha = 0.9) +
  scale_x_continuous(breaks = c(2007:2017)) +
  scale_y_continuous(breaks = scales::pretty_breaks(8)) +
  coord_cartesian(ylim = c(0, 8200)) +
  labs(title = "Reported Malaria Deaths from 2007 to 2017",
       caption = "Data: WHO Global Health Repository") +
  scale_color_brewer(type = "qual", palette = 2, direction = -1, name = NULL) +
  theme_classic(base_size = 18, base_line_size = 1) +
  theme(legend.text = element_text(size = 16),
        panel.grid.major = element_line(colour = "grey80", size = 0.1))

p2 #show plot

# animation
p <- l_data %>% 
  ggplot(aes(x = Year, y = Deaths, colour = Country, group = Country)) +
  geom_point() +
  geom_line(size = 1.2, alpha = 0.9) +
  scale_x_continuous(breaks = c(2007:2017)) +
  scale_y_continuous(breaks = scales::pretty_breaks(8)) +
  coord_cartesian(ylim = c(0, 8200)) +
  labs(title = "Reported Malaria Deaths from 2007 to 2017",
       caption = "Data: WHO Global Health Repository") +
  scale_color_brewer(type = "qual", palette = 2, direction = -1, name = NULL) +
  theme_classic(base_size = 18, base_line_size = 1) +
  theme(legend.text = element_text(size = 16),
        panel.grid.major = element_line(colour = "grey80", size = 0.1)) +
  gganimate::transition_reveal(along = Year)

# p_ani <- gganimate::animate(plot = p, width = 13*96, height = 8*96)

p_ani #show animation

