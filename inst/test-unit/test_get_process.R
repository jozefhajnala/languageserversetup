expect_equal(
  languageserversetup:::get_process_args(os = "windows")$what,
  "system"
)

expect_equal(
  languageserversetup:::get_process_args(os = "linux")$what,
  "system2"
)

expect_equal(
  languageserversetup:::get_process_args(os = "somethingelse")$what,
  "system2"
)

expect_equal(
  languageserversetup:::get_process_args(os = "darwin")$args$command,
  "ps"
)

expect_equal(
  languageserversetup:::get_process_args(os = "linux")$args$command,
  "ps"
)

expect_equal(
  languageserversetup:::get_process_args(os = "windows", pid = 1)$args$command,
  "wmic process where processid=1 get commandline"
)

expect_equal(
  languageserversetup:::get_process_args(os = "windows", pid = 1)$args$intern,
  TRUE
)

expect_true(
  is.list(languageserversetup:::get_process_args(os = NULL)$args) &&
    length(languageserversetup:::get_process_args(os = NULL)$args) == 3L
)

expect_true(
  is.list(languageserversetup:::get_process_args(os = NA)$args) &&
    length(languageserversetup:::get_process_args(os = NA)$args) == 3L
)

expect_true(
  is.list(languageserversetup:::get_process_args(os = "")$args) &&
    length(languageserversetup:::get_process_args(os = "")$args) == 3L
)

expect_equal(
  languageserversetup:::get_process_args(os = NULL)$args$command,
  "ps"
)

expect_equal(
  languageserversetup:::get_process_args(os = "windows", pid = "1")$args,
  list(
    command = "wmic process where processid=1 get commandline",
    intern = TRUE,
    ignore.stdout = FALSE
  )
)

expect_equal(
  languageserversetup:::get_process_args(os = "linux", pid = "1")$args,
  list(
    command = "ps",
    args = c("-p", "1", "-o", "command", "--no-headers"),
    stdout = TRUE
  )
)

expect_equal(
  languageserversetup:::get_process_args(os = "darwin", pid = "1")$args,
  list(command = "ps", args = c("-p", "1", "-o", "command"), stdout = TRUE)
)

expect_equal(
  languageserversetup:::get_process_args(os = "unknown", pid = "1")$args,
  list(
    command = "ps",
    args = c("-p", "1", "-o", "command", "--no-headers"),
    stdout = TRUE
  )
)

expect_equal(
  languageserversetup:::wmic_cleanup(
    c(
      "CommandLine    \r",
      "\"C:\\sw\\RStudio\\bin\\rsession.exe\"  --config-file \r",
      "\r"
    )
  ),
  "\"C:\\sw\\RStudio\\bin\\rsession.exe\"  --config-file"
)

expect_equal(
  languageserversetup:::wmic_cleanup(
    c("ParentProcessId  \r", "9452             \r", "\r")
  ),
  "9452"
)

expect_equal(
  languageserversetup:::get_process_args(
    os = "windows", "1", parent = TRUE
  )$args$command,
  "wmic process where processid=1 get parentprocessid"
)

expect_equal(
  languageserversetup:::get_process_args("linux", 1, parent = TRUE)$args$args,
  "-o ppid= 1"
)

expect_equal(
  languageserversetup:::get_process_args("windows", 1, output = FALSE)$args,
  list(
    command = "wmic process where processid=1 get commandline",
    intern = FALSE,
    ignore.stdout = TRUE
  )
)
