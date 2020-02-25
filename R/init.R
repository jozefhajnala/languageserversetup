.onLoad <- function(libName, pkgName) {
  options(
    langserver_library = path.expand("~/languageserver-library"),
    langserver_processPatt = "languageserver::run",
    langserver_quiet = FALSE
  )
}
