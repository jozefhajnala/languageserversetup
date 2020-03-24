lg <- function(..., stayQuiet = getOption("langserver_quiet")) {
  if (isFALSE(stayQuiet)) message(...)
  invisible()
}

lgsrvr <- function(...) {
  lg(..., stayQuiet = getOption("langserver_quiet_serverproc"))
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

initialize_options <- function(...) {
  initialize_option <- function(optName, optValue) {
    if (is.null(getOption(optName))) {
      lg("Setting option: ", sQuote(optName), " to: ", optValue)
      options(structure(list(optValue), .Names = optName))
    } else {
      lg("Keeping option: ", sQuote(optName), " value: ", getOption(optName))
    }
  }
  opts <- list(...)
  invisible(Map(initialize_option, names(opts), opts))
}
