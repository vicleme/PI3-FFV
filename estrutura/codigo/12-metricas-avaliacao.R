# 12-metricas-avaliacao.R
# Aula 5,5 — Entregável 6: implementa P@k, R@k, AP/MAP, MRR e nDCG, valida
# contra o exemplo do Módulo 6 do guia (ranking d3 d1 d2 d4 d8 d6 d5 d7) e
# aplica aos rankings reais (11-rankings-consultas-reais.R) contra o
# gabarito consolidado (10-consolidar-qrels.R).
#
# Decisão documentada (Checkpoint 5 do guia): "relevante" para as métricas
# binárias (P, R, AP, MRR) usa o limiar grau >= 2 -- o mesmo do exemplo
# oficial do Módulo 6 (dá P@3=0.667, AP=0.833, MRR=1.000 nesse exemplo).
# O nDCG usa o grau (0/1/2) como ganho direto, sem binarizar.

precision_at_k <- function(ranking, relevantes, k) {
  topo <- head(ranking, k)
  mean(topo %in% relevantes)
}

recall_at_k <- function(ranking, relevantes, k) {
  if (length(relevantes) == 0) return(NA)
  topo <- head(ranking, k)
  sum(topo %in% relevantes) / length(relevantes)
}

average_precision <- function(ranking, relevantes) {
  if (length(relevantes) == 0) return(NA)
  acertos <- ranking %in% relevantes
  precisoes <- cumsum(acertos) / seq_along(acertos)
  if (sum(acertos) == 0) return(0)
  sum(precisoes[acertos]) / length(relevantes)
}

reciprocal_rank <- function(ranking, relevantes) {
  pos <- which(ranking %in% relevantes)
  if (length(pos) == 0) return(0)
  1 / min(pos)
}

dcg <- function(ganhos) sum(ganhos / log2(seq_along(ganhos) + 1))

# nDCG graduado: ganho = grau real (0/1/2). nDCG binário: ganho = 1 se
# relevante (grau >= limiar), senão 0 -- as duas formas pedidas no
# Entregável 6.
ndcg <- function(ranking, graus, k = NULL, limiar = NULL) {
  if (!is.null(k)) ranking <- head(ranking, k)
  ganhos_ref <- graus
  # setNames(): as.numeric() sozinho derruba os nomes de graus (doc_id), e
  # ganhos_ref[ranking] logo abaixo indexa por nome -- sem os nomes, vira
  # NA pra tudo (bug encontrado ao rodar: nDCG bin. dava NA no lugar de
  # 0.920 na validação do Módulo 6).
  if (!is.null(limiar)) ganhos_ref <- setNames(as.numeric(graus >= limiar), names(graus))
  ganhos <- ifelse(ranking %in% names(graus), ganhos_ref[ranking], 0)
  ideal <- sort(ganhos_ref, decreasing = TRUE)
  if (!is.null(k)) ideal <- head(ideal, k)
  idcg <- dcg(ideal)
  if (idcg == 0) return(0)
  dcg(ganhos) / idcg
}

## --- validação com o exemplo do Módulo 6 (guia da disciplina) --------------
ranking_m6 <- c("d3", "d1", "d2", "d4", "d8", "d6", "d5", "d7")
graus_m6 <- c(d2 = 2, d3 = 2, d1 = 1, d6 = 1, d4 = 0, d5 = 0, d7 = 0, d8 = 0)
rel_m6 <- names(graus_m6)[graus_m6 >= 2]

cat("=== Validação (Módulo 6, limiar grau>=2) ===\n")
cat("P@3        :", round(precision_at_k(ranking_m6, rel_m6, 3), 3), " (esperado 0.667)\n")
cat("AP         :", round(average_precision(ranking_m6, rel_m6), 3), " (esperado 0.833)\n")
cat("MRR        :", round(reciprocal_rank(ranking_m6, rel_m6), 3), " (esperado 1.000)\n")
cat("nDCG bin.  :", round(ndcg(ranking_m6, graus_m6, limiar = 2), 3), " (esperado 0.920)\n")
cat("nDCG grad. :", round(ndcg(ranking_m6, graus_m6), 3), " (esperado 0.951)\n\n")

