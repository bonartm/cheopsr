#' Options for a SLURM task
#'
#' @description
#' Generates a list of options to be used in {\link[cheopsr]{cheops_submit}}
#'
#' @param nodes Number of nodes between 1 - 128
#' @param tasks Number of tasks \strong{per} node
#' @param mem Memory per node as a string (e.g. "4gb")
#' @param time Wall time of the job in the format "hh:mm:ss"
#' @param partition On which partition the job should run
#' @param mail University Cologne mail adress for job notifications
#' #'
#' @return a named list of options
#' @export
cheops_slurmcontrol <- function(nodes, tasks, mem, time, partition = NULL, mail = NULL){
  opt <- list(nodes = nodes,
              "ntasks-per-node" = tasks,
              mem = mem,
              time = time)
  if(!is.null(mail)){
    opt <- c(opt, "mail-user" = mail, "mail-type" = "ALL")
  }
  if(!is.null(partition)){
    opt <- c(opt, partition = partition)
  }
  return(opt)
}

#' List all or R specific modules available on CHEOPS
#'
#' @param ronly a logical value indicating if only R specifig modules should be returned
#'
#' @return a vector of module names
#' @export
cheops_modules <- function(ronly = TRUE){
  modules <- cheops_ssh("module -t avail")
  modules <- modules[-grep("/opt", modules, fixed = TRUE)]
  if (ronly){
    modules[grep("R/", modules)]
  } else {
    modules
  }
}

#' List the users running SLURM jobs
#'
#' @return a table containing the currently running jobs
#' @export
cheops_jobs <- function(){
  user <- getOption("cheopsr.username")

    res <- cheops_ssh(paste("squeue -u", user))

  res <- utils::read.table(textConnection(res), header = TRUE)
  return(res)
}

#' Cancel a running SLURM job
#'
#' @param jobname name of the job
#'
#' @return a table containing the currently running jobs
#' @export
cheops_cancel <- function(jobname){
  jobs <- cheops_jobs()
  ids <- jobs$JOBID[jobs$NAME == jobname]
  for (id in ids){
    cheops_ssh(paste0("scancel ", id))
  }
  cheops_jobs()
}





