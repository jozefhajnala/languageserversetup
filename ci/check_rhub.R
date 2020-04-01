message("Running rhubcheck")
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1L) {
  stop("Incorrect number of args, needs 1: platform (string)")
}

platform <- args[[1L]]
if (!is.element(platform, c("cran", rhub::platforms()[[1L]]))) {
  stop(paste(platform, "not in rhub::platforms()[[1L]] nor cran"))
}

if (platform == "cran") {
  system("apt-get update && apt-get -y install libxml2-dev")
  install.packages("xml2")
  cr <- rhub::check_for_cran(
    show_status = TRUE,
    env_vars = c(
      `_R_CHECK_CRAN_INCOMING_REMOTE_` = "false",
      Sys.getenv("LANGSERVERSETUP_RUN_DEPLOY", names = TRUE)
    )
  )
} else {
  cr <- rhub::check(
    platform = platform,
    show_status = TRUE,
    env_vars = Sys.getenv("LANGSERVERSETUP_RUN_DEPLOY", names = TRUE)
  )
}
statuses <- cr[[".__enclos_env__"]][["private"]][["status_"]]

res <- do.call(rbind, lapply(statuses, function(thisStatus) {
  data.frame(
    plaform  = thisStatus[["platform"]][["name"]],
    errors   = length(thisStatus[["result"]][["errors"]]),
    warnings = length(thisStatus[["result"]][["warnings"]]),
    notes    = length(thisStatus[["result"]][["notes"]]),
    stringsAsFactors = FALSE
  )
}))

message("\n\nTrying to print check results")
print(res)


message("\n\nTrying to print detailed test results")
message("Determining Candidate URLs and download destinations")
testCandidates <- do.call(rbind, lapply(
  cr$urls()$artifacts,
  function(thisUrl) {
    testFile <- tools::file_path_sans_ext(dir("./tests/"))
    data.frame(
      url = file.path(
        thisUrl,
        paste0(unique(sapply(statuses, `[[`, "package"))[[1L]], ".Rcheck"),
        "tests",
        c(paste0(testFile, ".Rout"), paste0(testFile, ".Rout.fail"))
      ),
      fileName = paste(
        basename(thisUrl),
        c(paste0(testFile, ".Rout"), paste0(testFile, ".Rout.fail")),
        sep = "-"
      ),
      stringsAsFactors = FALSE
    )
  }
))

message("Printing Candidate URLs and download destinations: \n")
print(testCandidates)

message("Attempting do download test logs from rhub: \n")
testLogs <- apply(
  testCandidates,
  1L,
  function(x) {
    try(
      utils::download.file(x["url"], x["fileName"], quiet = TRUE),
      silent = TRUE
    )
  }
)
names(testLogs) <- testCandidates[["fileName"]]

message("Attempting do cat test logs from rhub: \n\n")
invisible(lapply(
  names(testLogs[testLogs == 0L]),
  function(x) {
    message("\n", x)
    cat(readLines(x), sep = "\n")
  }
))

if (any(colSums(res[2L:4L]) > 0)) {
  stop("Some checks with errors, warnings or notes.")
}
