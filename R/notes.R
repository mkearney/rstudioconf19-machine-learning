# parsnip
# 1. Create specification
# 2. Set the engine
# 3. Fit the model

## Benefits
## + Can use different engines

## 1. specify linear regression
spec_lin_reg <- linear_reg()

## 2. set lm engine
spec_lm <- set_engine(spec_lin_reg, "lm")
spec_lm

## 3. fi the model
fit_lm <- fit(
  spec_lm,
  log10(Sale_Price) ~ Longitude + Latitude,
  data = ames_train
)
summary(fit_lm$fit)


## 2*: SWAP ENGINE FROM LM TO STAN
spec_stan <- spec_lin_reg %>%
  # Engine specific arguments are passed through here
  set_engine("stan", chains = 4, iter = 1000)

## 3*: REFIT
fit_stan <- fit(
  spec_stan,
  log10(Sale_Price) ~ Longitude + Latitude,
  data = ames_train
)
summary(fit_stan$fit)

## compare model coefficients
coef(fit_stan$fit)
coef(fit_lm$fit)

