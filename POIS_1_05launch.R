## Launches procedure to generate Poisson data with
## given parameters: mu = 1, SNR = 0.5
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
path <- getwd()

source(paste0(path,'/poisson_data_gen.R'))

source(paste0(path,'/functions.R'))

source(paste0(path,'/models.R'))

source(paste0(path,'/main.R'))

`%notin%` <- Negate(`%in%`)

n <- 400
p <- 5
lambda_true <- 1
lambda_noise <- 0.5
number_cores <- 2


system.time(res_P1_05 <- main(n_simulation = 5000, n=n, p=p,
                        lambda_true = lambda_true, lambda_noise = lambda_noise,
                        number_cores = number_cores,
                        equal = FALSE, permute = TRUE, which_graph = 1,
                        model="poisson"))

save(res_P1_05,file = paste0(path,"/Results/resultsPOIS_1_05.RData"))
