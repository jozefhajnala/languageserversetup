lg <- function(..., stayQuiet = getOption("langserver_quiet")) {
  if (!isTRUE(stayQuiet)) message(...)
  invisible()
}

lgsrvr <- function(...) {
  lg(..., stayQuiet = getOption("langserver_quiet_serverproc"))
}

askYesNo <- if ( # nocov start
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
} # nocov end

get_process_args <- function(os = tolower(Sys.info()[["sysname"]])) {
  if (identical(os, "windows")) {
    lg("sysname is windows, setting: ", sQuote("wmic"), " as command.")
    return(list(
      command = "wmic",
      args = paste0(
        "process where processid=", Sys.getpid(), " get commandline"
      ),
      stdout = TRUE
    ))
  }
  if (identical(os, "darwin")) {
    lg("sysname is darwin, setting: ", sQuote("ps"), " as command.")
    return(list(
      command = "ps",
      args = c("-p", Sys.getpid(),  "-o", "command"),
      stdout = TRUE
    ))
  }
  if (identical(os, "linux")) {
    lg("sysname is linux, setting: ", sQuote("ps"), " as command.")
    return(list(
      command = "ps",
      args = c("-p", Sys.getpid(),  "-o", "command", "--no-headers"),
      stdout = TRUE
    ))
  }

  lg("sysname is ", os, ", attempting: ", sQuote("ps"), " as command.")
  list(
    command = "ps",
    args = c("-p", Sys.getpid(),  "-o", "command", "--no-headers"),
    stdout = TRUE
  )
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

append_code <- function(
  rlsLib = getOption("langserver_library"),
  code = c(
  "# LanguageServer Setup Start (do not change this chunk)",
  "# to remove this, run languageserversetup::remove_from_rprofile",
  paste0("options(", "langserver_library", " = '", rlsLib, "')"),
  "languageserversetup::languageserver_startup()",
  "unloadNamespace('languageserversetup')",
  "# LanguageServer Setup End"
)) {
  invisible(code)
}

system_dep_available <- function(
  pars = suppressMessages(get_process_args()),
  force = FALSE
) {

  if (exists("sysDepAvailable", envir = .LangServerSetupEnv)) {
    if (!isTRUE(force)) {
      lg("system_dep_available found and returning")
      return(get("sysDepAvailable", envir = .LangServerSetupEnv))
    } else {
      lg("system_dep_available found but force is TRUE, recomputing")
    }
  } else {
    lg("system_dep_available not found, determining")
  }


  res <- do.call(system2, c(pars[-3L], stdout = FALSE))
  res <- res == 0L
  attr(res, "msg") <- if (!isTRUE(res)) {
    paste0(
      "The command ", sQuote(pars[["command"]]), " cannot run successfully.\n",
      "Please make sure the software is available to use the package.\n",
      if (pars[["command"]] == "ps") {
        paste("Installing", sQuote("procps"), "might help")
      }
    )
  }

  lg("system_dep_available determined: ", res)
  assign("sysDepAvailable", value = res, envir = .LangServerSetupEnv)
  res
}
