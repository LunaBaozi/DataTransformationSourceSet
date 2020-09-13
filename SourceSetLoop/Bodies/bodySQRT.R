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

Y <- sqrt(X[,-6])

classes <- X[,6]
data_cond1 <- Y[1:400,]
data_cond2 <- Y[401:800,]
colnames(Y) <- c('A', 'B', 'C', 'D', 'E')
rownames(Y) <- c(1:800)
W1 <- as(W1, 'graphNEL')
W2 <- as(W2, 'graphNEL')
graphs <- list()
graphs$W1 <- W1

result <- sourceSet(graphs, Y, classes, seed = 1234,
                    permute = TRUE, shrink = TRUE)
print(paste0('Analyzing SQRT data... iteration #', i))
info_all <- infoSource(result, map.name.variable = nodes(graphs$W1))
