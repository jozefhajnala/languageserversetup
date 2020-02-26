message("Running deploy test")

message("\n\nInstalling dependencies")
system("apt-get update && apt-get -y install libxml2-dev procps")
install.packages("remotes")
install.packages(".", repos = NULL)

message("\n\nAttaching languageserversetup")
library(languageserversetup)

message("\n\nInstalling languageserver")
languageserver_install(confirmBeforeInstall = FALSE)

message("\n\nTesting languageserver_startup")
languageserver_startup(langServerProcessPatt = "")

message("\n\nTesting addition of code to .Rprofile")
languageserversetup:::add_setup_to_rprofile(
  confirmBeforeWrite = FALSE
)
stopifnot(identical(
  readLines("/root/.Rprofile"),
  languageserversetup:::append_code()
))

message("\n\nTesting removal of code from .Rprofile")
languageserversetup:::remove_setup_from_rprofile(
  confirmBeforeRemove = FALSE
)
stopifnot(identical(
  readLines("/root/.Rprofile"),
  character(0)
))

message("\n\nDone.\n\n")
