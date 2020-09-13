## RAW DATA ####
sumup <- matrix(NA, 5000, 13)
colnames(sumup) <- c('ptA', 'ptB', 'ptC', 'ptD', 'ptE',
                     'AB', 'AB+al.', 'A+al.', 'B+al.', 'Other', 'Empty', 'Full',
                     'Single')


start_time <- Sys.time()

primaryset <- c() 

for (i in 1:5000){
  
  source('./Bodies/bodyRAW.R')
  
  primaryset <- c(primaryset, list(result$W1$primarySet))
  
  for (j in 1:5){
    sumup[i, j] <- info_all$variable[j, 8]
  }
  
  for (c in 6:12){
    if (length(result$W1$primarySet) != 1){
      
      ## Checks if primary set is correctly (A, B)
      if ('A' %in% result$W1$primarySet){
        if ('B' %in% result$W1$primarySet){
          if ('C' %notin% result$W1$primarySet){
            if ('D' %notin% result$W1$primarySet){
              if ('E' %notin% result$W1$primarySet){
                sumup[i, 6] <- 1
                sumup[i, 7] <- 0
                sumup[i, 8] <- 0
                sumup[i, 9] <- 0
                sumup[i, 10] <- 0
                sumup[i, 11] <- 0
                sumup[i, 12] <- 0
                sumup[i, 13] <- 0
              }
            }
          }
        }
      }
      
      ## Checks if primary set contains other nodes than (A, B)
      if ('A' %in% result$W1$primarySet){
        if ('B' %in% result$W1$primarySet){
          if (('C' %in% result$W1$primarySet) || 
              ('D' %in% result$W1$primarySet) || 
              ('E' %in% result$W1$primarySet)){
            sumup[i, 6] <- 0
            sumup[i, 7] <- 1
            sumup[i, 8] <- 0
            sumup[i, 9] <- 0
            sumup[i, 10] <- 0
            sumup[i, 11] <- 0
            sumup[i, 12] <- 0
            sumup[i, 13] <- 0
          }
        }
      }

      ## Checks if there is A, not B, and others
      if ('A' %in% result$W1$primarySet){
        if ('B' %notin% result$W1$primarySet){
          if (('C' %in% result$W1$primarySet) || 
              ('D' %in% result$W1$primarySet) || 
              ('E' %in% result$W1$primarySet)){
            sumup[i, 6] <- 0
            sumup[i, 7] <- 0
            sumup[i, 8] <- 1
            sumup[i, 9] <- 0
            sumup[i, 10] <- 0
            sumup[i, 11] <- 0
            sumup[i, 12] <- 0
            sumup[i, 13] <- 0
          }
        }
      }

      ## Checks if there is not A, yes B and others
      if ('A' %notin% result$W1$primarySet){
        if ('B' %in% result$W1$primarySet){
          if (('C' %in% result$W1$primarySet) || 
              ('D' %in% result$W1$primarySet) || 
              ('E' %in% result$W1$primarySet)){
            sumup[i, 6] <- 0
            sumup[i, 7] <- 0
            sumup[i, 8] <- 0
            sumup[i, 9] <- 1
            sumup[i, 10] <- 0
            sumup[i, 11] <- 0
            sumup[i, 12] <- 0
            sumup[i, 13] <- 0
          }
        }
      }

      ## Checks if there is not A, nor B but others
      if ('A' %notin% result$W1$primarySet){
        if ('B' %notin% result$W1$primarySet){
          if (('C' %in% result$W1$primarySet) || 
              ('D' %in% result$W1$primarySet) || 
              ('E' %in% result$W1$primarySet)){
            sumup[i, 6] <- 0
            sumup[i, 7] <- 0
            sumup[i, 8] <- 0
            sumup[i, 9] <- 0
            sumup[i, 10] <- 1
            sumup[i, 11] <- 0
            sumup[i, 12] <- 0
            sumup[i, 13] <- 0
          }
        }
      }

      ## Checks if primary set is empty
      if ('A' %notin% result$W1$primarySet){
        if ('B' %notin% result$W1$primarySet){
          if ('C' %notin% result$W1$primarySet){
            if ('D' %notin% result$W1$primarySet){
              if ('E' %notin% result$W1$primarySet){
                sumup[i, 6] <- 0
                sumup[i, 7] <- 0
                sumup[i, 8] <- 0
                sumup[i, 9] <- 0
                sumup[i, 10] <- 0
                sumup[i, 11] <- 1
                sumup[i, 12] <- 0
                sumup[i, 13] <- 0
              }
            }
          }
        }
      }

      ## Checks if primary set is full
      if ('A' %in% result$W1$primarySet){
        if ('B' %in% result$W1$primarySet){
          if ('C' %in% result$W1$primarySet){
            if ('D' %in% result$W1$primarySet){
              if ('E' %in% result$W1$primarySet){
                sumup[i, 6] <- 0
                sumup[i, 7] <- 0
                sumup[i, 8] <- 0
                sumup[i, 9] <- 0
                sumup[i, 10] <- 0
                sumup[i, 11] <- 0
                sumup[i, 12] <- 1
                sumup[i, 13] <- 0
              }
            }
          }
        }
      }
    }
    
    ## Checks if primary set is single
    if (length(result$W1$primarySet) == 1){
      sumup[i, 6] <- 0
      sumup[i, 7] <- 0
      sumup[i, 8] <- 0
      sumup[i, 9] <- 0
      sumup[i, 10] <- 0
      sumup[i, 11] <- 0
      sumup[i, 12] <- 0
      sumup[i, 13] <- 1
    }
  }
}
      


