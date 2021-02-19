// http://blog.sarantop.com/notes/mvn
// sudo clang++ -fopenmp -L /usr/local/opt/libomp/lib
// -I/usr/local/include/eigen3 -L/usr/local/opt/catch2/lib
// -I/usr/local/opt/catch2/include metropolis.cpp -o metropolis.out

#define CATCH_CONFIG_MAIN
#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include <Eigen/Eigen>
#include <cmath>
#include <iostream>
#include <random>
#include <vector>

#include "catch2/catch.hpp"

using std::cout;
std::random_device rd{};
std::mt19937 gen{rd()};

// Random Number Generator Stuff
double random_normal(double mean = 0, double std = 1) {
  std::normal_distribution<double> d{mean, std};
  return d(gen);
};

double random_unif(double min = 0, double max = 1) {
  std::uniform_real_distribution<double> d{min, max};
  return d(gen);
};

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
  double sqrt2pi = std::sqrt(2 * M_PI);
  double quadform = (x - mean).transpose() * sigma.inverse() * (x - mean);
  double norm = std::pow(sqrt2pi, -n) * std::pow(sigma.determinant(), -0.5);

  return norm * exp(-0.5 * quadform);
}

double Mvn::lpdf(const Eigen::VectorXd &x) const {
  double n = x.rows();
  double sqrt2pi = std::sqrt(2 * M_PI);
  double quadform = (x - mean).transpose() * sigma.inverse() * (x - mean);
  double norm = std::pow(sqrt2pi, -n) * std::pow(sigma.determinant(), -0.5);

  return log(norm) + (-0.5 * quadform);
}

// Metropolis
Eigen::MatrixXd metropolis(int S, double width, double mu_X = 0,
                           double mu_Y = 0, double sigma_X = 1,
                           double sigma_Y = 1, double rho = 0.8) {
  Eigen::MatrixXd sigma(2, 2);
  sigma << sigma_X, rho, rho, sigma_Y;
  Eigen::VectorXd mean(2);
  mean << mu_X, mu_Y;
  Mvn binormal(mean, sigma);

  Eigen::MatrixXd out(S, 2);
  double x = random_normal();
  double y = random_normal();
  double accepted = 0;
#pragma omp parallel
  {
#pragma omp for
    for (size_t i = 0; i < S - 1; i++) {
      double xmw = x - width;
      double xpw = x + width;
      double ymw = y - width;
      double ypw = y + width;

      double x_ = random_unif(xmw, xpw);
      double y_ = random_unif(ymw, ypw);

      double r = std::exp(binormal.lpdf(Eigen::Vector2d(x_, y_)) -
                          binormal.lpdf(Eigen::Vector2d(x, y)));
      if (r > random_unif()) {
        x = x_;
        y = y_;
        accepted++;
      }
      out(i, 0) = x;
      out(i, 1) = y;
    }
  }
  cout << "Acceptance rate is " << accepted / S << "\n";

  return out;
}

TEST_CASE("Metropolis") {
  BENCHMARK("Metropolis 10k") { return metropolis(10'000, 2.75); };
}

// int main() {
//   // instantiate Mvn
//   Eigen::MatrixXd sigma(2, 2);
//   sigma << 1, 0.8, 0.8, 1;
//   Eigen::VectorXd mean(2);
//   mean << 0, 0;
//   Mvn binormal(mean, sigma);

//   // test pdf and lpdf
//   Eigen::VectorXd test(2);
//   test << -0.6, -0.6;
//   cout << binormal.pdf(test) << "\n";
//   cout << binormal.lpdf(test) << "\n";

//   cout << random_normal() << "\n";
//   cout << random_unif() << "\n";

//   auto test2 = metropolis(10'000, 2.75);
//   cout << test2.topRows(10);
//   return 0;
// }
