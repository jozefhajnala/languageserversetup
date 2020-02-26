message("Running deploy test")

system("apt-get update && apt-get -y install libxml2-dev procps")
install.packages("remotes")
install.packages(".", repos = NULL)
library(languageserversetup)
languageserver_install(confirmBeforeInstall = FALSE)
languageserver_startup(langServerProcessPatt = "")
