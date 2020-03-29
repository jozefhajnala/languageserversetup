if (requireNamespace("tinytest", quietly = TRUE)) {
  tinytest::test_package(
    "languageserversetup",
    testdir = "test-deployment",
    pattern = "deployment*\\.[rR]$"
  )
}
