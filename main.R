starting <- function(res,data, permute, graph, number_cores){
  
 object <- lapply(res, function(x) order_res(data, x, n))
  
  gh <- list()
  gh$graph <- graph
  
  result <- mclapply(object, function(x) sourceSet(gh, x$all, x$classes, seed = 1234,
                                                   permute = permute, shrink = TRUE),
                    mc.cores=number_cores)
   # result <- lapply(object, function(x) sourceSet(gh, x$all, x$classes, seed = 1234,
   #                                                 permute = permute, shrink = TRUE))
  
  
  info_all <- lapply(result, function(x) infoSource(x, map.name.variable = nodes(gh$graph)))
  
  primaryset <- lapply(result, function(x) list(x$graph$primarySet))
  
  return(list(result = result, info_all = info_all, primary = primaryset))
  
}


starting_list <- function(res,data, permute, graph, number_cores, numer){
  
  object <- lapply(res, function(x) lapply(1:length(x), function(y) order_res(data[[y]],x[[y]],numer)))
  
  
  gh <- list()
  gh$graph <- graph
  result <- mclapply(object, function(x) lapply(x, function(y) sourceSet(gh, y$all, y$classes, seed = 1234,
                                                                          permute = permute, shrink = TRUE)),mc.cores=number_cores)
  
  # result <- lapply(object, function(x) sourceSet(gh, x$all, x$classes, seed = 1234,
  #                                                 permute = permute, shrink = TRUE))
  
  info_all <- lapply(result, function(x) lapply(x,function(y) infoSource(y, map.name.variable = nodes(gh$graph))))

  
  primaryset <- lapply(result, function(x) lapply(x, function(y) list(y$graph$primarySet)))

  
  return(list(result = result, info_all = info_all, primary = primaryset))
  
}
right_case <- function(result,sumup,i){
  ## Checks if primary set is full
  if (all(c('A','B','C','D','E') %in% result$graph$primarySet)){
    sumup[i, 12] <- 1
  }
  
  ## Checks if primary set is correctly (A, B)
  if (all(c('A','B') %in% result$graph$primarySet) & all(c('C','D','E') %notin% result$graph$primarySet)){
    sumup[i, 6] <- 1
  }
  
  ## Checks if primary set contains other nodes than (A, B)
  if (all(c('A','B') %in% result$graph$primarySet) & any(c('C','D','E') %in% result$graph$primarySet)& !(all(c('A','B','C','D','E') %in% result$graph$primarySet))){
    sumup[i, 7] <- 1
  }
  
  
  ## Checks if there is A, not B, and others
  if (('A' %in% result$graph$primarySet & 'B' %notin% result$graph$primarySet) & any(c('C','D','E') %in% result$graph$primarySet)){
    sumup[i, 8] <- 1
  }
  
  
  ## Checks if there is not A, yes B and others
  if (('A' %notin% result$graph$primarySet & 'B' %in% result$graph$primarySet) & any(c('C','D','E') %in% result$graph$primarySet)){
    sumup[i, 9] <- 1
  }
  
  ## Checks if there is not A, nor B but others
  if (all(c('A','B') %notin% result$graph$primarySet) & any(c('C','D','E') %in% result$graph$primarySet)& !(length(result$graph$primarySet) == 1)){
    sumup[i, 10] <- 1
  }
  
  
  ## Checks if primary set is empty
  if (all(c('A','B','C','D','E') %notin% result$graph$primarySet)){
    sumup[i, 11] <- 1
  }
  
  
  ## Checks if primary set is single
  if (length(result$graph$primarySet) == 1){
    sumup[i, 13] <- 1
  }
  
  sumup
}


summarize <- function(values, sumup,i){
  
  sumup <- lapply(1:length(sumup), function(x){
    sumup[[x]][i,1:5] <- values$info_all[[x]]$variable[1:5,8];
    sumup[[x]]
  })
  
  sumup <- lapply(1:length(sumup), function(x){sumup <- right_case(values$result[[x]],sumup[[x]],i);
  sumup
  })
  
  
}


summarize_list <- function(values, sumup,i){
  
  sumup <- lapply(1:length(sumup), function(x){ lapply(1:length(x), function(y){
    sumup[[x]][[y]][i,1:5] <- values$info_all[[x]][[y]]$variable[1:5,8];
    sumup[[x]][[y]]
  });sumup[[x]]}
  )
  
  sumup <- lapply(1:length(sumup), function(x){ lapply(1:length(x), function(y) {
    sumup[[x]][[y]] <- right_case(values$result[[x]][[y]],sumup[[x]][[y]],i);
  sumup[[x]][[y]]
  }); sumup[[x]]}
    )
  
}

