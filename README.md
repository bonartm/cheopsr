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

## usage
```R
library(cheopsr)

# set some global options
options(cheopsr.username = "...") # university username to log into the cluster
options(cheopsr.account = "...") # account which should be charged when submitting jobs defaults to "UniKoeln"
options(cheopsr.key = "...") # location of the private key file defaults to "~/.ssh/id_rsa"

# install the snow package and other packages you need on the cluster
cheops_install("snow")

# a template for a script file usning the MPI cluster can be found at:
system.file("R", "test.R", package = "cheopsr")

# define options and submit the job
opt <- cheops_slurmcontrol(nodes = 2, tasks = 8, mem = "1gb", time = "00:00:20", partition = "devel")
job <- cheops_lapply(rep(100, 1000), function(n){
  mean(rnorm(n))
}, options = opt, jobname = "clustertest")

cheops_jobs()

# read the log file while job is running
cat(cheops_getlog(job$name), sep = "\n")

# wait until job is finished and get the results
res <- cheops_readRDS(job$results)

# visualize the result
hist(unlist(res))
````
