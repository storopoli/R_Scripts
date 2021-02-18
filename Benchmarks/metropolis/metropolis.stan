functions {
    real binormal_lpdf(real [] xy, real mu_X, real mu_Y, real sigma_X, real sigma_Y, real rho) {
    real beta = rho * sigma_Y / sigma_X; real sigma = sigma_Y * sqrt(1 - square(rho));
    return normal_lpdf(xy[1] | mu_X, sigma_X) +
           normal_lpdf(xy[2] | mu_Y + beta * (xy[1] - mu_X), sigma);
  }

  matrix metropolis_rng(int S, real width,
                        real mu_X, real mu_Y,
                        real sigma_X, real sigma_Y,
                        real rho) {
    matrix[S, 2] out; real x = normal_rng(0, 1); real y = normal_rng(0, 1); real accepted = 0;
    for (s in 1:S) {
      real xmw = x - width; real xpw = x + width; real ymw = y - width; real ypw = y + width;
      real x_ = uniform_rng(xmw, xpw); real y_ = uniform_rng(ymw, ypw);
      real r = exp(binormal_lpdf({x_, y_} | mu_X, mu_Y, sigma_X, sigma_Y, rho) -
                            binormal_lpdf({x , y } | mu_X, mu_Y, sigma_X, sigma_Y, rho));
      if (r > uniform_rng(0, 1)) { // Q({x,y}) / Q{x_,y_} = 1 in this case
        x = x_; y = y_; accepted += 1;
      }
      out[s, 1] = x;  out[s, 2] = y;
    }
    print("Acceptance rate is ", accepted / S);
    return out;
  }
}
