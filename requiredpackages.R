## PACKAGE PREPARATION
## gcc-fortran is required!!!

install.packages('statmod')
install.packages('surveillance')

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("graph")
BiocManager::install("Rgraphviz")
BiocManager::install("RBGL")
library(RBGL)
BiocManager::install("graphite")
BiocManager::install('edgeR')
BiocManager::install('RUVSeq')
BiocManager::install('biomaRt')
BiocManager::install('GenomicFeatures')
BiocManager::install('EDASeq')
BiocManager::install('RUVSeq')

install.packages('devtools')
library(devtools)
install.packages('igraph')
library(igraph)
install.packages('gRbase')
library(gRbase)
install.packages('SourceSet')

install.packages('glmnet')
library(glmnet)
install.packages('snowfall')
library(snowfall)

#install.packages('biomaRt')
#install.packages('GenomicFeatures')
#install.packages('EDASeq')
install.packages('stringi')
