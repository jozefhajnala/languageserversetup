if (!languageserversetup:::system_dep_available(force = TRUE)) {
  message("System dependency not available, not running tests.")
  q("no", status = 0)
}

expect_equal(
  languageserver_startup(),
  NA
)

# Test a failed load ----
oldLibPaths <- .libPaths()
rstudio <- Sys.getenv("RSTUDIO")
if (identical(rstudio, "1")) Sys.setenv("RSTUDIO" = "-1")
expect_error(
  languageserver_startup(
    rlsLib = file.path(tempdir(), "nothing-here"),
    strictLibrary = TRUE,
    langServerProcessPatt = ""
  )
)
if (identical(rstudio, "1")) Sys.setenv("RSTUDIO" = "1")


# After failed load, libPaths should be restored ----
expect_equal(
  .libPaths(),
  oldLibPaths
)
