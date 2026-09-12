# 05-teoria-informacao-idf.R
# Aula: Teoria da Informação e o TF-IDF (2026-08-25)
# Corpus de brinquedo (mesmo de 02-toy-corpus-tfidf.R) + um corpus artificial
# de "rotas" entre as 4 cidades da Baixada Santista (Santos, Cubatão,
# Guarujá, Bertioga) usado só como exemplo didático de permutação — não é o
# corpus real de estrutura/corpus/.
# Ver Consolidado/03-teoria-da-informacao-tfidf.md para a interpretação.

## Bloco 1: o corpus e o bit --------------------------------------------------
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
N <- length(docs)
log2(N)

docs16 <- c(docs, setNames(docs, paste0(names(docs), "b")))
log2(length(docs16))
log2(length(docs))

## Bloco 2: quanto vale uma pista ---------------------------------------------
tok <- function(x) unlist(strsplit(x, " "))
contem <- function(t) names(docs)[sapply(docs, function(d) t %in% tok(d))]
contem("busca")
log2(8 / 2)

contem("relevancia")
log2(8 / length(contem("relevancia")))

## Bloco 3: a fórmula da informação em bits -----------------------------------
I <- function(p) -log2(p)
I(c(1, 1 / 2, 1 / 4, 1 / 8))
round(I(c(1 / 3, 0.01)), 2)

## Bloco 4: a ponte entre o IDF e a autoinformação ----------------------------
df <- c(modelo = 2, de = 5, recuperacao = 2)
round(log2(8 / df), 3)

df2 <- c(modelo = 2, de = 5, recuperacao = 2, bm25 = 1, todos = 8)
round(log2(8 / df2), 3)

## Bloco 5: quando a aditividade fecha certinho -------------------------------
intersect(contem("busca"), contem("documentos"))
log2(8 / 2) + log2(8 / 4)

intersect(contem("documentos"), contem("recuperacao"))
log2(8 / 4) + log2(8 / 2)

## Bloco 6: quando a conta não fecha ------------------------------------------
intersect(contem("recuperacao"), contem("relevancia"))
log2(8 / 2) + log2(8 / 2)

contem("avaliacao"); contem("relevancia")
intersect(contem("avaliacao"), contem("relevancia"))
log2(8 / length(contem("avaliacao"))) + log2(8 / length(contem("relevancia")))

## Bloco 7: exemplo completo de consulta em bits ------------------------------
idf_bits <- c(modelo = 2.00, de = 0.678, recuperacao = 2.00)
tokens <- lapply(docs, function(x) unlist(strsplit(tolower(x), " ")))
consulta <- c("modelo", "de", "recuperacao")

bits_doc <- sapply(tokens, function(tk)
  sum(sapply(consulta, function(t) sum(tk == t) * idf_bits[[t]]))
)
round(sort(bits_doc, decreasing = TRUE), 2)

idf_full <- function(t) log2(8 / length(contem(t)))
consulta2 <- c("busca", "relevancia")
idf_c2 <- sapply(consulta2, idf_full)

bits_doc2 <- sapply(tokens, function(tk)
  sum(sapply(consulta2, function(t) sum(tk == t) * idf_c2[[t]]))
)
round(sort(bits_doc2, decreasing = TRUE), 2)

## Bloco 8: o caso extremo das rotas (corpus artificial de permutações) -------
rotas <- c(
  r1 = "santos cubatao guaruja bertioga",
  r2 = "santos guaruja cubatao bertioga",
  r3 = "santos bertioga guaruja cubatao",
  r4 = "cubatao santos bertioga guaruja",
  r5 = "guaruja bertioga santos cubatao",
  r6 = "bertioga cubatao santos guaruja",
  r7 = "guaruja santos cubatao bertioga",
  r8 = "bertioga guaruja cubatao santos"
)
tokens_r <- lapply(rotas, function(x) unlist(strsplit(x, " ")))
vocab_r <- sort(unique(unlist(tokens_r)))
tdm_r <- sapply(tokens_r, function(t) as.integer(table(factor(t, levels = vocab_r))))
rownames(tdm_r) <- vocab_r
tdm_r

rotas9 <- c(rotas, r9 = "santos santos cubatao bertioga")
tokens_r9 <- lapply(rotas9, function(x) unlist(strsplit(x, " ")))
vocab_r9 <- sort(unique(unlist(tokens_r9)))
tdm_r9 <- sapply(tokens_r9, function(t) as.integer(table(factor(t, levels = vocab_r9))))
rownames(tdm_r9) <- vocab_r9
df_r9 <- rowSums(tdm_r9 > 0)
round(log(9 / df_r9), 3)

## Bloco 9: zero bits de informação deixam o motor cego -----------------------
df_r <- rowSums(tdm_r > 0)
idf_r <- log(8 / df_r)
df_r
idf_r

cosseno <- function(a, b) sum(a * b) / (sqrt(sum(a^2)) * sqrt(sum(b^2)))
cosseno(tdm_r[, "r1"], tdm_r[, "r8"])
cosseno(tdm_r9[, "r1"], tdm_r9[, "r9"])
cosseno(tdm_r9[, "r1"], tdm_r9[, "r2"])

## Parte 2: perguntas para investigar -----------------------------------------
log2(1024)
log2(2048)

contem("avaliacao"); contem("relevancia")
intersect(contem("avaliacao"), contem("relevancia"))
log2(8 / length(contem("avaliacao"))) + log2(8 / length(contem("relevancia")))

df3 <- c(modelo = 2, de = 5, recuperacao = 2)
idf_log2 <- log2(8 / df3)
idf_ln   <- log(8 / df3)
round(idf_log2, 3)
round(idf_ln, 3)
order(idf_log2, decreasing = TRUE)
order(idf_ln, decreasing = TRUE)

log2(8 / 8)
