#' Remove language server initialization from `.Rprofile`
#'
#' @inheritParams languageserver_add_to_rprofile
#'
#' @return side-effects
#' @export
languageserver_remove_from_rprofile <- function(
  rlsLib = getOption("langserver_library"),
  rprofilePath = locate_rprofile(),
  code = append_code(rlsLib = rlsLib),
  confirmBeforeChanging = TRUE
) {
  filePath <- make_rprofile_path(rprofilePath)
  oldContent <- readLines(filePath)
  lg("Read oldContent, length: ", length(oldContent), " from: ", filePath)

  toRemove <- vapply(
    X = oldContent,
    FUN = is.element,
    set = code,
    FUN.VALUE = logical(1)
  )
  newContent <- oldContent[!toRemove]

  if ((length(oldContent) - length(newContent)) != length(code)) {
    warning(
      "The code to remove is inconsistent with content.",
      "Please remove it manually."
    )
    return(invisible(FALSE))
  }

  continue <- if (isTRUE(confirmBeforeChanging)) {
    try(askYesNo( # nocov start
      paste0(
        "This will remove lines: ", toString(which(toRemove)), "\n",
        "from: ", filePath, "\n",
        "Do you agree?"
      ),
      default = FALSE
    )) # nocov end
  } else {
    TRUE
  }

  if (!isTRUE(continue)) {
    message(confirm_message())
    return(invisible(FALSE))
  }

  lg("Writing newContent, length: ", length(newContent), " to: ", filePath)
  writeLines(newContent, filePath)
}
