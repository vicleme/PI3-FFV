# 09-concordancia-kappa.R
# Aula 5,5 — Entregável 7: concordância entre juízes.
#
# Diferença em relação ao plano original do guia (Módulo 8): o guia sugere
# julgar só 20% em comum pra calcular kappa e dividir o resto. Na prática o
# grupo (victor, flavia, felipe) julgou os 63 parágrafos inteiros para as
# 10 consultas cada um -> overlap de 100% (630 julgamentos por juiz), o que dá
# um kappa mais robusto (calculado sobre TODO o gabarito, não uma amostra).
#
# Entrada:  estrutura/banco-de-dados/qrels_equipe.csv
#           (colunas: consulta,documento,grau,juiz, ... um julgamento por
#           linha). Sem etapa de dedup: a exportação do julgar.html não
#           gerou julgamento repetido pro mesmo (juiz,consulta,documento)
#           nesta rodada, então o bruto já entra direto aqui.
# Saída:    kappa de Cohen par a par entre os 3 juízes, impresso no console.

# fileEncoding = "UTF-8-BOM": a exportação do julgar.html grava um BOM no
# início do arquivo; sem isso a 1a coluna vira "X...consulta" em vez de
# "consulta".
qrels_bruto <- read.csv(
  file.path("estrutura", "banco-de-dados", "qrels_equipe.csv"),
  stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM"
)

# formato largo: 1 linha por (consulta,documento), 1 coluna por juiz
largo <- reshape(
  qrels_bruto[, c("consulta", "documento", "grau", "juiz")],
  idvar = c("consulta", "documento"),
  timevar = "juiz",
  direction = "wide"
)
names(largo) <- gsub("^grau\\.", "", names(largo))
cat("Pares (consulta, documento) julgados por todos:", nrow(largo), "\n\n")

# kappa de Cohen (3 categorias: 0, 1, 2) — mesma fórmula do exercício de
# fixação do guia (Módulo 7): po = concordância observada, pe = concordância
# esperada ao acaso a partir das distribuições marginais de cada juiz.
kappa_cohen <- function(a, b) {
  niveis <- c(0, 1, 2)
  m <- table(factor(a, levels = niveis), factor(b, levels = niveis))
  n <- sum(m)
  po <- sum(diag(m)) / n
  marg_a <- rowSums(m); marg_b <- colSums(m)
  pe <- sum(marg_a * marg_b) / n^2
  kappa <- (po - pe) / (1 - pe)
  list(kappa = kappa, po = po, pe = pe, matriz = m)
}

juizes <- c("victor", "flavia", "felipe")
pares <- combn(juizes, 2, simplify = FALSE)

for (p in pares) {
  r <- kappa_cohen(largo[[p[1]]], largo[[p[2]]])
  cat(sprintf("%s x %s:  kappa = %.3f   (po = %.3f, pe = %.3f)\n",
              p[1], p[2], r$kappa, r$po, r$pe))
  print(r$matriz)
  cat("\n")
}

# Leitura (escala do guia, Módulo 7): <0.4 fraca | 0.4-0.6 moderada | >=0.6 boa.
# kappa por volta de 0.4-0.55 aqui: concordância moderada — típica de
# julgamento de relevância com 3 pessoas (o guia cita 70-80% de concordância
# bruta como normal; aqui po ficou em ~0.91-0.96, mas isso é inflado pela
# maioria esmagadora de grau 0 — o kappa corrige esse viés, por isso é
# sempre mais baixo que a concordância bruta. Discutir no relatório.
