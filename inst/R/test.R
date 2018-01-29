library(Rmpi)
library(snow)
library(parallel)
library(MASS)

cl <- makeMPIcluster(mpi.universe.size()-1)

clusterEvalQ(cl, {
  paste(mpi.comm.rank()," of ",mpi.comm.size())
})

stopCluster(cl)
mpi.quit()
