askYesNo <- if ( # nocov start
  is.element("package:utils", utils::find("askYesNo", mode = "function"))
) {
  utils::askYesNo
} else {
  function(
    msg,
    default = TRUE,
    prompts = getOption("askYesNo", gettext(c("Yes", "No", "Cancel"))),
    ...
  ) {
    if (is.character(prompts) && length(prompts) == 1)
      prompts <- strsplit(prompts, "/")[[1]]
    if (!is.character(prompts) || length(prompts) != 3) {
      fn <- match.fun(prompts)
      return(fn(
        msg = msg,
        default = default,
        prompts = prompts,
        ...
      ))
    }
    choices <- tolower(prompts)
    if (is.na(default))
      choices[3L] <- prompts[3L]
    else if (default)
      choices[1L] <- prompts[1L]
    else
      choices[2L] <- prompts[2L]
    msg1 <- paste0("(", paste(choices, collapse = "/"), ") ")
    if (nchar(paste0(msg, msg1)) > 250) {
      cat(msg, "\n")
      msg <- msg1
    }
    else
      msg <- paste0(msg, " ", msg1)
    ans <- readline(msg)
    match <- pmatch(tolower(ans), tolower(choices))
    if (!nchar(ans))
      default
    else if (is.na(match))
      stop("Unrecognized response ", dQuote(ans))
    else
      c(TRUE, FALSE, NA)[match]
  }
} # nocov end

trimws <- if ( # nocov start
  is.element("package:base", utils::find("trimws", mode = "function"))
) {
  base::trimws
} else {
  function(x, which = c("both", "left", "right")) {
    which <- match.arg(which)
    mysub <- function(re, x) sub(re, "", x, perl = TRUE)
    if (which == "left")
      return(mysub("^[ \t\r\n]+", x))
    if (which == "right")
      return(mysub("[ \t\r\n]+$", x))
    mysub("[ \t\r\n]+$", mysub("^[ \t\r\n]+", x))
  }
} # nocov end

isFALSE <- if ( # nocov start
  is.element("package:base", utils::find("isFALSE", mode = "function"))
) {
  base::isFALSE
} else {
  function(x) is.logical(x) && length(x) == 1L && !is.na(x) && !x
} # nocov end
