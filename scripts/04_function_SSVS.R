# this is the function from the course. it can be used for our model but might 
# hvae to be updated accordingly

SSVS.reg <- function(y, X, nsave, nburn, prior, tau1, tau0){
  T <- nrow(X)
  K <- ncol(X)
  
  ntot <- nsave + nburn
  # Get OLS quantities
  b.OLS <- solve(crossprod(X)+diag(K)*1e-3) %*% crossprod(X, y)
  sigma2.OLS <- sum((y - X%*%b.OLS)^2)/(T-K)
  V.OLS <- diag(sigma2.OLS * solve(crossprod(X)+diag(K)*1e-3))
  
  h <- 1/sigma2.OLS # Startwert für h
  
  # Setting up the prior
  # Prior auf beta N(b.0, V.0)
  b.0 <- matrix(0, K, 1)
  
  if (prior == "Ridge"){
    delta <- 10 # 
    V.0 <- delta * diag(K)
    
    # Prior on delta
    c.delta <- d.delta <- 0.01
  } else {
    tau1.vec <- tau1 * sqrt(V.OLS) # 
    tau0.vec <- tau0 * sqrt(V.OLS) # 
    delta <- rep(1, K)
    
    a_ <- 2 # X
    b_ <- 2 # X
    
    V.0 <- diag(delta * tau1.vec^2 + (1-delta) * tau0.vec^2)
    
    p_ <- 0.5
  }
  
  # Prior auf h
  c.0 <- d.0 <- 0.01
  
  # MCMC Storage objects
  beta.store <- matrix(NA, nsave, K) # E
  sigma2.store <- matrix(NA, nsave, 1) # E
  if (prior=="Ridge") delta.store <- matrix(NA, nsave, 1) else {
    delta.store <- matrix(NA, nsave, K) # E
    p_.store <- matrix(NA, nsave, 1) # E
  } 
  predict.store <- matrix(NA, nsave, 1) # E
  
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
      # This step samples the indicators coefficient-by-coefficient
      for (j in 1:K){
        A <- dnorm(beta.draw[j], 0, tau1.vec[j]) * p_ 
        B <- dnorm(beta.draw[j], 0, tau0.vec[j]) * (1-p_)
        p_j <- A/(A+B)
        
        if (p_j > runif(1)){
          delta[j] <- 1 
        }else{
          delta[j] <- 0
        }
      }
      
      V.0 <- diag(delta*tau1^2 + (1-delta)*tau0^2)
      
      # Sample the prior inclusion probability from a Beta distribution
      a.1 <- sum(delta) + a_
      b.1 <- K - sum(delta) + b_
      
      p_ <- rbeta(1, a.1, b.1)
    }
    
    # Wait until burn-in phase is over and then store draws of beta and h
    if (irep > nburn){
      beta.store[irep-nburn, ] <- t(beta.draw)
      sigma2.store[irep-nburn] <- sigma2
      delta.store[irep-nburn, ] <- delta
      if (prior=="SSVS") p_.store[irep-nburn, ] <- p_
      
      # Ziehung aus der Prognosedichte
      eps_tp1 <- rnorm(1, 0, sqrt(sigma2))
      ytp1 <- t(beta.draw) %*% XT + eps_tp1
      predict.store[irep-nburn, ] <- ytp1
    }
    print(irep)
  }
  
  ret.list <- list("beta"=beta.store, "sigma2"=sigma2.store, "delta"=delta.store, "p_"=p_.store, "predict"=predict.store)
  return(ret.list)
}







