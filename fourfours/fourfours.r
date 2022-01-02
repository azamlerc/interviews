fours <- function(v1,v2) {
  v <- c()
  for (a in v1) {
    for (b in v2) {
      v <- c(v, a+b, a-b, b-a, a*b, round(a/b, digits=6), round(b/a, digits=6))
    }
  }
  v <- sort(unique(v))
  v[v != Inf]
}

f1 <- c(0.4, sqrt(4), 4, 24)
f2 <- fours(f1,f1)
f3 <- fours(f1,f2)
f4 <- c(fours(f1,f3), fours(f2,f2))

target <- 1:100
found <- intersect(f4, target)
missing <- target[!(target %in% found)]
print(missing)
