if (!languageserversetup:::system_dep_available(force = TRUE)) {
  message("System dependency not available, not running tests.")
  q("no", status = 0)
}

# development version used by default ----
expect_equal(
  languageserver_install(confirmBeforeInstall = FALSE, dryRun = TRUE),
  "source(...)"
)

# utils::install.packages used if requested ----
expect_equal(
  languageserver_install(
    confirmBeforeInstall = FALSE,
    dryRun = TRUE,
    fromGitHub = FALSE
  ),
  "utils::install.packages"
)

# .libPaths() get restored to original ----
currentLibPaths <- .libPaths()
languageserver_install(confirmBeforeInstall = FALSE, dryRun = TRUE)
newLibPaths <- .libPaths()
expect_equal(currentLibPaths, newLibPaths)

# log messages ----
oldOpt <- getOption("langserver_quiet")
options(langserver_quiet = FALSE)

# would create library if not there ----
expect_message(
  languageserver_install(
    rlsLib = file.path(tempdir(), "madeupdir"),
    confirmBeforeInstall = FALSE,
    dryRun = TRUE
  ),
  "dir\\.create\\(rlsLib, recursive = TRUE\\)"
)

# would delete library if already there ----
expect_message(
  languageserver_install(
    rlsLib = file.path(tempdir()),
    confirmBeforeInstall = FALSE,
    dryRun = TRUE
  ),
  "unlink\\(rlsLib, recursive = TRUE, force = TRUE\\)"
)

# just appends to .libPaths if strictLibrary = FALSE
expect_message(
  languageserver_install(
    rlsLib = file.path(tempdir()),
    confirmBeforeInstall = FALSE,
    strictLibrary = FALSE,
    dryRun = TRUE
  ),
  toString(.libPaths())
)

# overwrites .libPaths if strictLibrary = TRUE
tmpDir <- gsub("\\\\", "/", tempdir())
expect_message(
  languageserver_install(
    rlsLib = tmpDir,
    confirmBeforeInstall = FALSE,
    strictLibrary = TRUE,
    dryRun = TRUE
  ),
  toString(c(
    tmpDir,
    .libPaths()[[length(.libPaths())]]
  ))
)

options(langserver_quiet = oldOpt)
