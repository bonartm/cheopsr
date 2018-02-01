# cheopsr - talk to the cheops hpc cluster in R

## features
- set up an R library on the cluster and install packages via CRAN and github
- send and receive files
- submit and cancel jobs from within R (currently only MPI jobs are supported)
- call a parallel `lapply` function on the cluster without writing a script file
- check the status of your running jobs

## requirements
- a [user account](https://rrzk.uni-koeln.de/hpc.html?&L=1) for the CHEOPS cluster
- connection to the university network (e.g. via vpn)
- a unix system (see [OpenSSH](https://www.openssh.com/users.html))
- an `ssh` key-pair on the private machine and the cluster to avoid entering passwords manually all the time


## installation
```R
install.packages("devtools")
devtools::install_github("bonartm/cheopsr")
?cheopsr
````

## call a parallel `lapply` function on the cluster
```R
library(cheopsr)

# set some global options
options(cheopsr.username = "...") # university username to log into the cluster
options(cheopsr.account = "...") # account which should be charged when submitting jobs defaults to "UniKoeln"
options(cheopsr.key = "...") # location of the private key file defaults to "~/.ssh/id_rsa"

# define slurm options and submit the job
opt <- cheops_slurmcontrol(nodes = 2, tasks = 8, mem = "1gb", time = "00:00:20", partition = "devel")
cheops_lapply(rep(100, 100), fun = rnorm, options = opt)
cheops_jobs()

# when job terminated, read in the result
cheops_readRDS("./tmp/res.rds")
```

## execute a custom r script on the cluster
```R
library(cheopsr)

# set some global options
options(cheopsr.username = "...") # university username to log into the cluster
options(cheopsr.account = "...") # account which should be charged when submitting jobs defaults to "UniKoeln"
options(cheopsr.key = "...") # location of the private key file defaults to "~/.ssh/id_rsa"

# read in a test R script
script <- system.file("R", "test.R", package = "cheopsr")

# when writing scripts use the `Rmpi` and the `snow` package and define a cluster with `cl <- makeMPIcluster(mpi.universe.size()-1)`

# install the snow package to run an MPI cluster
cheops_install("snow")

# define options and submit the job
opt <- cheops_slurmcontrol(nodes = 2, tasks = 8, mem = "1gb", time = "00:00:20", partition = "devel")
id <- cheops_submit("test", script, opt)
cheops_jobs()

# wait until job is finished and read log file
cat(cheops_getlog("test"), sep = "\n")
````
