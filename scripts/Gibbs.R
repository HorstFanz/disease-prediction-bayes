# Load packages
require(bvarsv)
data("usmacro.update")


# (1) Erstelle den Datensatz im passenden Format
y <- usmacro.update[, "inf"]

X <- usmacro.update[, c("inf", "une")]
X <- cbind(X[-nrow(X), ], 1)
y <- y[-1]
XT <- c(usmacro.update[nrow(usmacro.update), c("inf", "une")],1)


# Dimensionen der Daten
T <- nrow(X)
K <- ncol(X)

# Preliminaries
nsave <- 5000
nburn <- 5000
ntot <- nsave + nburn

# Setting up the prior
# Prior auf beta N(b.0, V.0)
b.0 <- matrix(0, K, 1)

delta <- 10
V.0 <- delta * diag(K)

# Prior auf h
c.0 <- d.0 <- 0.01

# Prior on delta
c.delta <- d.delta <- 0.01

# Get OLS quantities
b.OLS <- solve(crossprod(X)) %*% crossprod(X, y)
sigma2.OLS <- sum((y - X%*%b.OLS)^2)/(T-K)
h <- 1/sigma2.OLS # Startwert für h

# MCMC Storage objects
beta.store <- matrix(NA, nsave, K)
sigma2.store <- matrix(NA, nsave, 1)
delta.store <- matrix(NA, nsave, 1)
predict.store <- matrix(NA, nsave, 1)

XtX <- crossprod(X)
# Start the Gibbs loop
for (irep in 1:ntot){
  # Step 1: Sample beta given h
  V.0.inv <- solve(V.0)
  V.1 <- solve(XtX*h + V.0.inv)
  b.1 <- V.1 %*% (h*XtX %*% b.OLS + V.0.inv %*% b.0)
  beta.draw <- b.1 + t(chol(V.1)) %*% rnorm(K) # Eine Ziehung aus beta ~ N(b.1, V.1)

  # Step 2: Sample h given beta
  c.1 <- T/2 + c.0
  d.1 <- sum((y - X%*%beta.draw)^2)/2 + d.0
  h <- rgamma(1, c.1, d.1)
  sigma2 <- 1/h
  
  # Step 3: Sample delta given beta
  c.delta.1 <- K/2 + c.delta
  d.delta.1 <- sum(beta.draw^2)/2 + d.delta
  delta <- 1/rgamma(1, c.delta.1, d.delta.1)
  
  V.0 <- delta * diag(K)

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
}

# Quantile der Posterior Verteilung
beta.quantiles <- 
  apply(beta.store, 2, function(x) quantile(x, c(0.05, 0.5, 0.95)))