## --- avaliação real -----------------------------------------------------------
rankings <- readRDS(file.path("estrutura", "banco-de-dados", "rankings.rds"))
gabarito <- read.csv(file.path("estrutura", "banco-de-dados", "qrels_consolidado.csv"),
                      stringsAsFactors = FALSE)
split <- read.csv(file.path("estrutura", "banco-de-dados", "split_teste_desenvolvimento.csv"),
                   stringsAsFactors = FALSE)

ks <- c(1, 3, 5, 10)
resultado <- data.frame()
for (modelo in names(rankings)) {
  for (qid in names(rankings[[modelo]])) {
    ranking <- rankings[[modelo]][[qid]]
    linha_g <- gabarito[gabarito$consulta == qid, ]
    graus <- setNames(linha_g$grau, linha_g$documento)
    relevantes <- names(graus)[graus >= 2]

    linha <- data.frame(modelo = modelo, consulta = qid)
    for (k in ks) {
      linha[[paste0("P", k)]] <- precision_at_k(ranking, relevantes, k)
      linha[[paste0("R", k)]] <- recall_at_k(ranking, relevantes, k)
    }
    linha$AP <- average_precision(ranking, relevantes)
    linha$RR <- reciprocal_rank(ranking, relevantes)
    linha$nDCG10_bin  <- ndcg(ranking, graus, k = 10, limiar = 2)
    linha$nDCG10_grad <- ndcg(ranking, graus, k = 10)
    resultado <- rbind(resultado, linha)
  }
}

## --- BLINDAGEM teste/desenvolvimento -----------------------------------------
# As métricas em si (não só o ranking) são o que fica fechado até o relatório
# final (ver consolidado-legado/07-separacao-teste-desenvolvimento.md): rodar o
# modelo sobre as consultas de teste tudo bem, mas comparar o resultado
# contra o gabarito é a avaliação que não pode informar ajuste de k1/b nem
# escolha de modelo. Por isso a separação acontece ANTES de qualquer print
# ou write.csv — nada de teste passa pelo console nem pelo
# metricas_por_consulta.csv "normal".
resultado <- merge(resultado, split[, c("consulta", "conjunto")], by = "consulta")
dev   <- resultado[resultado$conjunto == "desenvolvimento", setdiff(names(resultado), "conjunto")]
teste <- resultado[resultado$conjunto == "teste",          setdiff(names(resultado), "conjunto")]

cat("=== Resultado por consulta (SOMENTE DESENVOLVIMENTO — teste está lacrado) ===\n")
print(dev, row.names = FALSE)

cat("\n=== Médias por modelo — desenvolvimento (MAP, MRR médio, nDCG@10 médio bin./grad.) ===\n")
medias_dev <- aggregate(cbind(AP, RR, nDCG10_bin, nDCG10_grad) ~ modelo, data = dev, FUN = mean)
names(medias_dev) <- c("modelo", "MAP", "MRR", "nDCG10_bin_medio", "nDCG10_grad_medio")
print(medias_dev, row.names = FALSE)

write.csv(dev, file.path("estrutura", "banco-de-dados", "metricas_por_consulta.csv"), row.names = FALSE)
write.csv(medias_dev, file.path("estrutura", "banco-de-dados", "metricas_medias.csv"), row.names = FALSE)

# Teste: calculado (porque vai precisar dele no relatório final), mas NUNCA
# impresso no console nem misturado nos arquivos acima. Vai para um arquivo
# à parte, com nome que avisa — só abrir na hora de escrever o relatório.
write.csv(teste, file.path("estrutura", "banco-de-dados", "metricas_teste_LACRADO_nao_abrir.csv"),
          row.names = FALSE)
cat("\n[", nrow(teste), "linhas de teste gravadas em metricas_teste_LACRADO_nao_abrir.csv",
    "— não abrir até o relatório final ]\n")
