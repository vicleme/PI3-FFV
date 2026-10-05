# 06-modelo-espaco-vetorial-toy.R
# Aula: Modelo do Espaço Vetorial (2026-08-25) — Parte 1: tarefa oficial
# Reaproveita o corpus de 8 documentos, implementa TF-IDF + cosseno e reporta
# o ranking de 3 consultas.
# Ver consolidado-legado/04-modelo-do-espaco-vetorial.md para a interpretação.
#
# Nota: a Parte 2 deste notebook ("Continuando a pesquisa da Baixada
# Santista") repete o mesmo corpus real e a mesma função de busca por
# cosseno já organizados em 03-corpus-cidades-tfidf-busca.R e
# 04-similaridade-cosseno-cidades.R — não duplicada aqui.

## Bloco 1: reconstruindo o corpus e a matriz TF-IDF --------------------------
docs <- c(
  d1 = "recuperacao de informacao ordena documentos por relevancia",
  d2 = "o modelo de espaco vetorial representa documentos como vetores",
  d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",
  d4 = "aprendizado estatistico fundamenta a recuperacao moderna",
  d5 = "o indice invertido acelera a busca em muitos documentos",
  d6 = "embeddings capturam a semantica de palavras e documentos",
  d7 = "a avaliacao mede a relevancia dos resultados da busca",
  d8 = "ciencia de dados combina estatistica e programacao"
)

tok <- function(x) unlist(strsplit(tolower(x), "\\s+"))
tokens <- lapply(docs, tok)
vocab <- sort(unique(unlist(tokens)))

tdm <- sapply(tokens, function(t) as.integer(table(factor(t, levels = vocab))))
rownames(tdm) <- vocab
dim(tdm)

N <- ncol(tdm)
df <- rowSums(tdm > 0)
idf <- log(N / df)
w <- tdm * idf
round(w[c("documentos", "modelo", "de"), ], 2)

## Bloco 2: função de similaridade do cosseno e busca --------------------------
cosseno <- function(a, b) sum(a * b) / (sqrt(sum(a^2)) * sqrt(sum(b^2)))

buscar <- function(consulta_txt, w, vocab, idf, top_n = 8) {
  q  <- as.integer(table(factor(tok(consulta_txt), levels = vocab)))
  qw <- q * idf
  scores <- apply(w, 2, function(dvec) cosseno(qw, dvec))
  sort(scores, decreasing = TRUE)[1:top_n]
}

## Bloco 3: três consultas e seus rankings -------------------------------------
cat("=== Consulta 1: modelo de recuperacao ===\n")
print(round(buscar("modelo de recuperacao", w, vocab, idf, top_n = 3), 3))

cat("\n=== Consulta 2: busca e avaliacao de relevancia ===\n")
print(round(buscar("busca e avaliacao de relevancia", w, vocab, idf, top_n = 3), 3))

cat("\n=== Consulta 3: ciencia de dados e aprendizado estatistico ===\n")
print(round(buscar("ciencia de dados e aprendizado estatistico", w, vocab, idf, top_n = 3), 3))
