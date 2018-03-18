#!/bin/bash -l
module load $1
c="install.packages('$3', lib = '$2', repos = 'http://cran.rstudio.com')";
echo $c;
R --vanilla --slave -e "$c";