end_time <- Sys.time()
elapsed_time <- end_time - start_time

## CAT primaryset list into a file
lapply(primaryset, cat, '\n', file = 'psRAW.txt', append = T)
## Write big matrix into a file
write.csv(sumup, 'RAW.csv')


## Create a new matrix to store the mean values of the scores
## and the count of occurrences of each class
newmatrix <- matrix(NA, 1, 14)
percent <- matrix(NA, 1, 14)

newmatrix[,1] <- mean(sumup[,1])
newmatrix[,2] <- mean(sumup[,2])
newmatrix[,3] <- mean(sumup[,3])
newmatrix[,4] <- mean(sumup[,4])
newmatrix[,5] <- mean(sumup[,5])
newmatrix[,6] <- sum(sumup[,6] == 1)
newmatrix[,7] <- sum(sumup[,7] == 1)
newmatrix[,8] <- sum(sumup[,8] == 1)
newmatrix[,9] <- sum(sumup[,9] == 1)
newmatrix[,10] <- sum(sumup[,10] == 1)
newmatrix[,11] <- sum(sumup[,11] == 1)
newmatrix[,12] <- sum(sumup[,12] == 1)
newmatrix[,13] <- sum(sumup[,13] == 1)
newmatrix[,14] <- elapsed_time

percent[,1] <- mean(sumup[,1])
percent[,2] <- mean(sumup[,2])
percent[,3] <- mean(sumup[,3])
percent[,4] <- mean(sumup[,4])
percent[,5] <- mean(sumup[,5])
percent[,6] <- (sum(sumup[,6] == 1))/50
percent[,7] <- (sum(sumup[,7] == 1))/50
percent[,8] <- (sum(sumup[,8] == 1))/50
percent[,9] <- (sum(sumup[,9] == 1))/50
percent[,10] <- (sum(sumup[,10] == 1))/50
percent[,11] <- (sum(sumup[,11] == 1))/50
percent[,12] <- (sum(sumup[,12] == 1))/50
percent[,13] <- (sum(sumup[,13] == 1))/50
percent[,14] <- elapsed_time



# ## Identifies singletons
# for (i in 1:5000){
#   if (sumup[i, 13] == 1){
#     print(primaryset[i])
#   }
# }



## Gives names to row and columns
rownames(newmatrix) <- 'RAW'
colnames(newmatrix) <- c('ptA', 'ptB', 'ptC', 'ptD', 'ptE',
                     'AB', 'AB+al.', 'A+al.', 'B+al.', 'Other', 'Empty', 'Full',
                     'Single', 'Time')
rownames(percent) <- 'RAW'
colnames(percent) <- c('ptA', 'ptB', 'ptC', 'ptD', 'ptE',
                       'AB', 'AB+al.', 'A+al.', 'B+al.', 'Other', 'Empty', 'Full',
                       'Single', 'Time')

write.csv(newmatrix, 'collapsedRAW_counts.csv')
write.csv(percent, 'collapsedRAW_percent.csv')

