
green_col <- function(x) {
  sprintf("\033[32m%s\033[39m", as.character(x))
}

gray_col <- "#666666"
gray_txt <- crayon::make_style(gray_col)

print_msg <- function(...) {
  x <- paste(c(...), collapse = "")
  x <- paste0(green_col("✔"), " ", x)
  cat(x, fill = TRUE)
}

cat_line <- function(..., color = NULL, bold = FALSE) {
  msg <- paste0(..., collapse = "\n")
  if (!is.null(color)) {
    col_txt <- crayon::make_style(color)
    msg <- col_txt(msg)
  }
  if (bold) {
    msg <- crayon::bold(msg)
  }
  cat(msg, fill = TRUE)
}


launch_rstudio_server <- function() {
  url <- Sys.getenv("RSTUDIO_SERVER_URL")
  user <- Sys.getenv("RSTUDIO_SERVER_USER")
  pword <- Sys.getenv("RSTUDIO_SERVER_PASSWORD")
  if (any("" %in% c(url, user, pword))) {
    cat_line(
      "RStudio server information not found. Enter workshop identifier ",
      "in browser to retrieve credentials.",
      color = gray_col
    )
    cat_line(
      gray_txt("Workshop identifier: "),
      crayon::bold("applied-machine-learning")
    )
    Sys.sleep(1.5)
    browseURL("https://rstd.io/class")
    url <- tfse::readline_("What is the URL to your RStudio server?")
    tfse:::append_lines(
      paste0("RSTUDIO_SERVER_URL=", url),
      file = '.Renviron'
    )
    user <- tfse::readline_("What is your username for this server?")
    tfse:::append_lines(
      paste0("RSTUDIO_SERVER_USER=", user),
      file = '.Renviron'
    )
    pword <- tfse::readline_("What is your password for this server?")
    tfse:::append_lines(
      paste0("RSTUDIO_SERVER_PASSWORD=", pword),
      file = '.Renviron'
    )
    readRenviron(".Renviron")
    print_msg("Stored RStudio server information in local .Renviron file")
    tfse:::append_lines(".Renviron", file = ".gitignore")
    print_msg("Added '.Renviron' to .gitignore\n")
  }
  ## print info
  print_msg(crayon::bold("RSTD_URL"), ": ", url)
  print_msg(crayon::bold("USERNAME"), ": ", user)
  print_msg(crayon::bold("PASSWORD"), ": ", pword)
  ## check if it's already been opened
  opened <- getOption("rstudio_server_is_open", FALSE)
  if (!opened) {
    browseURL(url)
    options(rstudio_server_is_open = TRUE)
  }
  invisible(url)
}


launch_rstudio_server()
