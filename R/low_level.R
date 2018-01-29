cheops_script <- function(name){
  cheops_mkdir("./tmp")
  from <- system.file("bash", name, package = "cheopsr")
  to <- paste0("./tmp/", name)
  cheops_send(from, to)
  cheops_ssh(paste0("chmod +x ./tmp/", name))
}

cheops_ssh <- function(c, stdout = TRUE, stderr = TRUE){
  cheops_ping()
  user <- getOption("cheopsr.username")
  key <- getOption("cheopsr.key")
  c <- paste0("-i ", key, " ", user, "@cheops.rrz.uni-koeln.de ", c)
  tryCatch(
    out <- system2("ssh", c, wait = TRUE, stdout = stdout, stderr = stderr),
    warning = function(w) stop("ssh command failed: ", w, call. = FALSE),
    error = function(e) stop("ssh command failed: ", e, call. = FALSE)
  )
  out
}

cheops_send <- function(from, to){
  cheops_ping()
  user <- getOption("cheopsr.username")
  key <- getOption("cheopsr.key")
  c <- paste0("-i ", key," ", from," ", user, "@cheops.rrz.uni-koeln.de:", to)
  system2("scp", c, stdout = TRUE, stderr = TRUE)
}

cheops_get <- function(from, to){
  cheops_ping()
  user <- getOption("cheopsr.username")
  key <- getOption("cheopsr.key")
  c <- paste0("-i ", key," ", user, "@cheops.rrz.uni-koeln.de:", from, " ", to)
  system2("scp", c, stdout = TRUE, stderr = TRUE)
}

cheops_ping <- function(){
  tryCatch(system("ping cheops.rrz.uni-koeln.de -c 1 -w 1", intern = TRUE),
           warning = function(w) stop("CHEOPS cluster is not responding - are you connected to the university network?", call. = FALSE))
  invisible()
}

cheops_mkdir <- function(path){
  cheops_ssh(paste("mkdir -p", path))
}

cheops_rm <- function(path){
  cheops_ssh(paste("rm -r", path))
}

cheops_parse <- function(jobname, list, account){
  list <- c(list, output = paste0("./",jobname,"/log.out"), account = account, "job-name" = jobname)
  vapply(seq_along(list), function(i){
    paste0("#SBATCH --",names(list)[i], "=", list[[i]])
  }, character(1))
}

cheops_gen <- function(jobname, list, module, account, lib){
  loc <- system.file("bash", "sbatch.sh", package = "cheopsr")
  script <- c("#!/bin/bash -l",
              cheops_parse(jobname, list, account),
              paste("module load", module),
              paste0("export R_LIBS_USER=", lib),
              paste0("mpirun -q -np 1 Rscript --vanilla ./", jobname, "/script.R"))
  return(script)
}




