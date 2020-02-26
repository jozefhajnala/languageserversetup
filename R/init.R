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

confirm_message <- function(msg = paste0(
  "Not doing anything, returning FALSE. \n",
  "Please confirm by typing ", sQuote("Yes"), " to continue next time \n",
  "or use confirmBeforeWrite = FALSE to skip the confirmation"
)) {
  invisible(msg)
}

append_code <- function(code = c(
  "# LanguageServer Setup Start (do not change this chunk)",
  "# to remove this, run languageserversetup::remove_from_rprofile",
  "library(languageserversetup)",
  "languageserver_startup()",
  "# LanguageServer Setup End"
)) {
  invisible(code)
}
