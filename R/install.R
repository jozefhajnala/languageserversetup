#' Install language server to a separate library
#'
#' @param rlsLib `character(1)` path to the library.
#' @param strictLibrary `logical(1)` if `TRUE`, all the dependencies
#'   of `languageserver` will be installed into `rlsLib`, otherwise
#'   only those that are needed but not present in other libraries
#'   in `.libPaths()` will be installed.
#' @param fullReinstall `logical(1)`. If `TRUE`, `rlsLib` will be
#'   recursively removed to re-install all the packages cleanly.
#' @param fromGitHub `logical(1)`, if `TRUE`, will use
#'   `remotes::install_github()`, otherwise `install.packages()` is
#'   used to install the `languageserver` package.
#' @param ref `character(1)`, passed to `remotes::install_github()`
#'   when relevant.
#' @param confirmBeforeInstall `logical(1)` if `TRUE`, will ask the
#'   user to confirm the steps before installation. For non-interactive
#'   use, `FALSE` will skip the confirmation.
#'
#' @importFrom remotes install_github
#' @importFrom utils install.packages
#'
#' @return side-effects
#' @export
languageserver_install <- function(
  rlsLib = getOption("langserver_library"),
  strictLibrary = TRUE,
  fullReinstall = TRUE,
  fromGitHub = TRUE,
  confirmBeforeInstall = TRUE,
  ref = "master"
) {

  lg("langserver_install Starting")
  on.exit(lg("langserver_install Exiting"))

  continue <- if (isTRUE(confirmBeforeInstall)) {
    try(
      askYesNo(
        paste(
          "This will attempt to use remotes::install_github",
          "to install REditorSupport/languageserver into:",
          rlsLib,
          if (isTRUE(strictLibrary))
            "All dependencies will also be installed there"
          else
            "only installing unavailable dependencies",
          if (isTRUE(fullReinstall))
            paste("! The directory", rlsLib, "will be RECURSIVELY REMOVED !"),
          "Do you agree?",
          sep = "\n"
        ),
        default = FALSE
      )
    )
  } else {
    TRUE
  }

  if (!isTRUE(continue)) {
    message(confirm_message())
    return(FALSE)
  }

  newLibLoc <- if (isTRUE(strictLibrary)) {
    c(rlsLib, .libPaths()[length(.libPaths())])
  } else {
    c(rlsLib, .libPaths())
  }
  if (isTRUE(fullReinstall)) {
    lg("fullReinstall is TRUE, deleting ", rlsLib)
    unlink(rlsLib, recursive = TRUE, force = TRUE)
  }
  if (!dir.exists(rlsLib)) {
    lg("rlsLib does not exist, creating ", rlsLib)
    dir.create(rlsLib, recursive = TRUE)
  }
  lg("assigning ", newLibLoc, " to .lib.loc")
  assign(".lib.loc", newLibLoc, envir = environment(.libPaths))

  if (isTRUE(fromGitHub)) {
    lg("running remotes::install_github")
    remotes::install_github(
      repo = "REditorSupport/languageserver",
      ref = ref,
      dependencies = c("Depends", "Imports"),
      upgrade = "never",
      lib = rlsLib,
      force = TRUE
    )
  } else {
    lg("running install.packages")
    utils::install.packages(
      pkgs = "languageserver",
      lib = rlsLib
    )
  }
}
