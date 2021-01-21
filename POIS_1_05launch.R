## Launches procedure to generate Poisson data with
## given parameters: mu = 1, SNR = 0.5

source('functions.R')

source('models.R')

source('main.R')

`%notin%` <- Negate(`%in%`)

n <- 400
p <- 5
lambda_true <- 1
lambda_noise <- 0.5
number_cores <- 10


system.time(res <- main(n_simulation = 5000, n=n, p=p,
                        lambda_true = lambda_true, lambda_noise = lambda_noise,
                        number_cores = number_cores,
                        equal = FALSE, permute = TRUE, which_graph = 1,
                        mu = 10, mu.noise = 1, theta = 0.2, model="poisson"))

save(res,file = "./Results/resultsPOIS_1_05.RData")
