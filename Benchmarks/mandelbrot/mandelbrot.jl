function mandelbrot(c, iterate_max = 500)
    z = 0.0im
    for i in 1:iterate_max
        z = z ^ 2 + c
        if abs2(z) > 4.0
            return(i)
        end
    end
    iterate_max
end

function mandelbrotImage(xs, ys, iterate_max = 500)
    z = zeros(Float64, length(xs), length(ys))
    for i in 1:length(xs)
        for j in 1:length(ys)
            z[i, j] = mandelbrot(xs[i] + ys[j] * im, iterate_max) / iterate_max
        end
    end
    z
end

iterate_max = 1_000
center_x = 0.37522
center_y = -0.22
step = 0.000002
size = 125

xs = range(-step * size, step * size, step = step) .+ center_x
ys = range(-step * size, step * size, step = step) .+ center_y

# first run 0.16s
# second run 0.13s
@time mandelbrotImage(xs, ys, iterate_max)
