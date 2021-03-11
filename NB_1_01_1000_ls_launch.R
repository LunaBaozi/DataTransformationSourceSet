library(SourceSet)
library(Rgraphviz)
library(graphite)
library(graph)
library(Biobase)
library(statmod)
library(MASS) 
library(surveillance) 
library(edgeR)
library(RUVSeq)
library(tidyverse)
library(rlist)


path <- getwd()

source(paste0(path,'/poisson_data_gen.R'))

source(paste0(path,'/functions.R'))

source(paste0(path,'/models.R'))

source(paste0(path,'/main.R'))

`%notin%` <- Negate(`%in%`)

n <- 400
p <- 5
lambda_true <- 1
lambda_noise <- 0.1
number_cores <- 10
theta = 1000

system.time(res_NB1_01_1000 <- main_list(n_simulation = 5000, n=n, p=p,
                                  lambda_true = lambda_true, lambda_noise = lambda_noise,
                                  number_cores = number_cores,
                                  equal = FALSE, permute = TRUE, which_graph = 1,
                                  theta = theta, model="negbin", n_group = 10))

save(res_NB1_01_1000,file= paste0(path,"/Results/resultsNB_1_01_1000_list.RData"))