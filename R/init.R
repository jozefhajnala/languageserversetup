.LangServerSetupEnv <- new.env(parent = emptyenv())

.onLoad <- function(libName, pkgName) { # nocov start
  options(
    langserver_library = path.expand(file.path("~", "languageserver-library")),
    langserver_processPatt = "languageserver::run",
    langserver_quiet = TRUE,
    langserver_quiet_serverproc = FALSE,
    langserver_rprofile_candidates = c(
      atHome = path.expand(file.path("~", ".Rprofile")),
      atEnv = Sys.getenv("R_PROFILE_USER")
    )
  )
} # nocov end
