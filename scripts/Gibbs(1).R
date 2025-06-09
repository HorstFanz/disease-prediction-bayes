# Load packages
require(bvarsv)
data("usmacro.update")


# # (1) Erstelle den Datensatz im passenden Format
# y <- usmacro.update[, "inf"]
# 
# X <- usmacro.update[, c("inf", "une")]
# X <- cbind(X[-nrow(X), ])
# y <- y[-1]
# XT <- c(usmacro.update[nrow(usmacro.update), c("inf", "une")])

T <- 250
K <- 3
sigma.true <- 1

beta.true <- rnorm(K, 0, 10)
X.true <- matrix(rnorm(T*K), T, K)

y <- X.true %*% beta.true + rnorm(T, 0, sigma.true)

K.big <- 200
X <- cbind(X.true, matrix(rnorm(T*(K.big-K)), T, K.big-K))
XT <- X[nrow(X), ]

# # Transformieren der Daten
# 
# y <- (y-mean(y))/sd(y)
# X <- apply(X, 2, function(x) (x-mean(x))/sd(x))

# Dimensionen der Daten
T <- nrow(X)
K <- ncol(X)

# Preliminaries
nsave <- 1000
nburn <- 1000
ntot <- nsave + nburn
prior <- "SSVS" # Stochastic Search Variable Selection for using the SSVS prior
                # Ridge estimates the model using the Ridge prior
# Setting up the prior
# Prior auf beta N(b.0, V.0)
b.0 <- matrix(0, K, 1)

if (prior == "Ridge"){
  delta <- 10
  V.0 <- delta * diag(K)
} else {
  tau1 <- 3
  tau0 <- 0.01
  delta <- rep(1, K)
  p_ <- 0.5
  
  V.0 <- diag(delta * tau1^2 + (1-delta) * tau0^2)
  
  plot(density(rnorm(10^3, 0, tau1)), col="blue")
  lines(density(rnorm(10^3, 0, tau0)), col="red")
  
}

# Prior auf h
c.0 <- d.0 <- 0.01

# Prior on delta
c.delta <- d.delta <- 0.01

# Get OLS quantities
b.OLS <- solve(crossprod(X)+diag(K)*1e-3) %*% crossprod(X, y)
sigma2.OLS <- sum((y - X%*%b.OLS)^2)/(T-K)
h <- 1/sigma2.OLS # Startwert für h

# MCMC Storage objects
beta.store <- matrix(NA, nsave, K)
sigma2.store <- matrix(NA, nsave, 1)
if (prior=="Ridge") delta.store <- matrix(NA, nsave, 1) else delta.store <- matrix(NA, nsave, K)
predict.store <- matrix(NA, nsave, 1)

XtX <- crossprod(X)
# Start the Gibbs loop
for (irep in 1:ntot){
  # Step 1: Sample beta given h
  V.0.inv <- solve(V.0)
  V.1 <- solve(XtX*h + V.0.inv)
  b.1 <- V.1 %*% (h* crossprod(X, y) + V.0.inv %*% b.0)
  
  beta.draw <- try(b.1 + t(chol(V.1)) %*% rnorm(K), silent=TRUE) # Eine Ziehung aus beta ~ N(b.1, V.1)
  if (is(beta.draw, "try-error")){
    beta.draw <- mvtnorm::rmvnorm(1, b.1, V.1, method="eigen")
  }
  
  # Step 2: Sample h given beta
  c.1 <- T/2 + c.0
  d.1 <- sum((y - X%*%beta.draw)^2)/2 + d.0
  h <- rgamma(1, c.1, d.1)
  sigma2 <- 1/h
  
  # Step 3: Sample delta given beta
  if (prior == "Ridge"){
    c.delta.1 <- K/2 + c.delta
    d.delta.1 <- sum(beta.draw^2)/2 + d.delta
    delta <- 1/rgamma(1, c.delta.1, d.delta.1)
    
    V.0 <- delta * diag(K)
  } else {
    
    for (j in 1:K){
      A <- dnorm(beta.draw[j], 0, tau1) * p_
      B <- dnorm(beta.draw[j], 0, tau0) * (1-p_)
      p_j <- A/(A+B)
      
      if (p_j > runif(1)){
        delta[j] <- 1 
      }else{
        delta[j] <- 0
      }
    }
    
    V.0 <- diag(delta*tau1^2 + (1-delta)*tau0^2)
  }

  # Wait until burn-in phase is over and then store draws of beta and h
  if (irep > nburn){
    beta.store[irep-nburn, ] <- t(beta.draw)
    sigma2.store[irep-nburn] <- sigma2
    delta.store[irep-nburn, ] <- delta
    # Ziehung aus der Prognosedichte
    eps_tp1 <- rnorm(1, 0, sqrt(sigma2))
    ytp1 <- t(beta.draw) %*% XT + eps_tp1
    predict.store[irep-nburn, ] <- ytp1
  }
  print(irep)
}

# Quantile der Posterior Verteilung
beta.quantiles <- 
  apply(beta.store, 2, function(x) quantile(x, c(0.05, 0.5, 0.95)))


# Compute the posterior inclusion probabilities
PIP <- apply(delta.store, 2, mean)







