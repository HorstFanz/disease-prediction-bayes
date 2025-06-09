# -----------------  SSVS – Leave-One-Out CV  -----------------
library(car)     # vif()
library(MASS)    # mvrnorm() fallback if chol fails
set.seed(123)    # reproducible

# ---------- 1. Read & preprocess -----------------------------------------
dat <- read.csv("data/processed/final_table_avg.csv")

Y_raw <- dat$Estimate.y                         # 38 × 1
X_raw <- cbind(
  1,
  dat$GDP.per.capita..PPP..constant.2021.international...,
  dat$Current.health.expenditure.per.capita..PPP..current.international...,
  dat$rate.over65,
  dat$Estimate.x,
  dat$Population.density,
  dat$Estimated.mortality.from.all.forms.of.tuberculosis.per.100.000.population,
  dat$Estimated.number.of.deaths.from.all.forms.of.tuberculosis,
  dat$Share.of.population.residing.in.urban.areas..HYDE.estimates.and.UN.projections.
)
colnames(X_raw) <- c("Intercept","GDP","Health","Pop65",
                     "MalariaInc","Density","TB_Mort",
                     "TB_Deaths","Urban")

# Mean-impute the single NA in Health
X_raw[is.na(X_raw[,"Health"]),"Health"] <-
  mean(X_raw[,"Health"], na.rm = TRUE)

# -------  scale X (except intercept) & Y  ----------------
X_scaled <- X_raw
X_scaled[,-1] <- scale(X_raw[,-1])
Y_scaled <- scale(Y_raw)
Y_mean   <- attr(Y_scaled, "scaled:center")
Y_sd     <- attr(Y_scaled, "scaled:scale")

# ---------- 2. Hyper-parameters & storage -------------------------------
nsave <- 1000
nburn <- 1000
ntot  <- nsave + nburn

tau0 <- 0.1          # << relaxed spike
tau1 <- 10
s0   <- 0.01
S0   <- 0.01

N <- nrow(X_scaled)
K <- ncol(X_scaled)

pred_scaled <- rep(NA, N)
pip_mat     <- matrix(NA, N, K)   # PIP per left-out fold

# ---------- 3. LOO loop --------------------------------------------------
for (i in 1:N) {
  cat("LOO fold", i, "of", N, "\n")
  
  X_train <- X_scaled[-i, ]
  Y_train <- Y_scaled[-i]
  X_test  <- X_scaled[i, , drop = FALSE]
  
  # ----- OLS starting values ----------
  A.OLS <- solve(crossprod(X_train)) %*% crossprod(X_train, Y_train)
  SSE   <- crossprod(Y_train - X_train %*% A.OLS)
  SIG.OLS <- SSE / (N-1 - K)
  
  gamma <- matrix(1, K, 1)
  sigma2.draw <- as.numeric(SIG.OLS)
  V.prior <- diag(as.numeric(gamma * tau1 + (1-gamma) * tau0))
  
  # storage for this fold
  alpha_keep  <- matrix(NA, nsave, K)
  gamma_keep  <- matrix(NA, nsave, K)
  sigma_keep  <- numeric(nsave)
  y_pred_keep <- numeric(nsave)
  
  # ------------- Gibbs sampler -----------------
  for (rep in 1:ntot){
    
    # 1. β | rest
    V.post <- solve(crossprod(X_train) / sigma2.draw +
                      diag(1 / diag(V.prior)))
    A.post <- V.post %*% (crossprod(X_train, Y_train) / sigma2.draw)
    A.draw <- A.post + t(chol(V.post)) %*% rnorm(K)
    
    # 2. γ | rest
    for (j in 1:K){
      p0 <- dnorm(A.draw[j], 0, sqrt(tau0))
      p1 <- dnorm(A.draw[j], 0, sqrt(tau1))
      gamma[j] <- rbinom(1, 1, p1/(p0+p1))
    }
    V.prior <- diag(as.numeric(gamma * tau1 + (1-gamma) * tau0))
    
    # 3. σ² | rest
    S.post <- crossprod(Y_train - X_train %*% A.draw)/2 + S0
    s.post <- S0 + (N-1)/2
    sigma2.draw <- 1 / rgamma(1, s.post, S.post)
    
    # ---- store after burn-in
    if (rep > nburn) {
      m <- rep - nburn
      alpha_keep[m, ]  <- A.draw
      gamma_keep[m, ]  <- gamma
      sigma_keep[m]    <- sigma2.draw
      y_pred_keep[m]   <- X_test %*% A.draw                # mean prediction
    }
  } # end Gibbs
  
  # Posterior predictive mean for left-out obs
  pred_scaled[i] <- mean(y_pred_keep)
  pip_mat[i, ]   <- colMeans(gamma_keep)
}

# ---------- 4. Back-transform predictions & evaluate  --------------------
pred_original <- pred_scaled * Y_sd + Y_mean

loo_results <- data.frame(
  Country   = dat$Entity.x,
  True      = Y_raw,
  Predicted = pred_original,
  Error     = pred_original - Y_raw
)

print(head(loo_results, 10))
cat("RMSE: ", sqrt(mean(loo_results$Error^2)), "\n")

# ---------- 5. Average PIPs across folds --------------------------------
overall_pip <- colMeans(pip_mat)
print(round(overall_pip, 3))
barplot(overall_pip, names.arg=colnames(X_scaled), las=2, ylim=c(0,1),
        col="skyblue", main="Avg PIP across LOO folds")
abline(h=0.5, col="red", lty=2)

# ---------- 6. Save results ---------------------------------------------
dir.create("results", showWarnings = FALSE)
write.csv(loo_results, "results/loo_predictions.csv", row.names = FALSE)
