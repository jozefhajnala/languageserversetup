get_docall_args <- function(pid, output, parent) {
  on.exit(
    lg("    setting get_docall_args: ", toString(returnValue()))
  )
  lg("    get_docall_args: class(pid)=", class(pid), ", pid=", pid)
  UseMethod("get_docall_args")
}

#'@export
get_docall_args.default <- function(pid, output, parent) {
  list(
    what = "system2",
    args = list(
      command = "ps",
      args = if (isTRUE(parent)) {
        paste("-o", paste0("ppid= ", pid))
      } else {
        c("-p", pid,  "-o", "command", "--no-headers")
      },
      stdout = output
    )
  )
}

#'@export
get_docall_args.darwin <- function(pid, output, parent) {
  list(
    what = "system2",
    args = list(
      command = "ps",
      args = if (isTRUE(parent)) {
        paste("-o", paste0("ppid= ", pid))
      } else {
        c("-p", pid,  "-o", "command")
      },
      stdout = output
    )
  )
}

#'@export
get_docall_args.windows <- function(pid, output, parent) {
  list(
    what = "system",
    args = list(
      command = if (isTRUE(parent)) {
        paste0("wmic process where processid=", pid, " get parentprocessid")
      } else {
        paste0("wmic process where processid=", pid, " get commandline")
      },
      intern = output, ignore.stdout = !output
    )
  )
}
