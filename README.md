# cheopsr - talk to the cheops hpc cluster from within R

## features
- set up an R library on the cluster and install packages via CRAN and github
- send and receive files
- submit and cancel jobs from within R (currently only MPI jobs are supported)
- check the status of your running jobs

## requirements
- you need a user account to use the CHEOPS cluster (see [here](https://rrzk.uni-koeln.de/hpc.html?&L=1)
- this first version is limited to unix since it uses [OpenSSH](https://www.openssh.com/)
- you have to set up an `ssh` key-pair on the private machine and the cluster to avoid entering passwords manually all the time

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
options(cheopsr.username = "...") # university username to log into the cluster
options(cheopsr.account = "...") # account which should be charged when submitting jobs defaults to "UniKoeln"
options(cheopsr.key = "...") # location of the private key file defaults to "~/.ssh/id_rsa"

# read in a test R script
script <- system.file("R", "test.R", package = "cheopsr")

# install the snow package to run an MPI cluster
cheops_install("snow")

# define options and submit the job
opt <- cheops_slurmcontrol(2, 8, "1gb", "00:00:20", partition = "devel")
id <- cheops_submit("test", script, opt)
cheops_jobs()

# wait until job is finished and read log file
cat(cheops_getlog("test"), sep = "\n")
````
