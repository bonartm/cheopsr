#!/bin/bash -l
module load $1
export R_LIBS_USER=$2
c="devtools::install_github('$3', ref = '$4')";
Rscript --no-save --no-restore -e "$c";
