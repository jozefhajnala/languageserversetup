lg <- function(...) {
  if (!isTRUE(getOption("langserver_quiet"))) {
    message(...)
  }
  invisible()
}

askYesNo <- if (
  is.element("package:utils", utils::find("askYesNo", mode = "function"))
) {
  utils::askYesNo
} else {
  function (
    msg,
    default = TRUE,
    prompts = getOption("askYesNo", gettext(c("Yes", "No", "Cancel"))),
    ...
  ) {
    if (is.character(prompts) && length(prompts) == 1)
      prompts <- strsplit(prompts, "/")[[1]]
    if (!is.character(prompts) || length(prompts) != 3) {
      fn <- match.fun(prompts)
      return(fn(
        msg = msg,
        default = default,
        prompts = prompts,
        ...
      ))
    }
    choices <- tolower(prompts)
    if (is.na(default))
      choices[3L] <- prompts[3L]
    else if (default)
      choices[1L] <- prompts[1L]
    else
      choices[2L] <- prompts[2L]
    msg1 <- paste0("(", paste(choices, collapse = "/"), ") ")
    if (nchar(paste0(msg, msg1)) > 250) {
      cat(msg, "\n")
      msg <- msg1
    }
    else
      msg <- paste0(msg, " ", msg1)
    ans <- readline(msg)
    match <- pmatch(tolower(ans), tolower(choices))
    if (!nchar(ans))
      default
    else if (is.na(match))
      stop("Unrecognized response ", dQuote(ans))
    else
      c(TRUE, FALSE, NA)[match]
  }
}

get_process_args <- function() {
  if (tolower(Sys.info()[["sysname"]]) == "windows") {
    list(
      command = "wmic",
      args = paste0(
        "process where processid=", Sys.getpid(),
        " get commandline"
      ),
      stdout = TRUE
    )
  } else {
    list(
      command = "ps",
      args = c("-p", Sys.getpid(),  "-o", "cmd", "--no-headers"),
      stdout = TRUE
    )
  }
}

locate_rprofile <- function(
  candidates = c(
    atHome = file.path("~", ".Rprofile"),
    atEnv = Sys.getenv("R_PROFILE_USER")
  )
) {
  if (file.exists(candidates["atHome"])) {
    return(path.expand(candidates["atHome"]))
  }
  if (file.exists(candidates["atEnv"])) {
    return(path.expand(candidates["atEnv"]))
  }
  invisible()
}

make_rprofile_path <- function(filePath) {
  if (is.null(filePath) || !file.exists(filePath)) {
    lg("Determined filePath: ", filePath)
    path.expand(file.path("~", ".Rprofile"))
  } else {
    lg("Keeping filePath: ", filePath)
    path.expand(filePath)
  }
}
