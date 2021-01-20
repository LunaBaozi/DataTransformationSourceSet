## Launches procedure to generate Negative Binomial data with
## given parameters: mu = 1, SNR = 0.5, theta = 2

source('functions.R')

source('models.R')

source('main.R')

`%notin%` <- Negate(`%in%`)

n <- 400
p <- 5
lambda_true <- 1
lambda_noise <- 0.5
number_cores <- 1


system.time(res <- main(n_simulation = 10, n=n, p=p,
                        lambda_true = lambda_true, lambda_noise = lambda_noise,
                        number_cores = number_cores,
                        equal = FALSE, permute = TRUE, which_graph = 1,
                        mu = 10, mu.noise = 1, theta = 0.2, model="negbin"))

save(res,file= "resultsNB_1_05_2.RData")