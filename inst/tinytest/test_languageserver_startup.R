expect_equal(
  languageserver_startup(),
  NA
)

expect_error(
  languageserver_startup(
    rlsLib = tempdir(),
    strictLibrary = TRUE,
    langServerProcessPatt = ""
  )
)
