cheops_ping <- function(){
    tryCatch(system("ping cheops.rrz.uni-koeln.de -c 1 -w 1", intern = TRUE),
             warning = function(w) stop("CHEOPS cluster is not responding - are you connected to the university network?", call. = FALSE))
  invisible()
}

cheops_lib <- function(lib = getOption("cheopsr.libloc")){

}

cheops_install <- function(name){

}

cheops_install_github <- function(...){

}

# installFactorCopula <- function(keyfile){
#     c <- "./R/installFactorCopula.sh"
#   cheopsSSH(keyfile, c)
# }

cheops_ssh <- function(c){
  cheops_ping()
  user <- getOption("cheopsr.username")
  key <- getOption("cheopsr.keyfile")
  c <- paste0("ssh -i ", key, " ", user, "@cheops.rrz.uni-koeln.de ", c)
  system(c, intern = TRUE, wait = TRUE)
}

cheopsSendFile <- function(keyfile, from, to){
  checkServer()
  c <- paste0("scp -i ", keyfile," ", from," bonartm@cheops.rrz.uni-koeln.de:", to)
  system(c, intern = TRUE)
}

cheopsGetFile <- function(keyfile, from, to){
  checkServer()
  c <- paste0("scp -i ", keyfile," bonartm@cheops.rrz.uni-koeln.de:", from, " ", to)
  system(c, intern = TRUE)
}

checkJobs <- function(keyfile){
  res <- cheopsSSH(keyfile, "squeue -u bonartm")
  res <- read.table(textConnection(res), header = TRUE)
  return(res)
}
runJob <- function(keyfile, jobScript, rScript, dir = "./tmp"){
  name <- basename(rScript)
  to <- paste0(dir, "/", name)
  cheopsSSH(keyfile, paste0("rm -r -f ", dir))
  cheopsSSH(keyfile, paste0("mkdir ", dir))
  cheopsSendFile(keyfile, jobScript, paste0(dir, "/job.sh"))
  cheopsSendFile(keyfile, rScript, to)
  job <- cheopsSSH(keyfile, paste0("sbatch ", dir, "/job.sh"))
  cat(job, "\n")
  job <- as.numeric(gsub("Submitted batch job ", "", job))
  return(job)
}

cancelJob <- function(keyfile, id){
  cheopsSSH(keyfile, paste0("scancel ", id))
}

cancelAllJobs <- function(keyfile){
  lapply(checkJobs(keyfile)$JOBID, function(id) cancelJob(keyfile, id))
}
