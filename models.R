fit_pois_anscombe <- function(obj){
  
  m <- apply(obj[,1:5], 2, function(x) glm(x ~ 1, family = poisson))
  
  res <- lapply(m, function(x) anscombe.residuals(x, phi = 1))
  
}
                
fit_negative_anscombe <- function(obj){
  
  m <- apply(obj[,1:5], 2, function(x) glm(x ~ 1, family = negative.binomial(theta = 1)))
             
  res <- lapply(m, function(x) anscombe.residuals(x, phi = 1))
}

fit_negative_dev <- function(obj){
  
  m <- apply(obj[,1:5], 2, function(x) glm(x ~ 1, family = negative.binomial(theta = 1)))
  
  res <- lapply(m, function(x) resid(x))
  
}


fit_pois_dev <- function(obj){
  
  m <- apply(obj[,1:5], 2, function(x) glm(x ~ 1, family = poisson))
  
  res <- lapply(m, function(x) resid(x))
  
}

fit_log <- function(obj){
  
  m <- log1p(obj[,1:5])
  
  res <- list(m[,1], m[,2], m[,3],m[,4],m[,5])
  
}

fit_negative_pearson <- function(obj){
  
  m <- apply(obj[,1:5], 2, function(x) glm(x ~ 1, family = negative.binomial(theta = 1)))
  
  res <- lapply(m, function(x) resid(x, type = 'pearson'))
  
}

fit_raw <- function(obj){
  
  m <- obj[,1:5]
  
  res <- list(m[,1], m[,2], m[,3],m[,4],m[,5])
  
}


fit_negative_RQR <- function(obj){
  
  m <- apply(obj[,1:5], 2, function(x) glm(x ~ 1, family = negative.binomial(theta = 1)))
  
  res <- lapply(m, function(x) qres.nbinom(x))
  
}

fit_pois_RQR <- function(obj){
  
  m <- apply(obj[,1:5], 2, function(x) glm(x ~ 1, family = poisson))
  
  res <- lapply(m, function(x) qres.pois(x))
  
}

fit_pois_pearson <- function(obj){
  
  m <- apply(obj[,1:5], 2, function(x) glm(x ~ 1, family = poisson))
  
  res <- lapply(m, function(x) resid(x, type = 'pearson'))
  
}

fit_sqrt <- function(obj){
  
  m <- sqrt(obj[,1:5])
  
  res <- list(m[,1], m[,2], m[,3],m[,4],m[,5])
}
