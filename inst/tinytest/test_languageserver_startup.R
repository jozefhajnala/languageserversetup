expect_equal(
  languageserver_startup(),
  NA
)

# Test a failed load ----
oldLibPaths <- .libPaths()
expect_error(
  languageserver_startup(
    rlsLib = file.path(tempdir(), "nothing-here"),
    strictLibrary = TRUE,
    langServerProcessPatt = ""
  )
)

# After failed load, libPaths should be restored ----
expect_equal(
  .libPaths(),
  oldLibPaths
)
