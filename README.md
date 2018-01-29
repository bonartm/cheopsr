# cheopsr - talk to the cheops hpc cluster from within R

## features
- set up an R library on the cluster and install packages via CRAN and github
- send and receive files
- submit and cancel jobs from within R (currently only MPI jobs are supported)
- check the status of your running jobs

## installation
```R
install.packages("devtools")
devtools::install_github("bonartm/cheopsr")
````

## usage
```R
library(cheopsr)
?cheopsr

# set some global options
options(cheopsr.username = "...")
options(cheopsr.account = "...")

# prepare an R script
script <- tempfile(fileext = ".R")
exp <- expression({
  library(Rmpi)
  library(snow)
  cl <- makeMPIcluster(mpi.universe.size()-1)
  clusterEvalQ(cl, {
    paste("I am",mpi.comm.rank(),"of",mpi.comm.size())
  })
  stopCluster(cl)
  mpi.quit()
})
writeLines(as.character(exp), script)

# install the snow package to run an MPI cluster
cheops_install("snow")

# define options and submit the job
opt <- cheops_slurmcontrol(2, 8, "1gb", "00:00:20", partition = "devel")
id <- cheops_submit("test", script, opt)
cheops_jobs()

# wait until job is finished and read log file
cat(cheops_getlog("test"), sep = "\n")
````
