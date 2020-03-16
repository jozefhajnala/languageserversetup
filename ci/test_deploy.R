args <- commandArgs(trailingOnly = TRUE)
fromGitHub <- identical(args, "dev")

message("Running deploy test")

message("\n\nInstalling dependencies")
system("apt-get update && apt-get -y install libxml2-dev procps")
install.packages("remotes")
install.packages("tinytest")
install.packages(".", repos = NULL, type = "source")

message("\n\nAttaching languageserversetup")
library(languageserversetup)

rlsLib <- file.path(tempdir(), "languageserver-library")

message("\n\nInstalling languageserver")
languageserver_install(
  rlsLib = rlsLib,
  confirmBeforeInstall = FALSE,
  fromGitHub = fromGitHub
)

message("\n\nTesting languageserver_startup")
languageserver_startup(
  rlsLib = rlsLib,
  langServerProcessPatt = ""
)

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
