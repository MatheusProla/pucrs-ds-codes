###################################################
###      Introdução à Estatística com o R       ###
###              Filipe J. Zabala               ###
###        www.estatisticaclassica.com          ###
###           filipe.zabala@pucrs.br            ###
###          2019-04-27 e 2019-06-15            ###
###  Attribution 4.0 International (CC BY 4.0)  ###
### https://creativecommons.org/licenses/by/4.0 ###
###################################################

###
## Exercícios
#

# Pra resolver os exercícios a seguir utilize-se dos códigos apresentados em aula, bem como da
# apostila disponível em http://www.estatisticaclassica.com/Zabala%20(2019-03-06)%20-%20Estati%CC%81stica%20Cla%CC%81ssica%20no%20RStudio%20(draft%20version).pdf



# As questões 1 a 3 foram adaptada de www.estatisticaclassica.com/R/maindonald2008.pdf (pg. 19)

# 1. Para cada sequência a seguir, tente prever o resultado antes de rodar.
# 1a
resultado <- 0
for(i in 2:4){ resultado <- i + resultado }
resultado

# 1b
resultado <- 7
for(i in 2:4){ resultado <- i + resultado }
resultado

# 1c
resultado <- 7
for(i in 2:4){ resultado <- i * resultado }
resultado

# 1d
resultado <- -1
for(i in 2:4){ resultado <- i * resultado }
resultado


# 2. Considere a função base::prod.
# 2a. Olhe a documentação da função.
# 2b. Refaça os itens 1c e 1d usando prod.

prod(7, 2:4)
prod(-1, 2:4)

# 3. O volume de uma esfera de raio r é dado por (4/3)*pi*r^3. Para esferas de raios 3,4,5,...,20 
# encontre os volumes correspondentes e imprima os resultados em uma tabela. 

radius <- function(r) {
  return((4/3)*pi*r^3)
}
radius(3:20)

# 4. Qual a diferença entre NA e NaN?

?NA
?NaN

# 5. Considere as operações a seguir e tente predizer os resultados.
# 5a
(5==5)

# 5b
as.numeric(5==5)

# 5c
sum(is.na(rep(NA,5)))

# 5d
v <- c(9:4, NA)
sum(v)


# 6. Considere a matriz A.
A <- matrix(1:30, nrow = 5, ncol = 6)
# 6a. Atribua as letras A a F como nome de colunas usando LETTERS.
colnames(A) <- LETTERS[1:ncol(A)]
rownames(A) <- LETTERS[1:nrow(A)]

# 6b. Obtenha a soma das colunas utilizando um for.
for(i in 1:ncol(A))
  print(sum(A[,i]))
# 6c. Obtenha a soma das colunas utilizando a função colSums.
colSums(A)
# 6d. Obtenha a soma das colunas utilizando as funções apply e sum.
apply(A, 2, sum)

# 7. Considere o vetor a seguir.
v <- c(2:9,6:15)

# 7a. Obtenha o número de elementos (tamanho/comprimento).
length(v)
# 7b. Obtenha o número de elementos únicos.
length(unique(v))
# 7c. Obtenha uma tabela com a frequência dos valores de v.
table(factor(v))
# 7d. Obtenha uma tabela com a frequência relativa (percentual) dos valores de v.
100 * (table(v) / length(v))
# 7e. Verifique quantos valores são pares, comparando com o vetor gerado por seq(2,15,2).
sum(v %% 2 == 0)
sum(seq(2,15,2) %% 2 == 0)

# 8. Escreva uma função de n que retorne uma matriz com os números ímpares de 1 a n
# na coluna 1, o logaritmo na base 10 dos valores da coluna 1 na coluna 2
# e a diferença ao quadrado das colunas 1 e 2 na coluna 3.
library(tidyverse)
magic <- function(n) {
  return(
    tibble(
      x1 = 1:n,
      x2 = log10(x1),
      x3 = (x2 - x1) ^ 2
    )
  )
}
(magic(10))

# 9. Escreva uma função que atribua os números 1 a 10 a objetos chamados, 
# respectivamente, 'Num 1', 'Num 2', ..., 'Num 10'.
for(i in 1:10) {
  assign(paste0("Num", i), i)
}

# As questões 10 a 12 foram adaptadas de https://r4ds.had.co.nz/data-visualisation.html.

# 10. Execute library(tidyverse) e considere o banco de dados mpg.
# 10a. Quantas linhas e colunas há em mpg?
mpg %>% ncol
mpg %>% nrow
# 10b. O que descreve a variável drv? Faça ?mpg.
?mpg
# 10c. Faça um gráfico de dispersão de hwk por cyl.
mpg %>% select(hwy, cyl) %>% plot
# 10d. O que acontece se você fizer um gráfico de dispersão de class por drv? Este gráfico é útil?
mpg %>% select(class, drv) %>% plot