main <- function(n_simulation,n,p,lambda_true, lambda_noise, number_cores,
                 equal = FALSE, permute = TRUE, which_graph = 1,
                theta, model, alpha){
  
  transformation <- list(fit_raw,
                         fit_sqrt, fit_log,
                         fit_negative_anscombe,
                         fit_negative_dev,
                         fit_negative_pearson,
                         fit_negative_RQR,
                         fit_pois_dev,
                         fit_pois_pearson,
                         fit_pois_anscombe,
                         fit_pois_RQR)
  names <- list("RAW", 
                "SQRT", "LOG",
                "NB_ANSC",
                "NB_DEV",
                "NB_PEAR",
                "NB_RQR",
                "POIS_DEV",
                "POIS_PEAR",
                "POIS_ANSC",
                 "POIS_RQR")
  
  sumup <- lapply(1:length(transformation), function(x) matrix(0, n_simulation, 13))
  
  sumup <- lapply(sumup, function(x) {
    colnames(x) <- c('A', 'B', 'C', 'D', 'E',
                     'AB', 'AB+', 'A+', 'B+', 'O', 'E', 'F',
                     'S');
    x
  })
  
  primary <- list()
  
  for (i in 1:n_simulation){
    
    start <- Sys.time()
    
    set.seed(i)
    
    graphs <- graph_generation(equal = equal) 
    
    if(model=="poisson"){
    theta <- 1000
    data <- sim_data_p(graphs$W1,graphs$W2,n=n,p=p, lambda_true,lambda_noise, modelgen="poisson")
    } else if(model=="gamma-poisson"){
      theta <- 1000
      data <- sim_data_p(graphs$W1,graphs$W2,n=n,p=p, lambda_true,lambda_noise, modelgen="gamma-poisson", alpha = alpha)
    } else {
      data <- sim_data_nb(graphs$W1,graphs$W2,n=n,p=p, lambda_true = lambda_true,lambda_noise = lambda_noise, theta=theta)}
    

    res <- lapply(transformation, function(x) x(data, theta))
    
    if(which_graph == 1){
      graph <- graphs$W1
    } else {
      graph <- graphs$W2
    }
    
    graph  <- as(graph, 'graphNEL')
    
    values <- starting(res, data, permute = permute, graph = graph,
                       number_cores = number_cores)
    
    
    primary <- append(primary,list(values$primary))
    
    sumup <- summarize(values_s, sumup_s,i)
    
    finish <- Sys.time()
    
    message("Iteration number ", i)
    message("Time consumption ",finish-start)
   
  }
  
  ## Create a new matrix to store the mean values of the scores
  ## and the count of occurrences of each class
  
  newmatrix <- lapply(1:length(transformation), function(x) matrix(0, nrow=1, ncol=13))
  newmatrix <- lapply(1:length(transformation), function(x){newmatrix[[x]][,1:5] <- apply(sumup[[x]][,1:5],2,mean);newmatrix[[x]]})
  newmatrix <- lapply(1:length(transformation), function(x){newmatrix[[x]][,6:13] <- apply(sumup[[x]][,6:13],2,function(x) sum(x==1));newmatrix[[x]]})
  

  percent <- lapply(1:length(transformation), function(x) matrix(0, nrow=1, ncol=13))
  percent <- lapply(1:length(transformation), function(x){percent[[x]][1:5] <- apply(sumup[[x]][,1:5],2,mean);percent[[x]]})
  percent <- lapply(1:length(transformation), function(x){percent[[x]][6:13] <- apply(sumup[[x]][,6:13],2,function(x) sum(x==1)/n_simulation);percent[[x]]})
  

  endtable_counts <- matrix(unlist(newmatrix),nrow=length(transformation),byrow=T)
  
  endtable_percent <- matrix(unlist(percent),nrow=length(transformation),byrow=T)
  
  

  names(sumup) <- names
  
  colnames <- c('A', 'B', 'C', 'D', 'E',
                'AB', 'AB+', 'A+', 'B+', 'O', 'E', 'F',
                'S')

  

  
  colnames(endtable_counts) <- colnames(endtable_percent) <- colnames
  
  rownames(endtable_counts) <- rownames(endtable_percent) <- names
  
  return(list(table_fin = endtable_counts, perc_fin = endtable_percent, primary = primary, sum_table = sumup))
}



