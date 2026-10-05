# 13-montar-pool.R
# Entregável 4 — monta o pool.csv (top-k por modelo, deduplicado) a partir
# dos rankings já gerados em 11-rankings-consultas-reais.R.

rankings <- readRDS(file.path("estrutura", "banco-de-dados", "rankings.rds"))
gabarito <- read.csv(file.path("estrutura", "banco-de-dados", "qrels_consolidado.csv"),
                      stringsAsFactors = FALSE)

k <- 10
pool <- data.frame()
for (qid in unique(gabarito$consulta)) {
  docs_pool <- unique(unlist(lapply(rankings, function(r) head(r[[qid]], k))))
  pool <- rbind(pool, data.frame(consulta = qid, documento = docs_pool))
}

write.csv(pool, file.path("estrutura", "banco-de-dados", "pool.csv"), row.names = FALSE)
cat("pool.csv gravado:", nrow(pool), "linhas (top-", k, " de 3 modelos, deduplicado)\n")

## Quanto da pool teria coberto o gabarito real? --------------------------------
cat("\n=== O que a pool teria perdido, por consulta ===\n")
for (qid in unique(gabarito$consulta)) {
  docs_pool <- pool$documento[pool$consulta == qid]
  g <- gabarito[gabarito$consulta == qid, ]
  rel2 <- g$documento[g$grau >= 2]
  rel1 <- g$documento[g$grau >= 1]
  perdidos_2 <- setdiff(rel2, docs_pool)
  perdidos_1 <- setdiff(rel1, docs_pool)
  cat(sprintf("%s | pool=%d docs | perdidos grau>=2: %s | perdidos grau>=1 (adicional): %s\n",
              qid, length(docs_pool),
              if (length(perdidos_2)) paste(perdidos_2, collapse=",") else "nenhum",
              if (length(setdiff(perdidos_1, perdidos_2))) paste(setdiff(perdidos_1, perdidos_2), collapse=",") else "nenhum"))
}
# Achado: nenhum documento grau=2 (\"Responde\") teria ficado de fora da pool
# nas 5 consultas -- os 3 modelos, juntos, sempre acharam a resposta certa
# entre os top-10. O viés aparece só no grau 1 (contexto/parcial): q04 perde
# Cubatao_p19 e Cubatao_p12, q05 perde Guaruja_p17. Ou seja: pooling teria
# sido seguro para medir P/R/MAP com limiar grau>=2 (o usado neste projeto),
# mas teria subestimado o recall com limiar grau>=1.