# 11. Considere o código abaixo. O que faz o .?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
plot( mpg ~ cyl + carb, data= mtcars )

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# 12. Tente prever o resultado do código abaixo, e em seguida rode-o.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

# A questão 13 foi adaptada de https://r4ds.had.co.nz/transform.html.

# 13. Execute library(tidyverse); library(nycflights13) e considere o banco de dados 'flights'.
# Encontre todos os voos que
library(nycflights13)
library(tidyverse)

# 13a. Tiveram atraso de chegada de duas horas ou mais.
flights %>% filter(arr_delay >= 2)
# 13b. Voaram para Houston (IAH ou HOU).
flights %>% filter(dest == "HOU")
# 13c. Foram operados pela United, American ou Delta.
flights %>% filter(substring(carrier, 1, 1) == "A" | substring(carrier, 1, 1) == "U" | substring(carrier, 1, 1) == "D")
# 13d. Partiram no inverno no hemisfério Sul (julho, agosto e setembro).
flights %>% filter(month %in% 7:9)
flights %>% filter(month %nin% 7:9)

maior_que_10 <- function(x) {
  x > 10
}

menor_que_10 <- Negate(maior_que_10)

maior_que_10(11)
menor_que_10(9)

"%nin%" <- Negate("%in%")
"%menor%" <- Negate(">")
"%maior%" <- Negate("<")
10 %menor% 12
100 %maior% 50

# 13d. Cheguaram mais de duas horas atrasado, mas não saíram atrasados.
flights %>% filter((arr_delay / 60) > 2 & dep_delay <= 0)
# 13e. Atrasaram pelo menos uma hora, mas fizeram mais de 30 minutos em vôo.
flights %>% filter(arr_delay > 60 & air_time > 30) 

flights <- flights %>% transform(date = as.Date(paste(year, month, day), "%Y%m%d"))
flights %>% select(date, arr_delay) %>% na.omit() %>% group_by(MoNtHhhh=format(date, "%m")) %>% summarize(sum=sum(arr_delay))
flights %>% select(date, arr_delay) %>% na.omit() %>% group_by(MoNtHhhh=format(date, "%m"), Year=format(date, "%Y")) %>% summarize(sum=sum(arr_delay))
flights %>% select(year) %>% unique

# 13f. Partiram entre a meia-noite e as 6h (inclusive).
# 13g. Como você poderia usar o arrange() para classificar todos os valores ausentes no início? (Dica: use is.na ()).
flights %>% 
  arrange(desc(is.na(dep_time)),
          desc(is.na(dep_delay)),
          desc(is.na(arr_time)), 
          desc(is.na(arr_delay)),
          desc(is.na(tailnum)),
          desc(is.na(air_time)))
# 13h. Classifique os voos para encontrar os voos mais atrasados. Encontre os voos que saíram mais cedo.
flights %>% arrange(desc(arr_delay))
flights[order(-flights$arr_delay),]
# 13i. Classifique os voos para encontrar os voos mais rápidos.
flights[order(flights$arr_time - flights$dep_time),]
# 13j. Quais voos viajaram as maiores distâncias? E as menores?
flights[which.max(flights$distance),]
flights[which.min(flights$distance),]
# 13k. Selecione as colunas dep_time até tailnum.
columns[which(columns == 'dep_time'):which(columns == 'tailnum')]
# 13l. Selecione as colunas que contenham a palavra 'time'.
# 13m. Selecione as colunas que iniciam com 'sched'.
columns <- colnames(flights)
columns[grep("time", columns)]
columns[grep("sched", columns)]

# 14. Seja o vetor de dados v, descrito abaixo.
v <- c(15.9,18.9,25.1,16.0,19.6,16.5,21.5,25.6,17.0,17.6,18.1,28.9)
# 14a. Econtre a média de v.
mean(v)
# 14b. Econtre a mediana de v.
median(v)
# 14c. Econtre o desvio padrão de v.
sd(v)
# 14d. Explique o resultado de all.equal(var(v),sd(v)^2).
var(v) == sd(v)^2
all.equal(var(v),sd(v)^2)
# 14e. Obtenha os quartis desta distribuição. Dica: ?quantile.
quantile(v)

