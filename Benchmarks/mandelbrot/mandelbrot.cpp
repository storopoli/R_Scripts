// https://stackoverflow.com/questions/48069990/multithreaded-simd-vectorized-mandelbrot-in-r-using-rcpp-openmp
#include <Rcpp.h>
#include <RcppEigen.h> // Note the changed include and new attribute

using namespace Rcpp;

// [[Rcpp::depends(RcppEigen)]]



// Note the changed return type
// [[Rcpp::export]]
Eigen::MatrixXd mandelRcppEigen(const double x_min, const double x_max,
                     const double y_min, const double y_max,
                     const int res_x, const int res_y, const int nb_iter) {
  Eigen::MatrixXd ret(res_x, res_y); // note change
  double x_step = (x_max - x_min) / res_x;
  double y_step = (y_max - y_min) / res_y;
  unsigned r,c;

  for (r = 0; r < res_y; r++) {
    for (c = 0; c < res_x; c++) {
      double zx = 0.0, zy = 0.0, new_zx;
      double cx = x_min + c*x_step, cy = y_min + r*y_step;
      unsigned n = 0;
      for (;  (zx*zx + zy*zy < 4.0 ) && ( n < nb_iter ); n++ ) {
        new_zx = zx*zx - zy*zy + cx;
        zy = 2.0*zx*zy + cy;
        zx = new_zx;
      }

      if(n == nb_iter) {
        n = 0;
      }

      ret(r, c) = n;
    }
  }

  return ret;
}

// [[Rcpp::export]]
NumericMatrix mandelRcpp(const double x_min, const double x_max,
                     const double y_min, const double y_max,
                     const int res_x, const int res_y, const int nb_iter) {
  NumericMatrix ret(res_x, res_y); // note change
  double x_step = (x_max - x_min) / res_x;
  double y_step = (y_max - y_min) / res_y;
  unsigned r,c;

  for (r = 0; r < res_y; r++) {
    for (c = 0; c < res_x; c++) {
      double zx = 0.0, zy = 0.0, new_zx;
      double cx = x_min + c*x_step, cy = y_min + r*y_step;
      unsigned n = 0;
      for (;  (zx*zx + zy*zy < 4.0 ) && ( n < nb_iter ); n++ ) {
        new_zx = zx*zx - zy*zy + cx;
        zy = 2.0*zx*zy + cy;
        zx = new_zx;
      }

      if(n == nb_iter) {
        n = 0;
      }

      ret(r, c) = n;
    }
  }

  return ret;
}
