## Launching script for all procedures

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

setwd("~/Scrivania/DataTransformationSourceSet")

dir.create('./Results', showWarnings = FALSE)


## Launches procedure on Poisson generated data
## mean = 1
## SNR = 0.5
source('POIS_1_05launch.R') 

## Launches procedure on Poisson generated data
## mean = 1
## SNR = 0.1
source('POIS_1_01launch.R')

## Launches procedure on NegBin generated data
## mean = 1
## SNR = 0.5
## theta = 0.2
source('NB_1_05_2launch.R')

## Launches procedure on NegBin generated data
## mean = 1
## SNR = 0.1
## theta = 0.2
source('NB_1_01_2launch.R')
