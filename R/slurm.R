#' Submit a sbatch job to the cluster
#'
#' @param jobname name of the job
#' @param rscript location of the r script file to be executed
#' @param options named list of cluster options generated by {\link[cheopsr]{cheops_slurmcontrol}}
#' @param module name of r module to be loaded
#' @param account name of the account to be charged
#' @param lib location of the r lib on the cluster
#'
#' @return a numeric job id
#' @export
cheops_submit <- function(jobname, rscript, options,
                          module = getOption("cheopsr.module"),
                          account = getOption("cheopsr.account"),
                          lib = getOption("cheopsr.libloc")){
  if(nchar(jobname) > 8){
    stop("jobname is too long. maximum is 8 chars.")
  }

  if(jobname %in% cheops_jobs()$NAME){
    stop("job with this name allready exists.")
  }

  cheops_jobscript(jobname, options, module, account, lib)
  cheops_send(rscript, paste0("./", jobname,"/", "script.R"))
  job <- cheops_ssh(paste0("sbatch ", jobname, "/job.sh"))
  job <- gsub("Submitted batch job ", "", job)
  return(as.numeric(job))
}

#' Make a parallel load balancing lapply call on the cluster
#'
#' @param x a vector or list, see \link[parallel]{clusterApply}
#' @param fun a function, see \link[parallel]{clusterApply}
#' @param options named list of cluster options generated by {\link[cheopsr]{cheops_slurmcontrol}}
#' @param jobname name of the job as character string
#' @param args optionally a list of additional arguments passed to \code{fun} via {\link[base]{do.call}}
#' @param packages character vector of package names to be loaded on the cluster
#' @param load.balancing logical indicating if \link[parallel]{clusterApplyLB} or \link[parallel]{clusterApply} should be used
#' @param module name of r module to be loaded
#' @param account name of the account to be charged
#' @param lib location of the r lib on the cluster
#'
#' @details starts a slurm job on the cluster.
#' after the job is terminated, results have to be retrieved manually with the command: \code{cheops_readRDS(<filepath>)}.
#'
#' @return a named list with the name and id of the job and the file path on the cluster for the results
#' @export
cheops_lapply <- function(x, fun, options, jobname,
                          args = list(),
                          packages = c(),
                          load.balancing = TRUE,
                          module = getOption("cheopsr.module"),
                          account = getOption("cheopsr.account"),
                          lib = getOption("cheopsr.libloc")){

  out <- paste0("./", jobname)
  cheops_mkdir(out)
  cheops_saveRDS(list(x = x, fun = fun, args = args, packages = packages, jobname = jobname, load.balancing = load.balancing), paste0(out, "/lapply.rds"))
  script <- system.file("R", "parLapply.R", package = "cheopsr")
  id <- cheops_submit(jobname, script, options, module, account, lib)
  results <- paste0(out, "/res.rds")
  return(list(name = jobname, id = id, results = results))
}

#' Run a function on the cluster
#'
#' @param fun a function. The function must accept an argument with the name \code{cl}
#' @param options named list of cluster options generated by {\link[cheopsr]{cheops_slurmcontrol}}
#' @param jobname name of the job as character string
#' @param args optionally a list of additional arguments passed to \code{fun} via {\link[base]{do.call}}
#' @param packages character vector of package names to be loaded on the cluster
#' @param module name of r module to be loaded
#' @param account name of the account to be charged
#' @param lib location of the r lib on the cluster
#' @seealso {\link[parallel]{parLapplyLB}}
#'
#' @details starts a slurm job on the cluster.
#' after the job is terminated, results have to be retrieved manually with the command: \code{cheops_readRDS(<filepath>)}.
#'
#' @return a named list with the name and id of the job and the file path on the cluster for the results
#' @export
cheops_run <- function(fun, options, jobname, args = list(),
                       packages = c(),
                       module = getOption("cheopsr.module"),
                       account = getOption("cheopsr.account"),
                       lib = getOption("cheopsr.libloc")){
  out <- paste0("./", jobname)
  cheops_mkdir(out)
  cheops_saveRDS(list(fun = fun, args = args, packages = packages, jobname = jobname), paste0(out, "/run.rds"))
  script <- system.file("R", "run.R", package = "cheopsr")
  id <- cheops_submit(jobname, script, options, module, account, lib)
  results <- paste0(out, "/res.rds")
  return(list(name = jobname, id = id, results = results))
}