# 15. Em uma startup, três programadores A1, A2 e A3 trabalham no desenvolvimento de funções necessárias
# ao negócio. Com as respectivas probabilidades 0.01, 0.02 e 0.03, as funções criadas por cada um destes
# profissionais apresentam um bug. Sabe-se também que A1 prepara 60% das funções, A2 30% e A3 10%.
# Considere os eventos 'Ai: a função foi escrita pelo programador i' e 'B: função com bug'.
# 15a. Quais os valores de Pr(A1), Pr(A2), Pr(A3), Pr(B|A1), Pr(B|A2) e Pr(B|A3)?
#P(A1|B1) / P(A1|B1 U A2|B2 U A3|B3)
#0.1 * 0.03 / (0.1 * 0.03 + 0.3 * 0.02 + 0.6 * 0.01)
pa1 <- 0.01 * 0.6
pa2 <- 0.02 * 0.3
pa3 <- 0.03 * 0.1
# 15b. Se uma função apresenta um bug, qual a probabilidade de que tenha sido desenvolvida pelo programador A3?
ba3 <- pa3/(pa1+pa2+pa3)

# 16. Suponha n = 8 lanç̧amentos de uma moeda com probabilidade cara p = 0.3, denotado por X ∼ B(8, 0.3).
# 16a. Calcule o desvio padrão de X.
sd(dbinom(0:8, 8, 0.3))
# 16b. Calcule a probabilidade de pelo menos uma cara.
1-dbinom(0, 8, 0.3)

# 17. Considere a função f(x) = x^2-2*x+9, com x pertencente a [1,2]
# 17a. Verifique se f(x) é uma funçãko densidade de probabilidade (fdp). Dica: ?integrate.
f <- function(x) {x^2-2*x+9}
integrate(f, lower=1, upper=2)
curve(f, from=1, to=2)
#integrate(f, lower=1, upper=1.1249)
# 17b. Caso f(x) não seja fdp, encontre uma constante c que garanta que a área de f(x) seja 1.
f <- function(x) {x^2-2*x+1.6666669}
integrate(f, lower=1, upper=2)
curve(f, from=1, to=2)

# 18. Uma pesquisa de torcidas divulgada pelo Ibope em 01/06/10 colocou o Flamengo como líder 
# na preferência nacional no futebol com 17.2% dos torcedores brasileiros. Conforme o levantamento,
# o Corinthians é o segundo colocado, com 13.4% dos torcedores. Dos grandes times gaúchos, o Grêmio
# está na sexta posição (4.0%) e Inter na dáecima (2.5%). O Ibope ouviu 2500 pessoas, a partir dos 10 anos,
# no primeiro trimestre de 2010, em 141 cidades "de todos os tipos e tamanhos", de acordo com o diário 
# Lance, que encomendou a pesquisa.

# 18a. Qual a estimativa pontual da proporção de torcedores do Grêmio? E do Inter?
n <- 2500
p <- 0.04*n # 4/n
z <- abs(qnorm(0.025))
(e <- z*sqrt(p*(1-p)/n))
(LIpi <- p - e)
(LSpi <- p + e)
# 18b. Construa um intervalo com 95% de confiança para a proporção universal de brasileiros que torcem 
# pelo Grêmio, e outro para o Inter.
# 18c. Qual a margem de erro do intervalo do item 17b?
# 18d. Se você tivesse que construir um intevalo de confiança 92% no item 18b, o que mudaria?

"%matheus%" <- function(x, y) {
  x+y
}

# 19. Seja a matriz de transição P a seguir, de três estados (classificação de clientes) A, B, C,
# considerados semestralmente.
(P <- matrix(c(.5,.3,.2, .2,.6,.2, 0,.2,.8),
             nrow = 3, byrow = TRUE))
rownames(P) <- colnames(P) <- LETTERS[1:nrow(P)]
v0 <- c(100,400,800)
# 19a. Interprete o valor 0.3.
# 19b. Obtenha P^2. Interprete o valor da primeira linha, segunda coluna.
P2 <- P %*% P
# 19c. Se há respectivamente 100, 400 e 800 em cada classe no instante zero, quantos clientes
# espera-se em cada classe após 3 passos? Considere o vetor v abaixo.
v1 <- v0 %*% P
v2 <- v1 %*% P

# 19d. Após um longo tempo, qual a probabilidade de os clientes irem para cada um dos estados?
# Faça utilizando uma função personalizada e compare os resultados com markovchain.::steadyStates().
# 19e. Faça o gráfico da matriz Pmc, considerando a estrutura do pacote markovchain.

library(markovchain)
Pmc <- new('markovchain', transitionMatrix = P,
           states = LETTERS[1:ncol(P)],
           name='MarkovChain P')
