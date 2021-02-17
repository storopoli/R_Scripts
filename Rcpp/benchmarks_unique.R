library(Rcpp)

sourceCpp(code =
'
#include <Rcpp.h>

// [[Rcpp::export]]
Rcpp::IntegerVector sort_rcpp(const Rcpp::IntegerVector& v) {
    return Rcpp::sort_unique(v);
}
'
)

sourceCpp(code =
'
#include <Rcpp.h>

// [[Rcpp::plugins("cpp2a")]]
// [[Rcpp::plugins("cpp17")]]
#include <algorithm>
#include <vector>

template <typename Container> Container sorted(Container x) {
  std::sort(std::begin(x), std::end(x));
  return x;
}

template <typename Container> Container uniqued(Container x) {
  x.resize(std::unique(std::begin(x), std::end(x)) - std::begin(x));
  return x;
}

// [[Rcpp::export]]
std::vector<int> sort_stl(const std::vector<int>& v) {
    return uniqued(sorted(std::move(v)));
}
'
)

# STL is 36% slower

n <- 1e3
v <- sample(seq.int(1, 10), n, replace = TRUE)
bench::mark(
    sort_rcpp(v),
    sort_stl(v),
    relative = TRUE
)
