#' Install a package on the cluster
#'
#' @details if the lib does not exist, a folder is created
#'
#' @param package name of the package as a character string
#' @param module r module to be loaded
#' @param lib lib location on the cluster
#'
#' @return nothing
#' @export
cheops_install <- function(package,
                           module = getOption("cheopsr.module"),
                           lib = getOption("cheopsr.libloc")){
  cheops_mkdir(lib)
  cheops_script("install.sh")
  out <- cheops_ssh(paste("./tmp/install.sh", module, lib, package), "", "")
  cheops_rm("./tmp")
  invisible()
}

#' Install a package from github on the cluster
#'
#' @details if the lib does not exist, a folder is created
#'
#' @param repo name of the repository e.g. <user>/<reponame>
#' @param ref name of the branch
#' @param module r module to be loaded
#' @param lib lib location on the cluster
#'
#' @return nothing
#' @details the {\link[devtools]{devtools}} package has to be installed on the cluster
#' @seealso {\link[devtools]{install_github}}
#' @export
cheops_install_github <- function(repo, ref = "master",
                                  module = getOption("cheopsr.module"),
                                  lib = getOption("cheopsr.libloc")){
  cheops_mkdir(lib)
  cheops_script("install_github.sh")
  out <- cheops_ssh(paste("./tmp/install_github.sh", module, lib, repo, ref), "", "")
  cheops_rm("./tmp")
  invisible()
}
