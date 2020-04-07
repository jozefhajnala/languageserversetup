get_docall_args <- languageserversetup:::get_docall_args

linuxPid <- languageserversetup:::get_pid(1, "linux")

expect_equal(
  get_docall_args(linuxPid, parent = FALSE, output = FALSE),
  list(
    what = "system2",
    args = list(
      command = "ps",
      args = c("-p", "1", "-o", "command", "--no-headers"),
      stdout = FALSE
    )
  )
)

expect_equal(
  get_docall_args(linuxPid, parent = FALSE, output = TRUE),
  list(
    what = "system2",
    args = list(
      command = "ps",
      args = c("-p", "1", "-o", "command", "--no-headers"),
      stdout = TRUE
    )
  )
)

expect_equal(
  get_docall_args(linuxPid, parent = TRUE, output = TRUE),
  list(
    what = "system2",
    args = list(
      command = "ps",
      args = paste("-o", paste0("ppid= ", "1")),
      stdout = TRUE
    )
  )
)

expect_equal(
  get_docall_args(linuxPid, parent = TRUE, output = FALSE),
  list(
    what = "system2",
    args = list(
      command = "ps",
      args = paste("-o", paste0("ppid= ", "1")),
      stdout = FALSE
    )
  )
)


winPid <- languageserversetup:::get_pid(1, "windows")

expect_equal(
  get_docall_args(winPid, parent = FALSE, output = FALSE),
  list(
    what = "system",
    args = list(
      command = "wmic process where processid=1 get commandline",
      intern = FALSE,
      ignore.stdout = TRUE
    )
  )
)

expect_equal(
  get_docall_args(winPid, parent = FALSE, output = TRUE),
  list(
    what = "system",
    args = list(
      command = "wmic process where processid=1 get commandline",
      intern = TRUE,
      ignore.stdout = FALSE
    )
  )
)

expect_equal(
  get_docall_args(winPid, parent = TRUE, output = TRUE),
  list(
    what = "system",
    args = list(
      command = "wmic process where processid=1 get parentprocessid",
      intern = TRUE,
      ignore.stdout = FALSE
    )
  )
)

expect_equal(
  get_docall_args(winPid, parent = TRUE, output = FALSE),
  list(
    what = "system",
    args = list(
      command = "wmic process where processid=1 get parentprocessid",
      intern = FALSE,
      ignore.stdout = TRUE
    )
  )
)


darwinPid <- languageserversetup:::get_pid(1, "darwin")

expect_equal(
  get_docall_args(darwinPid, parent = FALSE, output = FALSE),
  list(
    what = "system2",
    args = list(
      command = "ps",
      args = c("-p", "1", "-o", "command"),
      stdout = FALSE
    )
  )
)

expect_equal(
  get_docall_args(darwinPid, parent = FALSE, output = TRUE),
  list(
    what = "system2",
    args = list(
      command = "ps",
      args = c("-p", "1", "-o", "command"),
      stdout = TRUE
    )
  )
)

expect_equal(
  get_docall_args(darwinPid, parent = TRUE, output = TRUE),
  list(
    what = "system2",
    args = list(
      command = "ps",
      args = paste("-o", paste0("ppid= ", "1")),
      stdout = TRUE
    )
  )
)

expect_equal(
  get_docall_args(darwinPid, parent = TRUE, output = FALSE),
  list(
    what = "system2",
    args = list(
      command = "ps",
      args = paste("-o", paste0("ppid= ", "1")),
      stdout = FALSE
    )
  )
)
