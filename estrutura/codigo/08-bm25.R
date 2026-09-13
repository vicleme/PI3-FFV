# 08-bm25.R
# Aula: Modelo Probabilístico BM25 (Aula 04, 2026-09-12)
# BM25 (saturação de frequência k1 + normalização de tamanho b), aplicado ao
# corpus real de parágrafos das três cidades, e comparado com o TF-IDF +
# cosseno já usado em 03-corpus-cidades-tfidf-busca.R / 04-similaridade-cosseno-cidades.R.
#
# Depende de objetos/funções criados em 03-corpus-cidades-tfidf-busca.R:
# stopwords_pt, tokenizar_limpo, cosseno (de 04-similaridade-cosseno-cidades.R).
# Usa a MESMA tokenização (limpeza + stopwords, sem stemming) nos dois
# métodos, pra que a comparação de ranking não misture pré-processamentos
# diferentes.
#
# Ver Consolidado/06-modelo-probabilistico-bm25.md para a interpretação.

source("utils-corpus.R")
corpus <- carregar_corpus()
docs <- corpus$docs
length(docs)

## Bloco 1: matriz termo-documento (tf), tamanho e média dos documentos -------
tokens_par <- lapply(docs, tokenizar_limpo) # reaproveitado de 03-corpus-cidades-tfidf-busca.R
vocab_par <- sort(unique(unlist(tokens_par)))

tf <- sapply(tokens_par, function(tk) {
  as.integer(table(factor(tk, levels = vocab_par)))
})
rownames(tf) <- vocab_par

dl <- sapply(tokens_par, length) # |d|: quantas palavras (apos limpeza) tem cada paragrafo
avgdl <- mean(dl) # avgdl: tamanho medio dos paragrafos no corpus
range(dl)
round(avgdl, 2)

## Bloco 2: IDF probabilístico do BM25 -------------------------------------------
N <- ncol(tf)
df <- rowSums(tf > 0)
idf_bm25 <- log((N - df + 0.5) / (df + 0.5) + 1)
round(idf_bm25[c("porto", "praia", "santos", "cidade")], 3)

## Bloco 3: implementação do BM25 -------------------------------------------------
k1_padrao <- 1.2; b_padrao <- 0.75 # parametros padrao (Robertson)

bm25_doc <- function(termos, d, k1, b) {
  s <- 0
  for (t in termos) {
    if (!(t %in% vocab_par)) next # termo fora do vocabulario: contribui 0
    f <- tf[t, d]
    if (f == 0) next
    K <- k1 * (1 - b + b * dl[d] / avgdl) # penalidade de tamanho do documento
    s <- s + idf_bm25[t] * (f * (k1 + 1)) / (f + K)
  }
  s
}

bm25_busca <- function(consulta, k1 = k1_padrao, b = b_padrao) {
  termos <- tokenizar_limpo(consulta) # mesma limpeza usada na indexacao
  scores <- sapply(colnames(tf), function(d) bm25_doc(termos, d, k1, b))
  sort(scores, decreasing = TRUE)
}

## Bloco 4: ranqueando 3 consultas -------------------------------------------------
consultas <- c("porto industria", "praia turismo", "poluicao industrial saude")

for (q in consultas) {
  cat("\n=== BM25 | Consulta:", q, "===\n")
  print(round(head(bm25_busca(q), 5), 3))
}

## Bloco 5: comparando com TF-IDF + cosseno (mesmo vocabulario e tokenizacao) ----
idf_tfidf <- log(N / df)
tfidf_par <- tf * idf_tfidf

buscar_tfidf <- function(consulta) {
  termos_q <- tokenizar_limpo(consulta)
  q <- as.integer(table(factor(termos_q, levels = vocab_par)))
  qw <- q * idf_tfidf
  scores <- apply(tfidf_par, 2, function(v) cosseno(qw, v)) # cosseno() de 04-similaridade-cosseno-cidades.R
  sort(scores, decreasing = TRUE)
}

for (q in consultas) {
  cat("\n=== TF-IDF+cosseno | Consulta:", q, "===\n")
  print(round(head(buscar_tfidf(q), 5), 4))
}

## Bloco 6: variando k1 e b -----------------------------------------------------
cat("\n=== Efeito de k1 (consulta: 'porto industria') ===\n")
for (k1_teste in c(0, 1.2, 3.0)) {
  cat("k1 =", k1_teste, ":\n")
  print(round(head(bm25_busca("porto industria", k1 = k1_teste), 4), 3))
}

cat("\n=== Efeito de b (consulta: 'porto industria') ===\n")
for (b_teste in c(0, 0.75, 1.0)) {
  cat("b =", b_teste, ":\n")
  print(round(head(bm25_busca("porto industria", b = b_teste), 4), 3))
}
