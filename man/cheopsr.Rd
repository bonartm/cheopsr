% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cheopsr.R
\docType{package}
\name{cheopsr}
\alias{cheopsr}
\alias{cheopsr-package}
\title{Talk to the HPC cluster at the University of Cologne.}
\description{
Talk to the HPC cluster at the University of Cologne.
}
\section{Package options}{

cheops r uses the folowing {\link[base]{options}} to set and read user parameters:
\itemize{
\item \code{cheopsr.key = "~/.ssh/id_rsa"}: ssh key location to log into the CHEOPS cluster. This option must be set!
\item \code{cheopsr.username = "user"}: user name to log into the CHEOPS cluster. This option must be set!
\item \code{cheopsr.libloc = "./R/3.3.3_intel_mkl"}: location of the personal R library on the cluster
\item \code{cheopsr.module = "R/3.3.3_intel_mkl"}: default R module which should be used when submitting jobs
\item \code{cheopsr.account = "UniKoeln"}: account which should be charged when submitting jobs
}
}

