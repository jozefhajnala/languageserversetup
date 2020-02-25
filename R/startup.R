#' Prepare languageserver to be started
#' @inheritParams languageserver_install
#' @param langServerProcessPatt `character(1)`, pattern to
#'   recognize the process created by language server.
#' @param processArgs `list()` of arguments to `system2` to
#'   retrieve a list of processes.
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

  newLibLoc <- if (isTRUE(strictLibrary)) {
    c(rlsLib, .libPaths()[length(.libPaths())])
  } else {
    c(rlsLib, .libPaths())
  }

  cmd <- do.call(system2, processArgs)

  if (any(grepl(langServerProcessPatt, cmd, fixed = TRUE))) {
    lg("- This seems to be language server process. Aligning libraries.")
    assign(".lib.loc", newLibLoc, envir = environment(.libPaths))
    lg(paste("- .libpaths() is now:\n ", paste(.libPaths(), collapse = "\n  ")))
  } else {
    lg("- Not language server. No changes made.")
  }

  serverLoadable <- do.call(
    "requireNamespace",
    list(package = "languageserver", quietly = TRUE)
  )
  if (!isTRUE(serverLoadable)) {
    stop(
      "The languageserver package is not loadable. \n",
      "You can try running languageserver_install()"
    )
  }

  invisible(serverLoadable)
}
