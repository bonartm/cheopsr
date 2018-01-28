# cheopsr - talk to the cheops hpc cluster from within R

## features
- set up an R library and install packages via CRAN and github
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

# set some minimal options
options(cheopsr.username = <...>)
options(cheopsr.key = <...>)

?cheopsr

````
