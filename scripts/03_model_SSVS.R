## ----- 0.  House-keeping -------------------------------------------------
# we simply took those from the original script 
nsave <- 1000
nburn <- 1000
ntot  <- nsave + nburn        # total Gibbs draws

tau0 <- 0.01                  # SSVS hyper-pars
tau1 <- 10
s0   <- 0.01                  # IG(a,b) prior on σ²
S0   <- 0.01

## ---- read and build Y, X ----
dat <- read.csv("data/processed/final_table_avg.csv")

Y <- as.matrix(dat$Estimate.y)       # response: malaria mortality (38 × 1)

X <- cbind(1,                                   # intercept
           scale(dat$GDP.per.capita..PPP..constant.2021.international...),
           scale(dat$Current.health.expenditure.per.capita..PPP..current.international...),
           scale(dat$rate.over65),
           scale(dat$Estimate.x),                # malaria incidence
           scale(dat$Population.density),
           scale(dat$Estimated.mortality.from.all.forms.of.tuberculosis.per.100.000.population),
           scale(dat$Estimated.number.of.deaths.from.all.forms.of.tuberculosis),
           scale(dat$Share.of.population.residing.in.urban.areas..HYDE.estimates.and.UN.projections.))

# scale normalizes all the predictor variables so they have mean 0 and sd 1.
# important: if we want to interpret the results for the prediction later, we need to descale again

# rename columns
colnames(X) <- c("Intercept","GDP","Health","Pop65","MalariaInc",
                 "Density","TB_Mort","TB_Deaths","Urban")

# check for missing values
NA_detect <- function (obj){ 
storeNa <- 0
  for (i in 1:ncol(obj)){
    for (j in 1:nrow(obj)){
      if (is.na(obj[j, i])){
        storeNa <- storeNa + 1
      }
    } 
  }  
  paste("You have currently: ", storeNa, "NAs in your object")
}

NA_detect(X)
#  oh no one missing value detected

# use mean imputation to assure computability

X[is.na(X[, "Health"]), "Health"] <- mean(X[, "Health"], na.rm = TRUE)
NA_detect(X) # looks better

## ---- check for multicolliniarity of the predictors ----

cor_matrix <- cor(X[,-1])  # Exclude the intercept
print(round(cor_matrix, 2))  # Rounded for readability

# nothing over 0.8 looks good


library(car)

# Fit a basic linear model (response can be arbitrary here, e.g., malaria deaths)
y_dummy <- dat$Estimated.number.of.malaria.deaths
lm_model <- lm(y_dummy ~ ., data = as.data.frame(X[,-1]))  # Exclude intercept manually
vif(lm_model) # nothing over 5 looks good

## ---- build actual model ----


N <- nrow(X)            # number of countries
K <- ncol(X)            # number of predictors

# section can stay the same because we use same object names 
A.OLS <- solve(crossprod(X))%*%crossprod(X,Y) # solve creates inverse so we have here (X'X)^-1 (X'Y) = \hat{\beta}. result is Matrix of OLS regression coefficients
SSE <- crossprod(Y-X%*%A.OLS) # analogous (Y-X\beta)'(Y-X\beta)
SIG.OLS <- SSE/(N-K) # estimate of error variance, N number observations,K number predictors

#In the next step, create storage matrices for Gibbs loop and initialize prior
gamma <- matrix(1,K,1) #indicators, start with full model
# we want to start with all predictors included. so we create a Kx1 Matrix filled with 1
sigma2.draw <- as.numeric(SIG.OLS) # converts to numeric if it wasn't already
V.prior <- diag(as.numeric(gamma*tau1+(1-gamma)*tau0)) # picks either tau1 or tau0 as prior variance for the variable


ALPHA.store <- matrix(NA,nsave,K) # creates matrix with NA entries, nsave rows, K columns
SIGMA.store <- matrix(NA,nsave,1) # creates matrix with NA entries, nsave rows, 1 columns
Gamma.store <- matrix(NA,nsave,K) # creates matrix with NA entries, nsave rows, K columns

for (irep in 1:ntot){
  #Draw ALPHA given rest from multivariate normal
  # we need to create the meand and variances to draw from the distribution ntot times
  V.post <- solve(crossprod(X)*1/sigma2.draw+diag(1/diag(V.prior)))
  # constructing posterior variance according to multivariate formula V.post = (1/\sigma^2 * X'X + V^-1.prior)^-1
  A.post <- V.post%*%(crossprod(X,Y)*1/sigma2.draw)
  # computes the posterior mean using the formula
  A.draw <- A.post+t(chol(V.post))%*%rnorm(K)
  # draws sample from multivariate noraml distribution
  
  #Draw indicators conditional on ALPHA
  for (jj in 1:K){
    p0 <- dnorm(A.draw[[jj]],0,sqrt(tau0)) # Probability under "exclude" prior
    p1 <- dnorm(A.draw[[jj]],0,sqrt(tau1)) # Probability under "include" prior
    p11 <- p1/(p0+p1) # Posterior inclusion probability
    
    if (p11>runif(1)) gamma[[jj]] <- 1 else gamma[[jj]] <- 0 # Bernoulli draw
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


# ----ideas for description----

par(mfrow=c(3,3))  # arrange plots

for (k in 1:K){
  plot(ALPHA.store[,k], type='l',
       main=colnames(X)[k],
       xlab="Iteration", ylab="Coefficient")
}


plot(SIGMA.store, type='l', main="Sigma² Trace", xlab="Iteration", ylab="Variance")


# Combine and display
importance <- data.frame(Variable = colnames(X),
                         PIP = round(PIP.mean, 3),
                         PostMean = round(A.mean, 3))

print(importance[order(-importance$PIP), ])  # Sort by importance



par(mfrow=c(3,3))
for (k in 1:K){
  hist(ALPHA.store[,k], main=colnames(X)[k],
       xlab="Posterior Draws", breaks=30, col="lightblue")
}



summary(ALPHA.store)
summary(SIGMA.store)
summary(Gamma.store)


barplot(PIP.mean, names.arg=colnames(X), las=2, col="skyblue",
        main="Posterior Inclusion Probabilities", ylim=c(0,1))
abline(h=0.5, col="red", lty=2)
