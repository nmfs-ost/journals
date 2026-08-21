#' Download .bib files
#'
#' @param to A file path to a directory for the downloaded .bib files.
#' @param from A string specifying if you want the bib files from inst/bib
#'   or tex/bib, where both are folders within in the package available on
#'   GitHub. Only the suffix is needed, and the default is `"inst"`. All
#'   options are shown in the function call.
#' @author Kelli F. Johnson
#' @export
#'
download_bibs <- function(to = getwd(), from = c("inst", "tex")) {
  from <- match.arg(from)
  dir.create(to, recursive = TRUE, showWarnings = FALSE)
  files <- find_bibs(from)
  url <- paste0(
    "https://raw.githubusercontent.com/",
    github_organization,
    "/",
    github_repository,
    "/main/",
    from,
    "/bib/"
  )
  purrr::walk2(
    .x = paste0(url, files),
    .y = file.path(to, files),
    .f = utils::download.file
  )
}
