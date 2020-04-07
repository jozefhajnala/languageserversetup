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

expect_equal(
  languageserversetup:::locate_rprofile(c(atHome = tmpFile, atEnv = "")),
  tmpFile
)

expect_equal(
  languageserversetup:::locate_rprofile(c(atHome = "", atEnv = tmpFile)),
  tmpFile
)

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
    "if (requireNamespace('languageserversetup', quietly = TRUE)) {",
    paste0("  options(", "langserver_library", " = '", "test", "')"),
    "  languageserversetup::languageserver_startup()",
    "  unloadNamespace('languageserversetup')",
    "}",
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
    utils::modifyList(
      languageserversetup:::get_process_args(output = FALSE),
      list(command = "echo")
    ),
    force = TRUE
  ),
  TRUE,
  info = "echo command works"
)

expect_equal(
  languageserversetup:::system_dep_available(
    utils::modifyList(
      languageserversetup:::get_process_args(output = FALSE),
      list(args = list(command = "madeupcommand"))
    )
  ),
  TRUE,
  info = "non-existing command gives TRUE if TRUE stored and force=FALSE"
)

expect_equivalent(
  languageserversetup:::system_dep_available(
    processArgs = utils::modifyList(
      languageserversetup:::get_process_args(output = FALSE),
      list(args = list(command = "madeupcommand"))
    ),
    force = TRUE
  ),
  FALSE,
  info = "non-existing command gives FALSE"
)

languageserversetup:::initialize_options(tmpOption = 1L)
expect_equal(
  getOption("tmpOption"),
  1L,
  info = "non-existing option greated"
)

languageserversetup:::initialize_options(
  tmpOption = 10L
)
expect_equal(
  getOption("tmpOption"),
  1L,
  info = "existing option not overwritten"
)
options(tmpOption = NULL)

expect_equal(
  languageserversetup:::languageserver_detect(
    Sys.getpid(),
    tolower(Sys.info()[["sysname"]]),
    "blabla"
  ),
  FALSE
)
