## LOOP ####
source('./poisson_data_gen.R')

set.seed(i)
sim1 <- XMRF.Sim(B = W1, n = n, p = p, model = 'LPGM', graph.type = 'scale-free')
set.seed(i)
sim2 <- XMRF.Sim(B = W2, n = n, p = p, model = 'LPGM', graph.type = 'scale-free')

x1 <- t(sim1$X)
x2 <- t(sim2$X)
X <- rbind(x1, x2)
X <- cbind(X, rep(c(1, 2), each = n))

A <- X[,1]
B <- X[,2]
C <- X[,3]
D <- X[,4]
E <- X[,5]

fitAnb <- glm(A ~ 1, family = negative.binomial(theta = 1))
RA <- qres.nbinom(fitAnb)
fitBnb <- glm(B ~ 1, family = negative.binomial(theta = 1))
RB <- qres.nbinom(fitBnb)
fitCnb <- glm(C ~ 1, family = negative.binomial(theta = 1))
RC <- qres.nbinom(fitCnb)
fitDnb <- glm(D ~ 1, family = negative.binomial(theta = 1))
RD <- qres.nbinom(fitDnb)
fitEnb <- glm(E ~ 1, family = negative.binomial(theta = 1))
RE <- qres.nbinom(fitEnb)

data_all <- matrix(c(RA, RB, RC, RD, RE), 800, 5)
classes <- X[,6] 
data_cond1 <- data_all[1:400,]
data_cond2 <- data_all[401:800,]
colnames(data_all) <- c('A', 'B', 'C', 'D', 'E')
rownames(data_all) <- c(1:800)
W1 <- as(W1, 'graphNEL')
W2 <- as(W2, 'graphNEL')
graphs <- list()
graphs$W1 <- W1

result <- sourceSet(graphs, data_all, classes, seed = 1234,
                    permute = TRUE, shrink = TRUE)
print(paste0('Analyzing RQR (NegBin) data... iteration #', i))
info_all <- infoSource(result, map.name.variable = nodes(graphs$W1))
