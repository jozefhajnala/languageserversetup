if (!languageserversetup:::system_dep_available()) {
  q("no", status = 0)
}

runDeploy <- identical(Sys.getenv("LANGSERVERSETUP_RUN_DEPLOY"), "true")

if (!isTRUE(runDeploy)) {
  message("Skipping deploy test")
}

if (isTRUE(runDeploy)) {

  message("Running deploy test")

  oldLibPaths <- .libPaths()
  args <- commandArgs(trailingOnly = TRUE)
  fromGitHub <- identical(args, "dev")
  options(repos = c(CRAN = "https://cran.rstudio.com/"))

  message("\n\nInstalling dependencies")
  system("apt-get update && apt-get -y install libxml2-dev procps")
  install.packages("remotes")
  install.packages("tinytest")
  install.packages(".", repos = NULL, type = "source")

  message("\n\nAttaching languageserversetup")
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

  message("\n\nTesting languageserver_startup")
  expect_equal(
    languageserver_startup(
      rlsLib = rlsLib,
      langServerProcessPatt = ""
    ),
    TRUE
  )

  assign(".lib.loc", oldLibPaths, envir = environment(.libPaths))
  message("\n\nDone.\n\n")

}
