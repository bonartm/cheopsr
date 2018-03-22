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
l <- readRDS("./tmp/lapply.rds")
cl <- snow::makeMPIcluster(Rmpi::mpi.universe.size()-1, outfile = "")
loadPackagesOnCluster(cl, l$packages)

if (l$load.balancing){
  logger("start load balanced calculation")
  res <- do.call(clusterApplyLB, c(list(cl = cl, x = l$x, fun = l$fun), l$args))
} else {
  logger("start calculation")
  res <- do.call(clusterApply, c(list(cl = cl, x = l$x, fun = l$fun), l$args))
}
logger("save results")
out <- paste0("./", l$jobname, "/res.rds")
saveRDS(res, out)

logger("stop cluster")
stopCluster(cl)
mpi.exit()
logger("end script")
