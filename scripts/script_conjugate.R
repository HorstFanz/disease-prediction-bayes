#test 
require(bvarsv)
data("usmacro.update")

# Our goal is to model y-o-y inflation as a function of (lagged) inflation, unemployment and short-term interest rates
p <- 2 #Two lags of the exogenous variables
Xraw <- usmacro.update

Yraw <- embed(Xraw, dimension=p+1)

Y <- Yraw[, 1]
X <- Yraw[, 4:ncol(Yraw)]

# Get dimensions of the data
T <- nrow(X) # Length of the sample
K <- ncol(X) # Number of covariates

# Get OLS estimates
XtX <- t(X)%*%X
beta.hat <- solve(XtX) %*% t(X) %*% Y # solve(crossprod(X)) %*% crossprod(X, Y)
sigma2.hat <- crossprod(Y - X %*% beta.hat)/(T-K)

# Prior setup
# \beta | h = sigma^-2 ~ N(\beta_0, sigma^2 * V_0) 
# \h ~ Gamma(s0, S0)
beta.0 <- matrix(0, K, 1)
beta.0[1] <- 1 # A priori, inflation evolves according to a random walk pi(t) = pi(t-1) +e(t)

theta <- 0.1
V.0 <- diag(K) * 1/theta

s0 <- S0 <- 0.01 #relatively uninformative prior on the error precision
#Moments for Gamma prior on theta
c0 <- 3
C0 <- 0.03

# Posterior quantities
#Posterior of beta, h ~ N-G(beta.1, V.1, s.1, S.1)
# Start with posterior mean of beta

V.1 <- solve(crossprod(X) + solve(V.0)) # Posterior covariance matrix
beta.1 <- V.1 %*% ((XtX)%*%beta.hat + solve(V.0) %*% beta.0) #Posterior mean

#Posterior moments for h
v1s12 <- s0*S0 + (T-K)*sigma2.hat + t(beta.hat - beta.0) %*% (solve(XtX) + V.0) %*% (beta.hat - beta.0)
s1 <- T+s0
S1 <- v1s12/s1


# We sample first from h|y ~ G(s1, S1) and then from beta|h, y ~ N(beta.1, sigma^2 * V.1)
nsave <- 5000

h.store <- matrix(NA, nsave, 1)
beta.store <- matrix(NA, nsave, K)
ystar.store <- matrix(NA, nsave, 1)
theta.store <- matrix(NA, nsave, 1)
#Start Monte Carlo loop
for (irep in 1:nsave){
  # Step 1: Sample from h|y ~ G
  h.draw <- rgamma(1, s1/2, s1*S1/2)
  sigma2.draw <- 1/h.draw
  
  # Step 2: Sample from beta|h, y ~ N
  V.1.draw <- sigma2.draw * V.1
  beta.draw <- beta.1 + t(chol(V.1.draw)) %*% rnorm(K)
  
  # Step 3: Sample theta|beta from G
  # p(beta|theta) ~ \prod_j=1^K N(beta_j, beta_0j, theta^-2)
  c1 <- K/2 + c0
  C1 <- sum((beta.draw - beta.0)^2)/2 + C0
  theta <- rgamma(1, c1, C1)
  theta.inv <- 1/theta
  
  # Start with posterior mean of beta
  V.0 <- theta.inv * diag(K)
  V.1 <- solve(crossprod(X) + solve(V.0)) # Posterior covariance matrix
  beta.1 <- V.1 %*% ((XtX)%*%beta.hat + solve(V.0) %*% beta.0) #Posterior mean
  
  #Posterior moments for h
  v1s12 <- s0*S0 + (T-K)*sigma2.hat + t(beta.hat - beta.0) %*% (solve(XtX) + V.0) %*% (beta.hat - beta.0)
  s1 <- T+s0
  S1 <- v1s12/s1
  
  # Step 4: Sample from the predictive distribution 
  #         p(y*|y) = \int \int p(y*|beta, h, y) p(beta, h|y) dbeta dh
  # ystar = y(T+1) = beta' * X(T+1) + epsilon(T+1), epsilon(T+1) ~N(0, sigma^2)
  # X(T+1) =(y(T), U(T), ST(T), y(T-1), U(T-1), ST(T-1))'
  XT1 <- Yraw[T, 1:6]
  ystar <- t(beta.draw)%*%XT1 + rnorm(1, 0, sqrt(sigma2.draw))
  
  # Start storing draws from p(beta.draw|y, h) and from p(h|y)
  h.store[irep, ] <- h.draw
  beta.store[irep, ] <- as.numeric(beta.draw) # this is p(beta|y)
  ystar.store[irep, ] <- ystar
  theta.store[irep, ] <- theta
  print(irep)
}

# Get posterior quantiles
posterior.quantiles <- t(apply(beta.store, 2, function(x) quantile(x, c(0.05, 0.5, 0.95))))
print(round(cbind(posterior.quantiles, beta.hat), digits=3))


ystar.mean <- mean(ystar.store)
ystar.sd <- sd(ystar.store)
inflation.grid <- seq(-1, 12, length.out = 200)

plot(dnorm(inflation.grid, ystar.mean, ystar.sd), type="l", xlab="", xaxt="n")
axis(1, at=seq(1,200, 20), label=round(inflation.grid[seq(1,200, 20)], 3))

density.grid <- dnorm(inflation.grid, ystar.mean, ystar.sd)
prob.density <- density.grid/sum(density.grid)
table.probs <- cbind(round(inflation.grid, digits=2), round(prob.density*100, 2))

sum(table.probs[table.probs[,1] >1 & table.probs[,1] <2, 2])
