#' Prepare language server to be started
#'
#' @inheritParams languageserver_install
#'
#' @param langServerProcessPatt `character(1)`, pattern to
#'   recognize the process created by `languageserver`.
#' @param processArgs `list()` of arguments to `system2` to
#'   retrieve a list of processes. The command defaults to `wmic`
#'   for windows and `ps` for other `sysnames`.
#'
#' @return side-effects
#' @export
languageserver_startup <- function(
  rlsLib = getOption("langserver_library"),
  langServerProcessPatt = getOption("langserver_processPatt"),
  strictLibrary = TRUE,
  processArgs = get_process_args()
) {

  lg("languageserver_startup Starting")
  on.exit(lg("languageserver_startup Exiting"))

  oldLibPaths <- .libPaths()
  lg("  Current .libPaths: ", toString(oldLibPaths))
  lg("  Running do.call system2 with: ", toString(processArgs))
  cmd <- do.call(system2, processArgs)
  lg("  Determined cmd: ", toString(cmd))

  if (!any(grepl(langServerProcessPatt, cmd, fixed = TRUE))) {
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
