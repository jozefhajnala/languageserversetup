#' Prepare language server to be started
#'
#' @inheritParams languageserver_install
#'
#' @param langServerProcessPatt `character(1)`, pattern to
#'   recognize the process created by `languageserver`.
#' @param os `character(1)`, name of the OS, usually retrieved
#'   as the `"sysname"` element of `Sys.info`, all lowercase.
#' @param pid `integer(1)`, id of the process to investigate,
#'   usually retrieved by `Sys.getpid`
#'
#' @return side-effects
#' @export
languageserver_startup <- function(
  rlsLib = getOption("langserver_library"),
  langServerProcessPatt = getOption("langserver_processPatt"),
  strictLibrary = TRUE,
  os = tolower(Sys.info()[["sysname"]]),
  pid = Sys.getpid()
) {

  lg("languageserver_startup Starting")
  on.exit(lg("languageserver_startup Exiting"))

  if (identical(Sys.getenv("RSTUDIO"), "1")) {
    lg("  This looks like RStudio, not doing anything.")
    return(invisible(NA))
  }

  oldLibPaths <- .libPaths()
  lg("  Current .libPaths: ", toString(oldLibPaths))

  isLangServer <- languageserver_detect(
    pid = pid,
    os = os,
    langServerProcessPatt = langServerProcessPatt
  )
  if (!isLangServer) {
    lg("  Not language server process. No changes made.")
    return(invisible(NA))
  }

  lgsrvr("  This seems to be language server process. Aligning libraries.")
  newLibLoc <- if (isTRUE(strictLibrary)) {
    c(rlsLib, .libPaths()[length(.libPaths())])
  } else {
    c(rlsLib, .libPaths())
  }
  lgsrvr("  Determined new library locations: ", toString(newLibLoc))

  assign(".lib.loc", newLibLoc, envir = environment(.libPaths))
  lgsrvr("  Now .libpaths() is:\n   ", paste(.libPaths(), collapse = "\n   "))
  lgsrvr("  Trying to requireNamespace of languageserver.")
  serverLoadable <- do.call(
    "requireNamespace",
    list(package = "languageserver", lib.loc = rlsLib, quietly = TRUE)
  )
  if (!isTRUE(serverLoadable)) {
    lg("  Not loadable, restoring .libPaths to: ", toString(oldLibPaths))
    assign(".lib.loc", oldLibPaths, envir = environment(.libPaths))
    stop(
      "The languageserver package is not loadable. \n",
      "You can try running languageserver_install()"
    )
  } else {
    lgsrvr("  Package languageserver is loadable, functionality should work.")
  }

  invisible(serverLoadable)
}
