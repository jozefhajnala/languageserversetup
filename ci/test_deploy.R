args <- commandArgs(trailingOnly = TRUE)
fromGitHub <- identical(args, "dev")
options(Ncpus = parallel::detectCores())

message("Running deploy test")

message("\n\nInstalling dependencies")
system("apt-get update && apt-get -y install procps")
install.packages(".", repos = NULL, type = "source")

message("\n\nSetting options")
rlsLib <- file.path(tempdir(), "languageserver-library")
options(langserver_library = rlsLib)

message("\n\nAttaching languageserversetup")
library(languageserversetup)

message("\n\nInstalling languageserver")
languageserver_install(
  rlsLib = rlsLib,
  confirmBeforeInstall = FALSE,
  fromGitHub = fromGitHub
)

message("\n\nTesting languageserver_startup")
languageserver_startup(langServerProcessPatt = "")

message("\n\nTesting addition of code to .Rprofile")
languageserver_add_to_rprofile(
  confirmBeforeChanging = FALSE
)
stopifnot(identical(
  readLines("/root/.Rprofile"),
  languageserversetup:::append_code()
))

message("\n\nTesting removal of code from .Rprofile")
languageserver_remove_from_rprofile(
  confirmBeforeChanging = FALSE
)
stopifnot(identical(
  readLines("/root/.Rprofile"),
  character(0)
))

message("\n\nDone.\n\n")
