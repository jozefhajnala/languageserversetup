add_setup_to_rprofile <- function(
  rprofilePath = locate_rprofile(),
  confirmBeforeWrite = TRUE,
  code = append_code()
) {

  filePath <- make_rprofile_path(rprofilePath)
  continue <- if (isTRUE(confirmBeforeWrite)) {
    try(askYesNo(
      paste0("This will append code to: ", filePath, "\n", "Do you agree?"),
      default = FALSE
    ))
  } else {
    TRUE
  }

  if (!isTRUE(continue)) {
    message(confirm_message())
    return(FALSE)
  }

  write(code, file = filePath, append = TRUE)
}

remove_setup_from_rprofile <- function(
  rprofilePath = locate_rprofile(),
  code = append_code(),
  confirmBeforeRemove = TRUE
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

  continue <- if (isTRUE(confirmBeforeRemove)) {
    try(askYesNo(
      paste0(
        "This will remove lines: ", toString(which(toRemove)), "\n",
        "from: ", filePath, "\n",
        "Do you agree?"
      ),
      default = FALSE
    ))
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
