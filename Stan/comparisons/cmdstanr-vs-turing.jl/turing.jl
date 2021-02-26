# Import Turing and Distributions.
using Turing, Distributions, DynamicHMC
using RDatasets
# Functionality for splitting and normalizing the data.
using MLDataUtils: shuffleobs, splitobs, rescale!

# Import the "Default" dataset
data = RDatasets.dataset("datasets", "mtcars");

# Remove the model column.
select!(data, Not(:Model))

# Turing requires data in matrix form.
target = :MPG;
X = Matrix(select(data, Not(target)));
target = data[:, target];

# Standardize the features.
μ, σ = rescale!(X; obsdim=1);
# Standardize the target
μtarget, σtarget = rescale!(target; obsdim=1);

# Bayesian linear regression.
@model function linear_regression(x, y)
    # Set variance prior.
    σ₂ ~ truncated(Normal(0, 100), 0, Inf)

    # Set intercept prior.
    intercept ~ Normal(0, sqrt(3))

    # Set the priors on our coefficients.
    nfeatures = size(x, 2)
    coefficients ~ MvNormal(nfeatures, sqrt(10))

    # Calculate all the mu terms.
    mu = intercept .+ x * coefficients
    y ~ MvNormal(mu, sqrt(σ₂))
end

model = linear_regression(X, target);

println(Threads.nthreads())

# 16s to Compile all Models

# 1s to Sample
@time nuts = sample(model, NUTS(), 2_000, drop_warmup=true);


# 1.8s To Sample
@time nuts = sample(model, DynamicNUTS(), 2_000, drop_warmup=true);


# 2.8s to Sample
@time parallel_chain = sample(model, DynamicNUTS(), MCMCThreads(), 2_000, 4, drop_warmup=true)

oi = parallel_chain
