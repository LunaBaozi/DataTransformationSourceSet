source('poisson_data_gen.R')

anscombe_negative_function <- function(conte, mu, dispersion){
  term1 <- (3/dispersion)*((1+dispersion*conte)^(2/3)-(1+dispersion*mu)^(2/3))
  term2 <- 3*(conte^(2/3)-mu^(2/3))
  term3 <- 2*(mu + dispersion*(mu^2))^1/6
  
  res <- (term1 + term2)/ term3
}

order_object <- function(sim1,sim2,n){
  
  x1 <- t(sim1$X)
  x2 <- t(sim2$X)
  X <- rbind(x1, x2)
  X <- cbind(X, rep(c(1, 2), each = n))
  
}

sim_data_p <- function(W1,W2,n,p, lambda_true,lambda_noisemodelgen = "poisson", gamma = 1){
  
  sim1 <- XMRF.Sim(B = W1, n = n, p = p, model = 'LPGM', graph.type = 'scale-free', lambda_true,lambda_noise,modelgen = "poisson", gamma = 1)
  sim2 <- XMRF.Sim(B = W2, n = n, p = p, model = 'LPGM', graph.type = 'scale-free', lambda_true,lambda_noise, modelgen = "poisson", gamma = 1)
  
  X <- order_object(sim1,sim2,n)
}

sim_data_nb <- function(W1,W2,n,p, mu ,mu.noise, theta){
  
  sim1 <- nbinom.Simdata(n=n, p =p ,B = W1, mu, mu.noise, theta)
  sim2 <- nbinom.Simdata(n=n, p =p ,B = W2, mu, mu.noise, theta)
  
  X <- rbind(sim1, sim2)
  X <- cbind(X, rep(c(1, 2), each = n))
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