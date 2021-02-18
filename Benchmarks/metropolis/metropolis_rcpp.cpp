#include <Rcpp.h>
#include <RcppEigen.h>

// [[Rcpp::depends(RcppEigen)]]
using namespace Rcpp;

// Multivariate Normal
class Mvn {
 public:
  Mvn(const Eigen::VectorXd &mu, const Eigen::MatrixXd &s)
      : mean(mu), sigma(s) {}
  double pdf(const Eigen::VectorXd &x) const;
  double lpdf(const Eigen::VectorXd &x) const;
  Eigen::VectorXd mean;
  Eigen::MatrixXd sigma;
};

double Mvn::pdf(const Eigen::VectorXd &x) const {
  double n = x.rows();
  double sqrt2pi = sqrt(2 * M_PI);
  double quadform = (x - mean).transpose() * sigma.inverse() * (x - mean);
  double norm = pow(sqrt2pi, -n) * pow(sigma.determinant(), -0.5);

  return norm * exp(-0.5 * quadform);
}

double Mvn::lpdf(const Eigen::VectorXd &x) const {
  double n = x.rows();
  double sqrt2pi = sqrt(2 * M_PI);
  double quadform = (x - mean).transpose() * sigma.inverse() * (x - mean);
  double norm = pow(sqrt2pi, -n) * pow(sigma.determinant(), -0.5);

  return log(norm) + (-0.5 * quadform);
}

// Metropolis
// [[Rcpp::export]]
Eigen::MatrixXd metropolis_rcpp(int S, double width, double mu_X = 0,
                           double mu_Y = 0, double sigma_X = 1,
                           double sigma_Y = 1, double rho = 0.8) {
  Eigen::MatrixXd sigma(2, 2);
  sigma << sigma_X, rho, rho, sigma_Y;
  Eigen::VectorXd mean(2);
  mean << mu_X, mu_Y;
  Mvn binormal(mean, sigma);

  Eigen::MatrixXd out(S, 2);
  double x = rnorm(1, 0, 1)[0];
  double y = rnorm(1, 0, 1)[0];
  double accepted = 0;
  for (size_t i = 0; i < S - 1; i++) {
    double xmw = x - width;
    double xpw = x + width;
    double ymw = y - width;
    double ypw = y + width;

    double x_ = runif(1, xmw, xpw)[0];
    double y_ = runif(1, ymw, ypw)[0];

    double r = std::exp(binormal.lpdf(Eigen::Vector2d(x_, y_)) -
                        binormal.lpdf(Eigen::Vector2d(x, y)));
    if (r > runif(1)[0]) {
      x = x_;
      y = y_;
      accepted++;
    }
    out(i, 0) = x;
    out(i, 1) = y;
  }
  Rcout << "Acceptance rate is " << accepted / S << "\n";

  return out;
}
