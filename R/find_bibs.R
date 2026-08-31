#' Find and list the names of available .bib files in \pkg{journals}
#'
#' Search the GitHub repository in the inst/bib directory for .bib files and
#' return a list of all the available files. This list can then be used within
#' a markdown file to specify the available .bib files.
#' @inheritParams download_bibs
#'
#' @author Kelli F. Johnson
#' @export
#'
find_bibs <- function(from = c("inst", "tex")) {
  from <- match.arg(from)
  url <- paste0(
    "https://api.github.com/repos/",
    github_organization,
    "/",
    github_repository,
    "/git/trees/main:",
    from,
    "/bib"
  )
  info <- system(paste("curl", url), intern = TRUE)
  files <- gsub(
    pattern = "^.+: |,|\\\"",
    replacement = "",
    grep("bib|sty", info, value = TRUE)
  )
  return(files)
}
