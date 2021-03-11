## Launches procedure to generate Poisson data with
## given parameters: mu = 1, SNR = 0.1
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
library(rlist)

path <- getwd()

source(paste0(path,'/../DataTransformationSourceSet/poisson_data_gen.R'))

source(paste0(path,'/../DataTransformationSourceSet/functions.R'))

source(paste0(path,'/../DataTransformationSourceSet/models.R'))

source(paste0(path,'/../DataTransformationSourceSet/main.R'))
`%notin%` <- Negate(`%in%`)

n <- 400
p <- 5
lambda_true <- 1
lambda_noise <- 0.1
number_cores <- 10


system.time(res_P1_01_ls <- main(n_simulation = 5000, n=n, p=p,
                              lambda_true = lambda_true, lambda_noise = lambda_noise,
                              number_cores = number_cores,
                              equal = FALSE, permute = TRUE, which_graph = 1,
                              model="poisson", n_group = 10))

save(res_P1_01,file= paste0(path,"/../DataTransformationSourceSet/Results/resultsPOIS_1_01_list.RData"))