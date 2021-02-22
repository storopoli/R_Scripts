library(brms)

data(mtcars)

# Using brms
fit_brms <- brm(mpg ~ 1 + (hp + wt | cyl), data = mtcars)

model_code <- stancode(fit_brms)

print(model_code)
