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

fitApois <- glm(A ~ 1, family = poisson)
PA <- resid(fitApois, type = 'pearson')
fitBpois <- glm(B ~ 1, family = poisson)
PB <- resid(fitBpois, type = 'pearson')
fitCpois <- glm(C ~ 1, family = poisson)
PC <- resid(fitCpois, type = 'pearson')
fitDpois <- glm(D ~ 1, family = poisson)
PD <- resid(fitDpois, type = 'pearson')
fitEpois <- glm(E ~ 1, family = poisson)
PE <- resid(fitEpois, type = 'pearson')

data_all <- matrix(c(PA, PB, PC, PD, PE), 800, 5)
data_cond1 <- data_all[1:400,]
data_cond2 <- data_all[401:800,]
classes <- X[,6]
colnames(Y) <- c('A', 'B', 'C', 'D', 'E')
rownames(Y) <- c(1:800)
W1 <- as(W1, 'graphNEL')
W2 <- as(W2, 'graphNEL')
graphs <- list()
graphs$W1 <- W1

result <- sourceSet(graphs, data_all, classes, seed = 1234,
                    permute = TRUE, shrink = TRUE)
print(paste0('Analyzing Pearson (Poisson) data... iteration #', i))
info_all <- infoSource(result, map.name.variable = nodes(graphs$W1))
