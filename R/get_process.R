set_os_class <- function(x = NA, os = tolower(Sys.info()[["sysname"]])) {
  structure(x, class = if (!is.null(os) && is.na(os)) "" else os)
}

get_pid <- function(
  pid = Sys.getpid(),
  os = tolower(Sys.info()[["sysname"]])
) {
  set_os_class(pid, os)
}

get_process_args <- function(
  os = tolower(Sys.info()[["sysname"]]),
  pid = Sys.getpid(),
  output = TRUE,
  parent = FALSE
) {
  pid <- get_pid(pid, os = os)
  lg("    sysname is ", os, ", pid is: ", pid)
  get_docall_args(pid = pid, output = output, parent = parent)
}

do_call <- function(doCallArgs, wmicClean = TRUE, trimWs = FALSE) {
  what <- doCallArgs[["what"]]
  args <- doCallArgs[["args"]]
  lg("    do_call running do.call: ",  what, ", args: ", toString(args))
  res <- do.call(what = what, args = args)
  if (isTRUE(trimWs)) {
    res <- trimws(res)
  }
  if (isTRUE(wmicClean)) {
    if (grepl("^wmic", args[["command"]])) {
      res <- wmic_cleanup(res)
    }
  }
  lg("    do_call returning: ", toString(res))
  res
}
