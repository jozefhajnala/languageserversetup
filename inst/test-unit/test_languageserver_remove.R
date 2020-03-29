tmpFile <- tempfile()
code <- languageserversetup:::append_code(rlsLib = "")
write(code, file = tmpFile, append = TRUE)

expect_warning(
  languageserver_remove_from_rprofile(
    rprofilePath = tmpFile,
    code = c(code[1L:3L], "Something else", code[4L:6L])
  ),
  "The code to remove is inconsistent with content."
)

unlink(tmpFile, force = TRUE)
