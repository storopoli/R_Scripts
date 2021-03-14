// http://blog.sarantop.com/notes/mvn
// using formulas from http://www.athenasc.com/Bivariate-Normal.pdf
// -L/usr/local/opt/catch2/lib -I/usr/local/opt/catch2/include
// metropolis_cpp_fast.cpp -o metropolis_fast.out

#define CATCH_CONFIG_MAIN
#define CATCH_CONFIG_ENABLE_BENCHMARKING
#define M_PI 3.14159265358979323846 /* pi */
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
struct BiNormal {
  BiNormal(const std::vector<double> &mu, const double &rho)
      : mean(mu), rho(rho) {}
  double pdf(const std::vector<double> &x) const;
  double lpdf(const std::vector<double> &x) const;
  std::vector<double> mean;
  double rho;
};

double BiNormal::pdf(const std::vector<double> &x) const {
  double x_ = x[0];
  double y_ = x[1];
  return std::exp(-((std::pow(x_, 2) - (2 * rho * x_ * y_) + std::pow(y_, 2)) /
                    (2 * (1 - std::pow(rho, 2))))) /
         (2 * M_PI * std::sqrt(1 - std::pow(rho, 2)));
}

double BiNormal::lpdf(const std::vector<double> &x) const {
  double x_ = x[0];
  double y_ = x[1];
  return (-((std::pow(x_, 2) - (2 * rho * x_ * y_) + std::pow(y_, 2))) /
          (2 * (1 - std::pow(rho, 2)))) -
         std::log(2) - std::log(M_PI) - log(std::sqrt(1 - std::pow(rho, 2)));
}

// Metropolis STL
std::vector<std::vector<double>> metropolis(int S, double width,
                                            double mu_X = 0, double mu_Y = 0,
                                            double rho = 0.8) {
  BiNormal binormal(std::vector<double>{mu_X, mu_Y}, rho);

  std::vector<std::vector<double>> out;
  double x = random_normal();
  double y = random_normal();
  double accepted = 0;
  for (size_t i = 0; i < S - 1; i++) {
    double xmw = x - width;
    double xpw = x + width;
    double ymw = y - width;
    double ypw = y + width;

    double x_ = random_unif(xmw, xpw);
    double y_ = random_unif(ymw, ypw);

    double r = std::exp(binormal.lpdf(std::vector<double>{x_, y_}) -
                        binormal.lpdf(std::vector<double>{x, y}));
    if (r > random_unif()) {
      x = x_;
      y = y_;
      accepted++;
    }
    out.push_back(std::vector<double>{x, y});
  }
  cout << "Acceptance rate is " << accepted / S << "\n";

  return out;
}

TEST_CASE("Metropolis Fast") {
  BENCHMARK("Metropolis 10k Fast") { return metropolis(10'000, 2.75); };
}

// int main() {
//   // instantiate BiNormal
//   BiNormal binormal(std::vector<double>{0, 0}, 0.8);

//   // test pdf and lpdf
//   std::vector<double> test{0.6, 0.6};
//   cout << binormal.pdf(test) << "\n";
//   cout << binormal.lpdf(test) << "\n";

//   cout << random_normal() << "\n";
//   cout << random_unif() << "\n";

//   auto test2 = metropolis(10'000, 2.75);
//   for (size_t i = 0; i < 10; i++) {
//     cout << test2[i][0];
//     cout << ", ";
//     cout << test2[i][1];
//     cout << "\n";
//   }

//   return 0;
// }
