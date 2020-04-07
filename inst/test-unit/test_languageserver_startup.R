if (!languageserversetup:::system_dep_available(force = TRUE)) {
  message("System dependency not available, not running tests.")
  q("no", status = 0)
}
oldLibPaths <- .libPaths()
origRStudio <- Sys.getenv("RSTUDIO")

# Pretend this is RStudio in case it is not ----
Sys.setenv("RSTUDIO" = "1")
expect_equal(
  languageserver_startup(),
  NA
)
Sys.setenv("RSTUDIO" = origRStudio)

# Pretend this is not RStudio in case it is ----
Sys.setenv("RSTUDIO" = "-1")
# Test a failed load ----
expect_error(
  languageserver_startup(
    rlsLib = file.path(tempdir(), "nothing-here"),
    strictLibrary = TRUE,
    langServerProcessPatt = ""
  )
)
expect_equal(
  languageserver_startup(),
  NA
)
Sys.setenv("RSTUDIO" = origRStudio)

# After failed load, libPaths should be restored ----
expect_equal(
  .libPaths(),
  oldLibPaths
)
