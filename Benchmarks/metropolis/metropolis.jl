using BenchmarkTools
using Distributions

function metropolis(S::Int64, width::Float64, rho::Float64)
    binormal = MvNormal(2, rho);
    draws = Matrix{Float64}(undef, S, 2);
    x = randn(); y = randn();
    accepted = 0::Int64;
    for s in 1:S
        x_ = rand(Uniform(x - width, x + width));
        y_ = rand(Uniform(y - width, y + width));
        r = exp(logpdf(binormal, [x_, y_]) - logpdf(binormal, [x, y]));

        if r > rand(Uniform())
            x = x_;
            y = y_;
            accepted += 1;
        end
        draws[s, 1] = x; draws[s, 2] = y;
    end
    println("Acceptance rate is ", accepted / S)
    return draws
end

n_sim = 10_000;
rho = 0.8;
width = 2.75;

# 2ms
@benchmark metropolis(n_sim, width, rho);

