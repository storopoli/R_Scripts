library(Rcpp)
library(cpp11)


# std::vector -------------------------------------------------------------
cppFunction(
"
int std_vec_grow(int n) {
  std::vector<int> v;
  for(int i = 0; i < n; ++i) {
    v.push_back(i);
  }
  return v.size();
}
")
cppFunction(
"
int std_vec_alloc(int n) {
  std::vector<int> v(n);
  for(int i = 0; i < n; ++i) {
    v[i] = i;
  }
  return v.size();
}
"
)
cppFunction(
"
std::vector<int> std_vec_trans(std::vector<int> &v) {
  return v;
}
"
)
cppFunction(
"
std::vector<double> std_vec_sort(std::vector<double> v) {
  std::sort(v.begin(), v.end());
  return v;
}
"
)
cppFunction(
"
std::vector<int> std_vec_ins(std::vector<int> v, int n, int pos, int value) {
  for(int i=0; i<n; ++i) {
    v.insert(v.begin() + pos, value);
  }
  return v;
}
"
)
cppFunction(
"
std::vector<int> std_vec_erase(std::vector<int> v, int pos, int n) {
  for(int i=0; i<n; ++i) {
    v.erase(v.begin()+pos);
  }
  return v;
}
"
)
cppFunction(
"
std::vector<int> std_vec_erase_range(std::vector<int> v, int pos, int n) {
  v.erase(v.begin()+pos, v.begin()+pos+n);
  return v;
}
"
)

# Rcpp::Vector ------------------------------------------------------------
cppFunction(
"
int rcpp_grow(int n) {
  Rcpp::IntegerVector v;
  for(int i = 0; i < n; ++i) {
    v.push_back(i);
  }
  return v.size();
}
"
)
cppFunction(
"
int rcpp_alloc(int n) {
  Rcpp::IntegerVector v(n);
  for(int i = 0; i < n; ++i) {
    v[i] = i;
  }
  return v.size();
}
"
)
cppFunction(
"
Rcpp::IntegerVector rcpp_vec_trans(Rcpp::IntegerVector &v) {
  return v;
}
"
)
cppFunction(
"
Rcpp::NumericVector rcpp_vec_sort(Rcpp::NumericVector v) {
  v.sort();
  return v;
"
)
cppFunction(
"
Rcpp::IntegerVector rcpp_vec_ins(Rcpp::IntegerVector v, int n, int pos, int value) {
  for(int i=0; i<n; ++i) {
    v.insert(v.begin() + pos, value);
  }
  return v;
}
")
cppFunction(
"
Rcpp::IntegerVector rcpp_vec_erase(Rcpp::IntegerVector v, int pos, int n) {
  for(int i=0; i<n; ++i) {
    v.erase(v.begin()+pos);
  }
  return v;
}
"
)
cppFunction(
"
Rcpp::IntegerVector rcpp_vec_erase_range(Rcpp::IntegerVector v, int pos, int n) {
  v.erase(v.begin()+pos, v.begin()+pos+n);
  return v;
}
"
)

# cpp11 -------------------------------------------------------------------
cpp_function(
"
int cpp11_grow(int n) {
  cpp11::writable::integers v;
  for(int i = 0; i < n; ++i) {
    v.push_back(i);
  }
  return v.size();
}
"
)
cpp_function(
"
int cpp11_alloc(int n) {
  cpp11::writable::integers v(n);
  for(int i = 0; i < n; ++i) {
    v[i] = i;
  }
  return v.size();
}
"
)
cpp_function(
"
cpp11::integers cpp11_vec_trans(cpp11::integers v) {
  return v;
}
"
)

# Benchmarks --------------------------------------------------------------
n <- 1e3
bench::mark(
  std_vec_grow(n),
  rcpp_grow(n),
  cpp11_grow(n),
  relative = TRUE
)
bench::mark(
  std_vec_alloc(n),
  rcpp_alloc(n),
  cpp11_alloc(n),
  relative = TRUE
)
x <- rpois(1e6, 1)
bench::mark(
  std_vec_trans(x),
  rcpp_vec_trans(x),
  cpp11_vec_trans(x),
  relative = TRUE
)
bench::mark(
  std_vec_ins(x, 500, 500, 0),
  rcpp_vec_ins(x, 500, 500, 0),
  relative = TRUE
)
bench::mark(
  std_vec_erase(x, 250, 500),
  rcpp_vec_erase(x, 250, 500),
  std_vec_erase_range(x, 250, 500),
  rcpp_vec_erase_range(x, 250, 500)
)
