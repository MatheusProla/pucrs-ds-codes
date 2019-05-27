# MARTIN JUNGBLUT SCHREINER
# MATHEUS PROLA PFITSCHER

# 1
getvalue <- function(n) {
  ifelse(n == " ", 0, which(letters == n))
}

nomero <- function(name) {
  s <- 0
  for (i in strsplit(name, "")[[1]]) {
    s <- s + getvalue(tolower(i))
  }
  s
}

nomero("filipe zabala") == 100

# 2
m <- nomero("matheus martin")
s <- m/4
set.seed(m)

observations <- rnorm(10*m, m, s)
hist(observations)
summary(observations)

# 3
# a
P_B = 3/4
P_b = 1/4

Px <- 1/6
Pb1 <- (1 - (Px*4)) / 4
Pb6 <- 3 * Pb1

# Sabendo que o resultado é 6, a probabilidade do dado ser balanceado é 66%.
b <- (Px+Px+Px) / (Px+Px+Px+Pb6)

# 4
n <- 2500
p <- 0.172
z <- abs(qnorm(0.025))
(e <- z*sqrt(p*(1-p)/n))

(LIpi <- p - e)
(LSpi <- p + e)

# 5
# a
# O valor representado na primeira linha, segunda coluna(P[1, 2]) é a probabilidade da pessoa
# percenter à categoria A, e tornar-se membro da categoria B em um passo.
P <- matrix(c(.4,.3,.3, .3,.5,.2, .1,.2,.7), nrow = 3, byrow = TRUE)
rownames(P) <- colnames(P) <- LETTERS[1:nrow(P)]

P2 <- P %*% P

# b
t1 <- c(200, 300, 500)
t2 <- t1 %*% P
t3 <- t2 %*% P