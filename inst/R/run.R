library(Rmpi)
library(snow)

loadPackagesOnCluster <- function(cl, packages){
  snow::clusterExport(cl, "packages", envir = environment())
  res <- snow::clusterEvalQ(cl, invisible(lapply(packages, library, character.only = TRUE, logical.return = TRUE, quietly = TRUE)))
  all(unlist(res))
}

logger <- function(...){
  cat("[", format(Sys.time()), "]", ..., "\n")
}

logger("initialize cluster")
l <- readRDS("./tmp/run.rds")
cl <- snow::makeMPIcluster(Rmpi::mpi.universe.size()-1)
loadPackagesOnCluster(cl, l$packages)

logger("start calculation")
res <- do.call(l$fun, c(list(cl = cl), l$args))

logger("save results")
out <- paste0("./", l$jobname, "/res.rds")
saveRDS(res, out)

logger("stop cluster")
stopCluster(cl)
mpi.exit()
logger("end script")
