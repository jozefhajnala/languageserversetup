#' Add language server initialization to `.Rprofile`
#'
#' @inheritParams languageserver_install
#' @param rprofilePath `character(1)`, path to the file where
#'   to add the initialization code, or `NULL`. By default, adds the
#'   code to a `.Rprofile` file in the home directory of the current
#'   user. Please refer to `?Startup` for more details around
#'   `.Rprofile` files.
#'
#'   Notably, if  the `R_PROFILE_USER` environment variable is set,
#'   the `.Rprofile` located in the home directory is ignored,
#'   therefore we may want to place the initialization code into the
#'   file specified by that variable using the `rprofilePath` argument
#'   in that case.
#' @param confirmBeforeChanging `logical(1)`, if `TRUE`, asks for user
#'   confirmation before changing the file. For non-interactive
#'   use, `FALSE` will skip the confirmation.
#' @param code `character()`, the code to be added to the file.
#'   Defaults to the value of `append_code()`.
#'
#' @return side-effects
#' @export
languageserver_add_to_rprofile <- function(
  rlsLib = getOption("langserver_library"),
  rprofilePath = locate_rprofile(),
  confirmBeforeChanging = TRUE,
  code = append_code(rlsLib = rlsLib)
) {

  sysDepAvailable <- system_dep_available()
  if (!sysDepAvailable) stop(attr(sysDepAvailable, "msg"))

  filePath <- make_rprofile_path(rprofilePath)
  continue <- if (isTRUE(confirmBeforeChanging)) {
    try(askYesNo( # nocov start
      paste0("This will append code to: ", filePath, "\n", "Do you agree?"),
      default = FALSE
    )) # nocov end
  } else {
    TRUE
  }

  if (!isTRUE(continue)) {
    message(confirm_message())
    return(FALSE)
  }

  write(code, file = filePath, append = TRUE)
}
