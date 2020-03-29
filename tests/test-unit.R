if (requireNamespace("tinytest", quietly = TRUE)) {
  tinytest::test_package(
    "languageserversetup",
    testdir = "test-unit"
  )
}
