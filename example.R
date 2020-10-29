library(SourceSet)
library(Rgraphviz)
library(graphite)
library(graph)
library(Biobase)
library(statmod)
library(MASS) 
library(surveillance) 
library(XMRF)

setwd("~/Scrivania/DataTransformationSourceSet")
source('functions.R')

source('models.R')

source('main.R')

`%notin%` <- Negate(`%in%`)

n <- 400
p <- 5
lambda_true <- 1
lambda_noise <- 0.5
number_cores <- 10

# PARAMETRI
## I parametri sono quelli che tu avevi impostato più qualche altro
## il numero di simulazioni rappresenta il numero di cicli for
## il numero di core è fatto per parallelizzare Sourceset in un modo che vedremo
## equal = T impone che i due grafi siano identici
## permute = F calcola i p-value asintotici
## which_graph decide quale dei due grafi vuoi come riferimento, 1 o 2

system.time(res <- main(n_simulation = 50, n=n, p=p,
                        lambda_true = lambda_true, lambda_noise = lambda_noise,
                        number_cores = number_cores, 
                        equal = F, permute = T, which_graph = 1))

save(res,file="results_1_05.RData")