using BenchmarkTools
using Distributions
using FLoops

function metropolis(S::Int64, width::Float64, ρ::Float64;
                    μ_x::Float64=0.0, μ_y::Float64=0.0,
                    σ_x::Float64=1.0, σ_y::Float64=1.0)
    binormal = MvNormal([μ_x; μ_y], [σ_x ρ; ρ σ_y]);
    draws = Matrix{Float64}(undef, S, 2);
    x = randn(); y = randn();
    accepted = 0::Int64;
    @simd for s in 1:S
        x_ = rand(Uniform(x - width, x + width));
        y_ = rand(Uniform(y - width, y + width));
        r = exp(logpdf(binormal, [x_, y_]) - logpdf(binormal, [x, y]));

        if r > rand(Uniform())
            x = x_;
            y = y_;
            accepted += 1;
        end
        @inbounds draws[s, :] = [x y];
    end
    println("Acceptance rate is ", accepted / S)
    return draws
end

function metropolis_parallel(S::Int64, width::Float64, ρ::Float64;
                            μ_x::Float64=0.0, μ_y::Float64=0.0,
                            σ_x::Float64=1.0, σ_y::Float64=1.0)
    binormal = MvNormal([μ_x; μ_y], [σ_x ρ; ρ σ_y]);
    draws = Matrix{Float64}(undef, S, 2);
    x = randn(); y = randn();
    accepted = 0::Int64;
    @floop for s in 1:S
        x_ = rand(Uniform(x - width, x + width));
        y_ = rand(Uniform(y - width, y + width));
        r = exp(logpdf(binormal, [x_, y_]) - logpdf(binormal, [x, y]));

        if r > rand(Uniform())
            x = x_;
            y = y_;
            accepted += 1;
        end
        @inbounds draws[s, :] = [x y];
    end
    println("Acceptance rate is ", accepted / S)
    return draws
end

n_sim = 10_000;
ρ = 0.8;
width = 2.75;

# 6.3ms
@benchmark metropolis(n_sim, width, ρ);

# 13ms
@benchmark metropolis_parallel(n_sim, width, ρ);
