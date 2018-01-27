#' Title
#'
#' @return
#' @export
#'
#' @examples
cheops_ping <- function(){
    tryCatch(system("ping cheops.rrz.uni-koeln.de -c 1 -w 1", intern = TRUE),
             warning = function(w) stop("CHEOPS cluster is not responding - are you connected to the university network?", call. = FALSE))
  invisible()
}


#' Title
#'
#' @param ronly
#'
#' @return
#' @export
#'
#' @examples
cheops_module_avail <- function(ronly = TRUE){
  modules <- cheops_ssh("module -t avail")
  modules <- modules[-grep("/opt", modules, fixed = TRUE)]
  if (ronly){
    modules[grep("R/", modules)]
  } else {
    modules
  }
}

# cheops_lib <- function(lib = getOption("cheopsr.libloc")){
#   res <- tryCatch(
#     cheops_ssh(paste("[ -d", lib, "]")),
#     error = function(e) {
#       message("new library folder is created")
#       cheops_ssh(paste("mkdir", lib))
#     }
#   )
#   return(TRUE)
# }

#' Title
#'
#' @param path
#'
#' @return
#' @export
#'
#' @examples
cheops_create <- function(path){
  cheops_ssh(paste("mkdir -p", path))
}

#' Title
#'
#' @param package
#' @param module
#'
#' @return
#' @export
#'
#' @examples
cheops_install <- function(package, module){
  cheops_sendscript("install.sh")
  module <- getOption("cheopsr.module")
  lib <- getOption("cheopsr.libloc")
  cheops_ssh(paste("./tmp/install.sh", module, lib, package))
}

cheops_script <- function(name){
  cheops_create("./tmp")
  from <- system.file("bash", name, package = "cheopsr")
  to <- paste0("./tmp/", name)
  cheops_send(from, to)
  cheops_ssh(paste0("chmod +x ./tmp/", name))
}

#' Title
#'
#' @param repo
#' @param ref
#'
#' @return
#' @export
#'
#' @examples
cheops_install_github <- function(repo, ref){
  cheops_sendscript("install_github.sh")
  module <- getOption("cheopsr.module")
  lib <- getOption("cheopsr.libloc")
  cheops_ssh(paste("./tmp/install_github.sh", module, lib, repo, ref))
}

#' Title
#'
#' @param c
#'
#' @return
#' @export
#'
#' @examples
cheops_ssh <- function(c){
  cheops_ping()
  user <- getOption("cheopsr.username")
  key <- getOption("cheopsr.keyfile")
  c <- paste0("-i ", key, " ", user, "@cheops.rrz.uni-koeln.de ", c)
  tryCatch(
    out <- system2("ssh", c, wait = TRUE, stdout = TRUE, stderr = TRUE),
    warning = function(w) stop("ssh command failed", call. = FALSE),
    error = function(e) stop("ssh command failed", call. = FALSE)
  )
  out
}

#' Title
#'
#' @param from
#' @param to
#'
#' @return
#' @export
#'
#' @examples
cheops_send <- function(from, to){
  checkServer()
  user <- getOption("cheopsr.username")
  key <- getOption("cheopsr.keyfile")
  c <- paste0("-i ", key," ", from," ", user, "@cheops.rrz.uni-koeln.de:", to)
  system2("scp", c, stdout = TRUE, stderr = TRUE)
}

#' Title
#'
#' @param from
#' @param to
#'
#' @return
#' @export
#'
#' @examples
cheops_get <- function(from, to){
  checkServer()
  user <- getOption("cheopsr.username")
  key <- getOption("cheopsr.keyfile")
  c <- paste0("-i ", key," ", user, "@cheops.rrz.uni-koeln.de:", from, " ", to)
  system2("scp", c, stdout = TRUE, stderr = TRUE)
}


#' Title
#'
#' @return
#' @export
#'
#' @examples
cheops_jobs <- function(){
  user <- getOption("cheopsr.username")
  res <- cheops_ssh(paste("squeue -u",user))
  res <- read.table(textConnection(res), header = TRUE)
  return(res)
}

# runJob <- function(keyfile, jobScript, rScript, dir = "./tmp"){
#   name <- basename(rScript)
#   to <- paste0(dir, "/", name)
#   cheopsSSH(keyfile, paste0("rm -r -f ", dir))
#   cheopsSSH(keyfile, paste0("mkdir ", dir))
#   cheopsSendFile(keyfile, jobScript, paste0(dir, "/job.sh"))
#   cheopsSendFile(keyfile, rScript, to)
#   job <- cheopsSSH(keyfile, paste0("sbatch ", dir, "/job.sh"))
#   cat(job, "\n")
#   job <- as.numeric(gsub("Submitted batch job ", "", job))
#   return(job)
# }
#
# cancelJob <- function(keyfile, id){
#   cheopsSSH(keyfile, paste0("scancel ", id))
# }
#
# cancelAllJobs <- function(keyfile){
#   lapply(checkJobs(keyfile)$JOBID, function(id) cancelJob(keyfile, id))
# }
