## Launches procedure to generate Negative Binomial data with
## given parameters: mu = 1, SNR = 0.5, theta = 2
library(SourceSet)
library(Rgraphviz)
library(graphite)
library(graph)
library(Biobase)
library(statmod)
library(MASS) 
library(surveillance) 
library(XMRF)
library(edgeR)
library(RUVSeq)
source('functions.R')

source('models.R')

source('main.R')

`%notin%` <- Negate(`%in%`)

n <- 400
p <- 5
lambda_true <- 1
lambda_noise <- 0.5
number_cores <- 10
theta <- 0.1


system.time(res_NB1_05_01 <- main(n_simulation = 5000, n=n, p=p,
                        lambda_true = lambda_true, lambda_noise = lambda_noise,
                        number_cores = number_cores,
                        equal = FALSE, permute = TRUE, which_graph = 1,
                        model="negbin", theta = theta))

save(res_NB1_05_01,file= "./Results/resultsNB_1_05_2.RData")