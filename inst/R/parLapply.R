loadPackagesOnCluster <- function(cl, packages){
  snow::clusterExport(cl, "packages", envir = environment())
  res <- snow::clusterEvalQ(cl, invisible(lapply(packages, library, character.only = TRUE, logical.return = TRUE)))
  all(unlist(res))
}

l <- readRDS("./tmp/lapply.rds")
cl <- snow::makeMPIcluster(Rmpi::mpi.universe.size()-1)
loadPackagesOnCluster(cl, l$packages)
res <- do.call(parallel::parLapplyLB, c(list(cl = cl, X = l$x, fun = l$fun), l$args))
saveRDS(res, "./tmp/res.rds")
snow::stopCluster(cl)
Rmpi::mpi.quit()
