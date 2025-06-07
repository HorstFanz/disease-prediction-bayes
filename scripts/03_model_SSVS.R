## ----- 0.  House-keeping -------------------------------------------------
nsave <- 1000
nburn <- 1000
ntot  <- nsave + nburn        # total Gibbs draws

tau0 <- 0.01                  # SSVS hyper-pars
tau1 <- 10
s0   <- 0.01                  # IG(a,b) prior on σ²
S0   <- 0.01

## ----- 1.  Read and build Y, X ------------------------------------------
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

colnames(X) <- c("Intercept","GDP","Health","Pop65","MalariaInc",
                 "Density","TB_Mort","TB_Deaths","Urban")

N <- nrow(X)            # 38
K <- ncol(X)            # 9