main_list <- function(n_simulation,n,p,lambda_true, lambda_noise, number_cores,
                 equal = FALSE, permute = TRUE, which_graph = 1,
                 theta, model, alpha, n_group){
  
  transformation <- list(fit_raw,
                         fit_sqrt, fit_log,
                         fit_negative_anscombe,
                         fit_negative_dev,
                         fit_negative_pearson,
                         fit_negative_RQR,
                         fit_pois_dev,
                         fit_pois_pearson,
                         fit_pois_anscombe,
                         fit_pois_RQR)
  names <- list("RAW", 
                "SQRT", "LOG",
                "NB_ANSC",
                "NB_DEV",
                "NB_PEAR",
                "NB_RQR",
                "POIS_DEV",
                "POIS_PEAR",
                "POIS_ANSC",
                "POIS_RQR")
  sumup <- lapply(1:length(transformation), function(x) lapply(1:n_group,function(y) matrix(0, n_simulation, 13)))

  
  
  sumup <- lapply(sumup, function(x){ lapply(x, function(y){
    colnames(y) <- c('A', 'B', 'C', 'D', 'E', 'AB', 'AB+', 'A+', 'B+', 'O', 'E', 'F', 'S');y}); x})
  
  for (i in 1:n_simulation){
    
    start <- Sys.time()
    
    set.seed(i)
    
    graphs <- graph_generation(equal = equal) 
    
    if(model=="poisson"){
      theta <- 1000
      data <- sim_data_p(graphs$W1,graphs$W2,n=n,p=p, lambda_true,lambda_noise, modelgen="poisson")
    } else if(model=="gamma-poisson"){
      theta <- 1000
      data <- sim_data_p(graphs$W1,graphs$W2,n=n,p=p, lambda_true,lambda_noise, modelgen="gamma-poisson", alpha = alpha)
    } else {
      data <- sim_data_nb(graphs$W1,graphs$W2,n=n,p=p, lambda_true = lambda_true,lambda_noise = lambda_noise, theta=theta)}

    # data <- matrix(rpois(500,6),100,5)
    # data <- cbind(data, rep(c(1,2),each=50))

    data <- data.frame(data, gr = rep(1:n_group,times =n/n_group))
    data <- group_split(data,gr)
    data <- lapply(data, function(x) dplyr::select(x,-gr))
    data  <-lapply(data,as.matrix)

    res <- lapply(transformation, function(x) lapply(data,x,theta))
    
    if(which_graph == 1){
      graph <- graphs$W1
    } else {
      graph <- graphs$W2
    }
    
    graph  <- as(graph, 'graphNEL')
    
    
    
    values <- starting_list(res, data, permute = permute, graph = graph,
                            number_cores = number_cores, numer = n/n_group)
    
    
    sumup <- summarize_list(values, sumup,i)
    
    finish <- Sys.time()
    
    message("Iteration number ", i)
    message("Time consumption ",finish-start)
    
  }
  
  ## Create a new matrix to store the mean values of the scores
  ## and the count of occurrences of each class
  newmatrix <- lapply(1:length(transformation), function(x) lapply(1:n_group,function(y) matrix(0, nrow=1, ncol=13)))
  
  newmatrix <- lapply(1:length(transformation), function(x){
    lapply(1:n_group, function(y){
    newmatrix[[x]][[y]][,1:5] <- apply(sumup[[x]][[y]][,1:5],2,mean);newmatrix[[x]][[y]]
    });newmatrix[[x]]})
  
  newmatrix <- lapply(1:length(transformation), function(x){
    lapply(1:n_group, function(y){
      newmatrix[[x]][[y]][,6:13] <- apply(sumup[[x]][[y]][,6:13],2,function(x) sum(x==1));newmatrix[[x]][[y]]
      });newmatrix[[x]]})
  
  
  percent <- lapply(1:length(transformation), function(x) lapply(1:n_group,function(y) matrix(0, nrow=1, ncol=13)))
  
  percent <- lapply(1:length(transformation), function(x){
    lapply(1:n_group, function(y){
    percent[[x]][[y]][1:5] <- apply(sumup[[x]][[y]][,1:5],2,mean);percent[[x]][[y]]
    });percent[[x]]})
  
  percent <- lapply(1:length(transformation), function(x){
    lapply(1:n_group, function(y){
     percent[[x]][[y]][6:13] <- apply(sumup[[x]][[y]][,6:13],2,function(x) sum(x==1)/n_simulation);percent[[x]][[y]]
     });percent[[x]]})
  
  

  

  return(list(table_fin = newmatrix, perc_fin = percent))
}