// https://stackoverflow.com/questions/48069990/multithreaded-simd-vectorized-mandelbrot-in-r-using-rcpp-openmp
#include <Rcpp.h>

#include <complex>

using namespace Rcpp;

int mandelbrot(std::complex<double> c, int iterate_max = 500) {
  std::complex<double> z(0, 0);
  for (int i = 1; i <= iterate_max; i++) {
    z = std::pow(z, 2) + c;
    if (std::abs(z) > 2.0) {
      return (i);
    }
    return iterate_max;
  }
}

// [[Rcpp::export]]
NumericMatrix mandelbrotImageRcpp(NumericVector& xs, NumericVector& ys,
                                  int iterate_max = 500) {
  NumericMatrix z = (xs.length(), ys.length());
  for (int i = 0; i < xs.length(); i++) {
    for (int j = 0; j < ys.length(); j++) {
      z[i, j] = mandelbrot(xs[i] + (std::complex<double>(ys[j]) *
                                    std::complex<double>(1, 1)),
                           iterate_max) /
                iterate_max;
    }
  }
  return z;
}
