
github_organization <- "nmfs-ost"
github_repository <- "journals"

usethis::use_data(
  github_organization = github_organization,
  github_repository = github_repository,
  internal = TRUE,
  overwrite = TRUE
)

rm(github_organization, github_repository)
