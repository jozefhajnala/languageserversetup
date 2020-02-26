.onLoad <- function(libName, pkgName) {

  # Test wheter the system command can run
  cmd <- get_process_args()[["command"]]
  res <- system2(cmd, stdout = FALSE, stderr = FALSE)
  if (res != 0L) {
    stop(
      "The command ", sQuote(cmd), " cannot run successfully.\n",
      "Please make sure the software is available to use the package.\n",
      if (cmd == "ps") paste("Installing", sQuote("procps"), "might help")
    )
  }

  options(
    langserver_library = path.expand(file.path("~", "languageserver-library")),
    langserver_processPatt = "languageserver::run",
    langserver_quiet = FALSE
  )
}
