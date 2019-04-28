#' Get a log file from a submitted job
#'
#' @param jobname the name of the job
#'
#' @return a raw character vector containing the lines of the log file
#' @export
cheops_getlog <- function(jobname){
  from <- paste0("./", jobname, "/log.out")
  to <- tempfile()
  tryCatch(
    cheops_get(from, to),
    warning = function(w) stop("File could not be found or other error.", call. = FALSE)

  )
  readLines(to)
}

#' Restore a single R Object from the cluster
#'
#' @param file location of the .rds file on the cluster
#'
#' @return the file
#' @export
cheops_readRDS <- function(file){
  to <- tempfile(fileext = ".rds")
  tryCatch(
    cheops_get(file, to),
    warning = function(w) stop("File could not be found or other error.", call. = FALSE)

  )
  readRDS(to)
}

#' Save an object on the cluster
#'
#' @param obj R object
#' @param file location of the .rds file on the cluster
#'
#' @return nothing
#' @export
cheops_saveRDS <- function(obj, file){
  from <- tempfile(fileext = ".rds")
  saveRDS(obj, from)
  tryCatch(
    cheops_send(from, file),
    warning = function(w) stop("File could not be sent or other error.", call. = FALSE)
  )
  invisible()
}

#' Read in a table file from the cluster
#'
#' @param file location of the .txt or .csv file on the cluster
#' @param ... additional arguments passed to {\link[utils]{read.table}}
#'
#' @return a data.frame
#' @export
cheops_readtable <- function(file, ...){
  to <- tempfile(fileext = ".txt")
  tryCatch(
    cheops_get(file, to),
    warning = function(w) stop("File could not be found or other error.", call. = FALSE)
  )
  utils::read.table(file = to, ...)
}

