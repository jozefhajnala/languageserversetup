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
  languageserversetup:::get_process_args(os = "windows", pid = "1"),
  list(
    command = "wmic",
    args = "process where processid=1 get commandline",
    stdout = TRUE
  )
)

expect_equal(
  languageserversetup:::get_process_args(os = "linux", pid = "1"),
  list(
    command = "ps",
    args = c("-p", "1", "-o", "command", "--no-headers"),
    stdout = TRUE
  )
)

expect_equal(
  languageserversetup:::get_process_args(os = "darwin", pid = "1"),
  list(command = "ps", args = c("-p", "1", "-o", "command"), stdout = TRUE)
)

expect_equal(
  languageserversetup:::get_process_args(os = "unknown", pid = "1"),
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
