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

expect_true(
  is.list(languageserversetup:::get_process_args(os = NULL)) &&
    length(languageserversetup:::get_process_args(os = NULL)) == 3L
)

expect_true(
  is.list(languageserversetup:::get_process_args(os = NA)) &&
    length(languageserversetup:::get_process_args(os = NA)) == 3L
)

expect_true(
  is.list(languageserversetup:::get_process_args(os = "")) &&
    length(languageserversetup:::get_process_args(os = "")) == 3L
)

expect_equal(
  languageserversetup:::get_process_args(os = NULL)[["command"]],
  "ps"
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
    "options(langserver_library = 'test')",
    "languageserversetup::languageserver_startup()",
    "unloadNamespace('languageserversetup')",
    "# LanguageServer Setup End"
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

expect_equal(
  languageserversetup:::system_dep_available(
    list(command = "echo", "1"),
    force = TRUE
  ),
  TRUE,
  info = "echo command works"
)

expect_equal(
  languageserversetup:::system_dep_available(
    list(command = "madeupcommand", "1")
  ),
  TRUE,
  info = "non-existing command gives TRUE if TRUE stored and force is FALSE"
)

expect_equivalent(
  languageserversetup:::system_dep_available(
    list(command = "madeupcommand", "1"),
    force = TRUE
  ),
  FALSE,
  info = "non-existing command gives FALSE"
)
