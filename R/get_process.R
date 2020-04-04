get_process_fun <- function(os = tolower(Sys.info()[["sysname"]])) {
  lg("    sysname is ", os)
  res <- if (identical(os, "windows")) "system" else "system2"
  lg("    setting get_process_fun: ", toString(res))
  res
}

get_process_args <- function(
  os = tolower(Sys.info()[["sysname"]]),
  pid = Sys.getpid(),
  argsFun = get_current_process_args
) {
  lg("    sysname is ", os, ", pid is: ", pid)
  res <- if (identical(os, "windows")) {
    list(
      command = paste(get_process_command(os), argsFun(os, pid)),
      intern = TRUE
    )
  } else {
    list(
      command = get_process_command(os),
      args = argsFun(os, pid),
      stdout = get_process_stdout(os)
    )
  }
  lg("    setting args: ", toString(res))
  res
}

get_process_detection_args <- function(
  os = tolower(Sys.info()[["sysname"]]),
  pid = Sys.getpid()
) {
  args <- get_process_args(
    os = os,
    pid = pid,
    argsFun = get_current_process_args
  )
  c(
    args[-length(args)],
    if (identical(os, "windows")) {
      list(intern = FALSE, ignore.stdout = TRUE)
    } else {
      list(stdout = FALSE)
    }
  )
}

get_process_command <- function(os) {
  if (identical(os, "windows")) "wmic" else "ps"
}

get_process_stdout <- function(os) {
  TRUE
}

get_current_process_args <- function(os, pid) {
  if (identical(os, "windows")) {
    return(paste0("process where processid=", pid, " get commandline"))
  }
  if (identical(os, "darwin")) {
    return(c("-p", pid,  "-o", "command"))
  }
  c("-p", pid,  "-o", "command", "--no-headers")
}

get_parent_process_args <- function(os, pid) {
  if (identical(os, "windows")) {
    return(paste0("process where processid=", pid, " get parentprocessid"))
  }
  paste("-o", paste0("ppid= ", pid))
}

is_language_server <- function(pid, os, langServerProcessPatt) {
  processArgs <- get_process_args(pid = pid, os = os)
  processFun <- get_process_fun(os = os)
  lg("    running do.call ",  processFun, " with: ", toString(processArgs))
  cmd <- do.call(processFun, processArgs)
  if (grepl("^wmic", processArgs[["command"]])) {
    cmd <- wmic_cleanup(cmd)
  }
  lg("    determined cmd: ", toString(cmd))

  isLangServer <- any(grepl(langServerProcessPatt, cmd, fixed = TRUE))
  if (isTRUE(isLangServer)) {
    lg("    process ", pid, " seems to be a languageserver process.")
    return(TRUE)
  }
  lg("    process ", pid, " does NOT seem to be a languageserver process.")
  FALSE
}

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
detect_language_server <- function(
  pid, os, langServerProcessPatt, checkParents = TRUE
) {
  lg("  Running detect_language_server")

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
    pid = pid, os = os, argsFun = get_parent_process_args
  )
  processFun <- get_process_fun(os = os)
  lg("   running do.call ", processFun, " with: ", toString(parentProcessArgs))
  parentPid <- trimws(do.call(processFun, parentProcessArgs))
  if (grepl("^wmic", parentProcessArgs[["command"]])) {
    parentPid <- wmic_cleanup(parentPid)
  }
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
  FALSE
}

wmic_cleanup <- function(cmd) {
  if (length(cmd) > 1L) cmd <- cmd[-1L]
  cmd <- trimws(cmd)
  cmd <- cmd[cmd != ""]
  cmd
}
