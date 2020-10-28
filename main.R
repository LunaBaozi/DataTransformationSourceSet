starting <- function(res,data, W){
  
  object <- lapply(res, function(x) order_res(data, x))
  
  W1 <- as(W1, 'graphNEL')
  
  graphs <- list(W1 = W1)
  
  result <- mclapply(object, function(x) sourceSet(graphs, x$all, x$classes, seed = 1234,
                                                   permute = TRUE, shrink = TRUE),mc.cores = number_cores)
  
  info_all <- lapply(result, function(x) infoSource(x, map.name.variable = nodes(graphs$W1)))
  
  primaryset <- lapply(result, function(x) list(x$W1$primarySet))
  
  return(list(result = result, info_all = info_all, primary = primaryset))
  
}

right_case <- function(result,sumup,i){
  ## Checks if primary set is correctly (A, B)
  if (all(c('A','B') %in% result$W1$primarySet) & all(c('C','D','E') %notin% result$W1$primarySet)){
    sumup[i, 6] <- 1
  }
  
  ## Checks if primary set contains other nodes than (A, B)
  if (all(c('A','B') %in% result$W1$primarySet) & any(c('C','D','E') %in% result$W1$primarySet)){
    sumup[i, 7] <- 1
  }
  
  
  ## Checks if there is A, not B, and others
  if (('A' %in% result$W1$primarySet & 'B' %notin% result$W1$primarySet) & any(c('C','D','E') %in% result$W1$primarySet)){
    sumup[i, 8] <- 1
  }
  
  
  ## Checks if there is not A, yes B and others
  
  if (('A' %notin% result$W1$primarySet & 'B' %in% result$W1$primarySet) & any(c('C','D','E') %in% result$W1$primarySet)){
    sumup[i, 9] <- 1
  }
  
  ## Checks if there is not A, nor B but others
  if (all(c('A','B') %notin% result$W1$primarySet) & any(c('C','D','E') %in% result$W1$primarySet)){
    sumup[i, 10] <- 1
  }
  
  
  ## Checks if primary set is empty
  if (all(c('A','B','C','D','E') %notin% result$W1$primarySet)){
    sumup[i, 11] <- 1
  }
  
  
  ## Checks if primary set is full
  if (all(c('A','B','C','D','E') %in% result$W1$primarySet)){
    sumup[i, 12] <- 1
  }
  
  ## Checks if primary set is single
  if (length(result$W1$primarySet) == 1){
    sumup[i, 13] <- 1
  }
  
  sumup
}


summarize <- function(values, sumup,i){
  
  sumup <- lapply(1:10, function(x){
    sumup[[x]][i,1:5] <- values$info_all[[x]]$variable[1:5,8];
    sumup[[x]]
  })
  
  sumup <- lapply(1:10, function(x){sumup <- right_case(values$result[[x]],sumup[[x]],i);
  sumup
  })
  
  
}


main <- function(n_simulation,n,p,lambda_true, lambda_noise, number_cores){
  
  sumup <- lapply(1:10, function(x) matrix(0, n_simulation, 13))
  
  sumup <- lapply(sumup, function(x) {
    colnames(x) <- c('ptA', 'ptB', 'ptC', 'ptD', 'ptE',
                     'AB', 'AB+al.', 'A+al.', 'B+al.', 'Other', 'Empty', 'Full',
                     'Single');
    x
  })
  
  primary <- list()
  
  for (i in 1:n_simulation){
    
    start <- Sys.time()
    
    set.seed(i)
    data <- sim_data(W1,W2,n,p)
    
    transformation <- list(fit_raw, fit_sqrt, fit_log,
                           fit_negative_dev, fit_pois_dev,
                           fit_negative_pearson, fit_pois_pearson,
                           fit_pois_anscombe,
                           fit_negative_RQR, fit_pois_RQR)
    
    res <- lapply(transformation, function(x) x(data))
    
    values <- starting(res, data, W)
    
    primary <- append(primary,list(values$primary))
    
    sumup <- summarize(values, sumup,i)
    
    finish <- Sys.time()
    
    message("Iteration number ", i)
    message("Time consumption ",finish-start)
  }
  
  ## Create a new matrix to store the mean values of the scores
  ## and the count of occurrences of each class
  
  newmatrix <- lapply(1:10, function(x) matrix(0, nrow=1, ncol=13))
  newmatrix <- lapply(1:10, function(x){newmatrix[[x]][,1:5] <- apply(sumup[[x]][,1:5],2,mean);newmatrix[[x]]})
  newmatrix <- lapply(1:10, function(x){newmatrix[[x]][,6:13] <- apply(sumup[[x]][,6:13],2,function(x) sum(x==1));newmatrix[[x]]})
  
  
  percent <- lapply(1:10, function(x) matrix(0, nrow=1, ncol=13))
  percent <- lapply(1:10, function(x){percent[[x]][1:5] <- apply(sumup[[x]][,1:5],2,mean);percent[[x]]})
  percent <- lapply(1:10, function(x){percent[[x]][6:13] <- apply(sumup[[x]][,6:13],2,function(x) sum(x==1)/50);percent[[x]]})
  
  
  endtable_counts <- matrix(unlist(newmatrix),nrow=10,byrow=T)
  
  endtable_percent <- matrix(unlist(percent),nrow=10,byrow=T)
  
  names <- list("RAW", "SQRT", "LOG",
                "NB_DEV", "POIS_DEV",
                "NB_PEAR", "POIS_PEAR",
                "POIS_ANSC",
                "NB_RQR", "POIS_RQR")
  
  names(sumup) <- names
  
  colnames <- c('ptA', 'ptB', 'ptC', 'ptD', 'ptE',
                'AB', 'AB+al.', 'A+al.', 'B+al.', 'Other', 'Empty', 'Full',
                'Single')
  
  
  
  
  colnames(endtable_counts)<-colnames(endtable_percent)<- colnames 
  
  rownames(endtable_counts) <- rownames(endtable_percent) <- names
  
  return(list(table_fin = endtable_counts, perc_fin = endtable_percent, primary = primary, sum_table = sumup))
}