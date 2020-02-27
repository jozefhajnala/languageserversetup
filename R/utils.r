lgsrvr <- lg <- function(...) {
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
    lg("sysname is windows, setting: ", sQuote("wmic"), " as command.")
    return(list(
      command = "wmic",
      args = paste0(
        "process where processid=", Sys.getpid(), " get commandline"
      ),
      stdout = TRUE
    ))
  }
  if (tolower(Sys.info()[["sysname"]]) == "darwin") {
    lg("sysname is darwin, setting: ", sQuote("ps"), " as command.")
    return(list(
      command = "ps",
      args = c("-p", Sys.getpid(),  "-o", "command"),
      stdout = TRUE
    ))
  }
  if (tolower(Sys.info()[["sysname"]]) == "linux") {
    lg("sysname is linux, setting: ", sQuote("ps"), " as command.")
    return(list(
      command = "ps",
      args = c("-p", Sys.getpid(),  "-o", "command", "--no-headers"),
      stdout = TRUE
    ))
  }
}

locate_rprofile <- function(
  candidates = getOption("langserver_rprofile_candidates")
) {
  lg("locate_rprofile using candidates: ", toString(candidates))
  if (file.exists(candidates["atHome"])) {
    lg("locate_rprofile returning: ", candidates["atHome"])
    return(path.expand(candidates["atHome"]))
  }
  if (file.exists(candidates["atEnv"])) {
    lg("locate_rprofile returning: ", path.expand(candidates["atEnv"]))
    return(path.expand(candidates["atEnv"]))
  }
  lg("locate_rprofile did not find existing candidates, returning: NULL")
  invisible()
}

make_rprofile_path <- function(filePath) {
  if (is.null(filePath) || !file.exists(filePath)) {
    detPath <- path.expand(file.path("~", ".Rprofile"))
    lg("Determined filePath: ", detPath)
    detPath
  } else {
    lg("Keeping filePath: ", filePath)
    path.expand(filePath)
  }
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
