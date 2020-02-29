expect_equal(
  languageserversetup:::get_process_args(os = "darwin")[["command"]],
  "ps"
)

expect_equal(
  languageserversetup:::get_process_args(os = "linux")[["command"]],
  "ps"
)

expect_equal(
  languageserversetup:::get_process_args(os = "windows")[["command"]],
  "wmic"
)

expect_equal(
  languageserversetup:::locate_rprofile(""),
  NULL
)

expect_equal(
  languageserversetup:::make_rprofile_path(NULL),
  path.expand(file.path("~", ".Rprofile"))
)

tmpFile <- tempfile()
file.create(tmpFile)
languageserver_add_to_rprofile(
  rlsLib = "test",
  tmpFile,
  confirmBeforeChanging = FALSE
)
expect_equal(
  readLines(tmpFile),
  languageserversetup:::append_code(rlsLib = "test")
)
languageserver_remove_from_rprofile(
  rlsLib = "test",
  tmpFile,
  confirmBeforeChanging = FALSE
)
expect_equal(
  readLines(tmpFile),
  character(0)
)
unlink(tmpFile)

expect_equal(
  languageserversetup:::append_code("test"),
  c(
    "# LanguageServer Setup Start (do not change this chunk)",
    "# to remove this, run languageserversetup::remove_from_rprofile",
    "options(langserver_library = 'test')", "library(languageserversetup)",
    "languageserver_startup()", "# LanguageServer Setup End"
  )
)

expect_equal(
  languageserversetup:::confirm_message(),
  paste0(
    "Not doing anything, returning FALSE. \n",
    "Please confirm by typing ", sQuote("Yes"), " to continue next time \n",
    "or use confirmBeforeWrite = FALSE to skip the confirmation"
  )
)
