.onLoad <- function(libName, pkgName) {

  # Test wheter the system command can run
  pars <- suppressMessages(get_process_args())
  res <- do.call(system2, c(pars[-3L], stdout = FALSE))
  if (res != 0L) {
    stop(
      "The command ", sQuote(pars[["command"]]), " cannot run successfully.\n",
      "Please make sure the software is available to use the package.\n",
      if (pars[["command"]] == "ps") {
        paste("Installing", sQuote("procps"), "might help")
      }
    )
  }

  options(
    langserver_library = path.expand(file.path("~", "languageserver-library")),
    langserver_processPatt = "languageserver::run",
    langserver_quiet = FALSE,
    langserver_rprofile_candidates = c(
      atHome = path.expand(file.path("~", ".Rprofile")),
      atEnv = Sys.getenv("R_PROFILE_USER")
    )
  )
}
