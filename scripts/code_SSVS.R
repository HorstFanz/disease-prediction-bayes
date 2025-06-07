#Example SSVS
#Start by simulating a multivariate regression model 

N <- 100
X1 <- runif(N,-1,1)
X2 <- runif(N,-1,1)
X3 <- runif(N,-1,1)
sigma.true <- 0.1


beta.true <- c(2,1,4)

y <- cbind(X1,X2,X3)%*%beta.true+rnorm(N,0,sigma.true)

#Start with actual estimation and Gibbs preliminaries
nsave <- 1000
nburn <- 1000
ntot <- nsave+nburn
#Prior prelims for SSVS
tau0 <- 0.01
tau1 <- 10

s0 <- 0.01
S0 <- 0.01
#Construct Y and X
Y <- matrix(y)
X <- cbind(rnorm(N,0,10),rnorm(N,0,1),X1,X2,X3)
N <- nrow(Y)
K <- ncol(X)

#Get OLS quantities
A.OLS <- solve(crossprod(X))%*%crossprod(X,Y)
SSE <- crossprod(Y-X%*%A.OLS)
SIG.OLS <- SSE/(N-K)
#In the next step, create storage matrices for Gibbs loop and initialize prior
gamma <- matrix(1,K,1) #indicators, start with full model
sigma2.draw <- as.numeric(SIG.OLS)
V.prior <- diag(as.numeric(gamma*tau1+(1-gamma)*tau0))


ALPHA.store <- matrix(NA,nsave,K)
SIGMA.store <- matrix(NA,nsave,1)
Gamma.store <- matrix(NA,nsave,K)

for (irep in 1:ntot){
  #Draw ALPHA given rest from multivariate normal
  V.post <- solve(crossprod(X)*1/sigma2.draw+diag(1/diag(V.prior)))
  A.post <- V.post%*%(crossprod(X,Y)*1/sigma2.draw)
  A.draw <- A.post+t(chol(V.post))%*%rnorm(K)
  
  #Draw indicators conditional on ALPHA
  for (jj in 1:K){
    p0 <- dnorm(A.draw[[jj]],0,sqrt(tau0))
    p1 <- dnorm(A.draw[[jj]],0,sqrt(tau1))
    p11 <- p1/(p0+p1)
    
    if (p11>runif(1)) gamma[[jj]] <- 1 else gamma[[jj]] <- 0
  }
  #Construct prior VC matrix conditional on gamma
  V.prior <- diag(as.numeric(gamma*tau1+(1-gamma)*tau0))
  
  #Simulate sigma2 from inverse Gamma
  S.post <- crossprod(Y-X%*%A.draw)/2+S0
  s.post <- S0+N/2
  sigma2.draw <- 1/rgamma(1,s.post,S.post)  
  
  if (irep>nburn){
    ALPHA.store[irep-nburn,] <- A.draw
    SIGMA.store[irep-nburn,] <- sigma2.draw
    Gamma.store[irep-nburn,] <- gamma
  }
  print(irep)
}
#Calculate posterior inclusion probabilities
PIP.mean <- apply(Gamma.store,2,mean)
A.mean <- apply(ALPHA.store,2,mean)
SIG.mean <- apply(SIGMA.store,2,mean)






