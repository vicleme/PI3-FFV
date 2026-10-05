# 10-consolidar-qrels.R
# Aula 5,5 — consolida os 3 julgamentos (victor, flavia, felipe) em um único
# gabarito, por voto majoritário. Regra de desempate (quando os 3 juízes
# discordam totalmente, ex. 0/1/2): usa a mediana. Isso só acontece 2 vezes
# em 630 pares no nosso caso (ver console ao rodar).
#
# Entrada:  estrutura/banco-de-dados/qrels_equipe.csv (sem dedup: nenhum
#           julgamento repetido pro mesmo juiz+consulta+documento nesta rodada)
# Saída:    estrutura/banco-de-dados/qrels_consolidado.csv (consulta,documento,grau)

# fileEncoding = "UTF-8-BOM": mesmo BOM do 09-concordancia-kappa.R.
qrels_bruto <- read.csv(
  file.path("estrutura", "banco-de-dados", "qrels_equipe.csv"),
  stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM"
)

consolidar_grupo <- function(graus) {
  tab <- table(graus)
  maximo <- max(tab)
  vencedores <- as.numeric(names(tab)[tab == maximo])
  if (length(vencedores) == 1) return(vencedores)          # maioria clara (2x1 ou 3x0)
  return(as.numeric(median(graus)))                          # empate triplo -> mediana
}

gabarito <- aggregate(
  grau ~ consulta + documento,
  data = qrels_bruto,
  FUN = consolidar_grupo
)

cat("Distribuição do gabarito consolidado:\n")
print(table(gabarito$grau))

n_empates <- sum(sapply(split(qrels_bruto$grau, paste(qrels_bruto$consulta, qrels_bruto$documento)),
                         function(g) length(unique(g)) == 3))
cat("\nPares com os 3 juízes totalmente divergentes (desempate por mediana):", n_empates, "\n")

write.csv(gabarito, file.path("estrutura", "banco-de-dados", "qrels_consolidado.csv"),
          row.names = FALSE)
cat("\nGravado estrutura/banco-de-dados/qrels_consolidado.csv (", nrow(gabarito), "linhas)\n")
