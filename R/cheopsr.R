.onAttach <- function(libname, pkgname) {
  if (Sys.info()["sysname"] != "Linux")
    packageStartupMessage("The cheopsr package only works with a linux system.")
}

.onLoad <- function(libname, pkgname) {
  op <- options()
  op.cheopsr <- list(
    cheopsr.keyfile = "~/.ssh/id_rsa",
    cheopsr.username = "user",
    cheopsr.libloc = "./R/3.3.3_intel_mkl"
  )
  toset <- !(names(op.cheopsr) %in% names(op))
  if(any(toset)) options(op.cheopsr[toset])


  invisible()

}
