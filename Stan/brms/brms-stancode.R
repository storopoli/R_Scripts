library(brms)

data(mtcars)

# Using brms
fit_brms <- brm(mpg ~ hp + wt, data=mtcars)

model_code <- stancode(fit_brms)

print(model_code)
