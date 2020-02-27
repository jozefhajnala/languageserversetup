message("Running rhubcheck")
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1L) {
  stop("Incorrect number of args, needs 1: platform (string)")
}

platform <- args[[1L]]
if (!is.element(platform, rhub::platforms()[[1L]])) {
  stop(paste(platform, "not in rhub::platforms()[[1L]]"))
}

cr <- rhub::check(platform = platform, show_status = TRUE)
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
print(res)

if (any(colSums(res[2L:4L]) > 0)) {
  stop("Some checks with errors, warnings or notes.")
}
