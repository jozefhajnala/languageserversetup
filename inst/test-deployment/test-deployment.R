if (!languageserversetup:::system_dep_available(force = TRUE)) {
  message("System dependency not available, not running tests")
  q("no", status = 0)
}

runDeploy <- identical(Sys.getenv("LANGSERVERSETUP_RUN_DEPLOY"), "true")
if (!isTRUE(runDeploy)) {
  message("Skipping deploy test")
  q("no", status = 0)
}

message("Running deploy test")

oldLibPaths <- .libPaths()
args <- commandArgs(trailingOnly = TRUE)
fromGitHub <- identical(args, "dev")
options(repos = c(CRAN = "https://cran.rstudio.com/"))


if (identical(tolower(Sys.info()[["sysname"]]), "linux")) {
  message("\n\nInstalling linux dependencies with apt")
  system("apt-get update && apt-get -y install libxml2-dev procps")
}

if (identical(tolower(Sys.info()[["sysname"]]), "windows")) {
  message("\n\nThis is Windows, setting options(pkgType = 'binary')")
  options(pkgType = "binary")
}

if (!require(languageserversetup)) {
  message("\n\nInstalling languageserversetup")
  install.packages(".", repos = NULL, type = "source")
}

message("\n\nTesting Attach of  languageserversetup")
expect_equal(
  require(languageserversetup),
  TRUE
)

message("\n\nInstalling languageserver")
rlsLib <- file.path(tempdir(), "languageserver-library")
languageserver_install(
  rlsLib = rlsLib,
  confirmBeforeInstall = FALSE,
  fromGitHub = fromGitHub
)

message("\n\nTesting languageserversetup is in rlsLib")
expect_true(
  is.element(
    "languageserversetup",
    sort(rownames(installed.packages(lib.loc = rlsLib)))
    )
)


message("\n\nTesting Attach of languageserver")
expect_equal(
  require(languageserver, lib.loc = rlsLib),
  TRUE
)

message("\n\nTesting languageserver_startup")

origRStudio <- Sys.getenv("RSTUDIO")
Sys.setenv("RSTUDIO" = "-1")
expect_equal(
  languageserver_startup(
    rlsLib = rlsLib,
    langServerProcessPatt = ""
  ),
  TRUE
)
Sys.setenv("RSTUDIO" = origRStudio)

message("\n\nDetaching packages before following tests")
cat(names(utils::sessionInfo()$otherPkgs))
invisible(lapply(
  setdiff(
    paste0('package:', names(sessionInfo()$otherPkgs)),
    "package:tinytest"
  ),
  detach,
  character.only = TRUE,
  unload = TRUE,
  force = TRUE
))

message("\n\nTest all packages detached (expect tinytest)")
cat(names(utils::sessionInfo()$otherPkgs))
expect_true(
  identical(names(utils::sessionInfo()$otherPkgs), "tinytest") ||
    identical(names(utils::sessionInfo()$otherPkgs), NULL)
)

message("\n\nTest languageserversetup attachable from rlsLib")
expect_equal(
  require(languageserversetup, lib.loc = rlsLib),
  TRUE
)

assign(".lib.loc", oldLibPaths, envir = environment(.libPaths))
message("\n\nDone.\n\n")
