# Part_1_Getting_Started.R

# Slide 7 --------------------------------------------------------

#library(tidymodels)

# Slide 12 -------------------------------------------------------

# Slide 13 -------------------------------------------------------
options(tbltools.print_tibble = FALSE)
#library(tidyverse)
library(kmw)

## read housing data
ames_prices <- "http://bit.ly/2whgsQM" %>%
  readr::read_delim(delim = "\t") %>%
  dplyr::rename_at(dplyr::vars(dplyr::contains(' ')),
    dplyr::funs(gsub(' ', '_', .))) %>%
  dplyr::rename(Sale_Price = SalePrice) %>%
  filter_data(!is.na(Electrical))
## drop these vars
ames_prices <- ames_prices[
  !names(ames_prices) %in% c("Order", "PID", "Garage_Yr_Blt")
]

## explore/descriptives
ames_prices %>%
  mutate_data(Alley = ifelse(is.na(Alley), "NA", Alley)) %>%
  group_by_data(Alley) %>%
  summarise_data(
    mean_price = mean(Sale_Price, na.rm = TRUE) / 1000,
    n = sum(!is.na(Sale_Price))
  )

ames_prices %>%
  group_by_data()

# Slide 14 -------------------------------------------------------

library(ggplot2)

ggplot(ames_prices,
  aes(x = Garage_Type, y = Sale_Price)) +
  geom_jitter(aes(fill = Garage_Type),
    color = "#00000088", size = 2.5, shape = 21) +
  coord_trans(y = "log10") +
  xlab("Garage Type") +
  ylab("Sale Price") +
  dataviz::theme_mwk() +
  theme(legend.position = "none") +
  labs(title = "House prices by garage type",
    subtitle = "Ames IA housing data (N = 2,930)")

# Slide 15 -------------------------------------------------------

library(purrr)

mini_ames <- ames_prices %>%
  select(Alley, Sale_Price, Yr_Sold) %>%
  filter(!is.na(Alley))

head(mini_ames, n = 5)

by_alley <- split(mini_ames, mini_ames$Alley)
map(by_alley, head, n = 2)

# Slide 16 -------------------------------------------------------

map(by_alley, nrow)

map_int(by_alley, nrow)

map(
  by_alley,
  ~summarise(.x, max_price = max(Sale_Price))
)

# Slide 17 -------------------------------------------------------

## use list columns
ames_lst_col <- nest(mini_ames, -Alley)
ames_lst_col

ames_lst_col %>%
  mutate(
    n_row = map_int(data, nrow),
    max   = map_dbl(data, ~max(.x$Sale_Price))
  )

# Slide 18 -------------------------------------------------------

ames_lst_col

unnest(ames_lst_col, data)


# Slide 19 -------------------------------------------------------

mtcars %>% select(mpg, wt, hp) %>% slice(1:2)

# Slide 20 -------------------------------------------------------

cols <- c("mpg", "wt", "hp")
mtcars %>% select(!!!cols) %>% names()

value <- 5
mtcars %>% select(!!!cols) %>% mutate(x = !!value) %>% slice(1:2)

# Slide 21 -------------------------------------------------------

library(AmesHousing)
ames <- make_ames()

