#' Detect whether a process relates to the R Language Server
#'
#' @inheritParams languageserver_startup
#' @param checkParents `logical(1)`, if `TRUE`, parent processes are also
#'   checked in case when `pid` is not the R Language Server process. This
#'   is needed as the linting processes are created with callr as
#'   sub-processes of the main Language Server process.
#'
#' @return logical(1), `TRUE` if the process with `pid` (or, optionally,
#'   any of its parents) is detected as the R Language Server process.
#'   Otherwise `FALSE`.
languageserver_detect <- function(
  pid, os, langServerProcessPatt, checkParents = TRUE
) {
  lg(" Running languageserver_detect")

  lg("  Checking whether main process is languageserver.")
  if (is_language_server(
    pid = pid, os = os, langServerProcessPatt = langServerProcessPatt)
  ) {
    lg("   this main process ", pid, " is languageserver process")
    return(TRUE)
  }
  lg("   this main process ", pid, " is NOT languageserver process")
  if (!isTRUE(checkParents)) {
    lg("   checkParents is FALSE, exiting with FALSE")
    return(FALSE)
  }

  lg("  Checking whether any parent process is languageserver.")
  parentProcessArgs <- get_process_args(
    os = os, pid = pid, output = TRUE, parent = TRUE
  )
  parentPid <- do_call(parentProcessArgs, trimWs = TRUE)
  parentPid <- suppressWarnings(parentPid[!is.na(as.numeric(parentPid))])
  lg("   determined parent process id: ", toString(parentPid))
  parentIsLanguageServer <- vapply(
    X = parentPid,
    FUN = is_language_server,
    FUN.VALUE = logical(1),
    os = os,
    langServerProcessPatt = langServerProcessPatt
  )
  if (any(parentIsLanguageServer)) {
    parentPid <- names(which(parentIsLanguageServer))
    lg("   detected parent as languageserver, pid: ", toString(parentPid))
    return(TRUE)
  }
  lg("  No parents seem to be languageserver, returning FALSE.")
  lg(" Done languageserver_detect")
  FALSE
}

is_language_server <- function(pid, os, langServerProcessPatt) {
  processArgs <- get_process_args(pid = pid, os = os)
  cmd <- do_call(processArgs)
  isLangServer <- any(grepl(langServerProcessPatt, cmd, fixed = TRUE))
  if (isTRUE(isLangServer)) {
    lg("    process ", pid, " seems to be a languageserver process.")
    return(TRUE)
  }
  lg("    process ", pid, " does NOT seem to be a languageserver process.")
  FALSE
}
