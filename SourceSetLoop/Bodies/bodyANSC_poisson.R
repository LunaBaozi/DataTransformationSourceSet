## LOOP ####
## NOTE: Anscombe residuals do not vary on distribution,
## they remain equal in Poisson and NegBin cases
source('~/Scrivania/DataTransformationSourceSet/SourceSetLoop/poisson_data_gen.R')

order_object <- function(sim1,sim2,n){
  
  x1 <- t(sim1$X)
  x2 <- t(sim2$X)
  X <- rbind(x1, x2)
  X <- cbind(X, rep(c(1, 2), each = n))
  
}

sim_data <- function(W1,W2,n,p){
      sim1 <- XMRF.Sim(B = W1, n = n, p = p, model = 'LPGM', graph.type = 'scale-free')
      sim2 <- XMRF.Sim(B = W2, n = n, p = p, model = 'LPGM', graph.type = 'scale-free')
      
      X <- order_object(sim1,sim2,n)
}



fit_pois_anscombe <- function(obj){

  m <- apply(obj[,1:5], 2, function(x) glm(x ~ 1, family = poisson))
  
  res <- lapply(m, function(x) anscombe.residuals(x, phi = 1))
  
}

order_res <- function(obj, res){
  
      data_all <- matrix(c(res[[1]], res[[2]], res[[3]], res[[4]], res[[5]]), 800, 5)
      classes <- obj[,6] 
      data_cond1 <- data_all[1:400,]
      data_cond2 <- data_all[401:800,]
      colnames(data_all) <- c('A', 'B', 'C', 'D', 'E')
      rownames(data_all) <- c(1:800)

      return(list(all = data_all, cond1 = data_cond1, cond2 = data_cond2, classes=classes))
}



# W1 <- as(W1, 'graphNEL')
# 
# graphs <- list(W1 = W1)
# 
# 
# result <- sourceSet(graphs, data_all, classes, seed = 1234,
#                     permute = TRUE, shrink = TRUE)
# print(paste0('Analyzing Anscombe data... iteration #', i))
# 
# info_all <- infoSource(result, map.name.variable = nodes(graphs$W1))
