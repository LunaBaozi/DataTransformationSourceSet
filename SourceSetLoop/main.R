library(SourceSet)
library(Rgraphviz)
library(graphite)
library(graph)
library(Biobase)
library(statmod)
library(MASS) 
library(surveillance) 

`%notin%` <- Negate(`%in%`)

n <- 400
p <- 5
lambda_true <- 0.5
lambda_noise <- 0.1


source('./Loops/loopRAW.R')
source('./Loops/loopSQRT.R')
source('./Loops/loopLOG.R')
source('./Loops/loopPEAR_poisson.R')
#source('./Loops/loopPEAR_nb.R')
source('./Loops/loopDEV_poisson.R')
#source('./Loops/loopDEV_nb.R')
source('./Loops/loopRQR_poisson.R')
#source('./Loops/loopRQR_nb.R')
source('./Loops/loopANSC.R')


RAWdata <- read.csv('collapsedRAW_counts.csv', header = TRUE, row.names = 1)
SQRTdata <- read.csv('collapsedSQRT_counts.csv', header = TRUE, row.names = 1)
LOGdata <- read.csv('collapsedLOG_counts.csv', header = TRUE, row.names = 1)
PEARdatapois <- read.csv('collapsedPEARpois_counts.csv', header = TRUE, row.names = 1)
#PEARdatanb <- read.csv('collapsedPEARnb_counts.csv', header = TRUE, row.names = 1)
DEVdatapois <- read.csv('collapsedDEVpois_counts.csv', header = TRUE, row.names = 1)
#DEVdatanb <- read.csv('collapsedDEVnb_counts.csv', header = TRUE, row.names = 1)
RQRdatapois <- read.csv('collapsedRQRpois_counts.csv', header = TRUE, row.names = 1)
#RQRdatanb <- read.csv('collapsedRQRnb_counts.csv', header = TRUE, row.names = 1)
ANSCdata <- read.csv('collapsedANSC_counts.csv', header = TRUE, row.names = 1)

endtable_counts <- rbind(RAWdata, SQRTdata, LOGdata, 
                         PEARdatapois, #PEARdatanb,
                         DEVdatapois, #DEVdatanb,
                         RQRdatapois, #RQRdatanb,
                         ANSCdata)
write.csv(endtable_counts, 'DataNoise01_counts.csv')

PRAWdata <- read.csv('collapsedRAW_percent.csv', header = TRUE, row.names = 1)
PSQRTdata <- read.csv('collapsedSQRT_percent.csv', header = TRUE, row.names = 1)
PLOGdata <- read.csv('collapsedLOG_percent.csv', header = TRUE, row.names = 1)
PPEARdatapois <- read.csv('collapsedPEARpois_percent.csv', header = TRUE, row.names = 1)
#PPEARdatanb <- read.csv('collapsedPEARnb_percent.csv', header = TRUE, row.names = 1)
PDEVdatapois <- read.csv('collapsedDEVpois_percent.csv', header = TRUE, row.names = 1)
#PDEVdatanb <- read.csv('collapsedDEVnb_percent.csv', header = TRUE, row.names = 1)
PRQRdatapois <- read.csv('collapsedRQRpois_percent.csv', header = TRUE, row.names = 1)
#PRQRdatanb <- read.csv('collapsedRQRnb_percent.csv', header = TRUE, row.names = 1)
PANSCdata <- read.csv('collapsedANSC_percent.csv', header = TRUE, row.names = 1)

endtable_percent <- rbind(PRAWdata, PSQRTdata, PLOGdata,
                          PPEARdatapois, #PPEARdatanb,
                          PDEVdatapois, #PDEVdatanb,
                          PRQRdatapois, #PRQRdatanb,
                          PANSCdata)
write.csv(endtable_percent, 'DataNoise01_percent.csv')