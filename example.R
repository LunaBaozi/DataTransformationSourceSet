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
library(tidyverse)

setwd("~/Scrivania/DataTransformationSourceSet")
source('functions.R')

source('models.R')

source('main.R')

`%notin%` <- Negate(`%in%`)

n <- 50
p <- 5
lambda_true <- 1
lambda_noise <- 0.5
number_cores <- 10
n_group = 10
# PARAMETRI
## I parametri sono quelli che tu avevi impostato più qualche altro
## il numero di simulazioni rappresenta il numero di cicli for
## il numero di core è fatto per parallelizzare Sourceset in un modo che vedremo
## equal = T impone che i due grafi siano identici
## permute = F calcola i p-value asintotici
## which_graph decide quale dei due grafi vuoi come riferimento, 1 o 2
## model impone il modello generatore dei dati se "pois" sarà poisson altrimenti sarà negativo binomiale
## mu valore media simulazione binomiale negativa
## mu noise rumore media binomiale negativa
## theta valore sovradispersione binomiale negativa



system.time(ras <- main_list(n_simulation = 10, n=n, p=p,
                        lambda_true = lambda_true, lambda_noise = lambda_noise,
                        number_cores = 2,
                        equal = FALSE, permute = TRUE, which_graph = 1,
                        theta = 0.2, model="nb", n_group = n_group))

save(res,file="results_1_05.RData")