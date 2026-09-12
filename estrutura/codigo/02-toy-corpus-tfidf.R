# 02-toy-corpus-tfidf.R
# Aula: Recuperação de Informação (2026-08-14) — Parte 1: corpus de brinquedo
# Vetorização, tokenização, vocabulário, TDM, busca booleana, TF-IDF.
# Ver Consolidado/02-recuperacao-de-informacao.md para a interpretação.

## Bloco 1: criação do vetor de documentos ----------------------------------
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
length(docs)
docs["d5"]

docs <- c(docs, d9 = "inteligencia artificial em ciencia de dados")
length(docs)
docs["d9"]

## Bloco 2: tokenização -------------------------------------------------------
tokenizar <- function(texto) {
  texto <- tolower(texto)
  unlist(strsplit(texto, "\\s+"))
}
tokens <- lapply(docs, tokenizar)
tokens[["d1"]]

tokenizar_letras <- function(texto) {
  texto <- tolower(texto)
  unlist(strsplit(texto, ""))
}
tokens_letras <- lapply(docs, tokenizar_letras)
tokens_letras[["d1"]]

## Bloco 3: vocabulário e frequência de termos --------------------------------
vocab <- sort(unique(unlist(tokens)))
length(vocab)

freq <- table(unlist(tokens))
sort(freq, decreasing = TRUE)[1:6]
sort(freq, decreasing = FALSE)[1:6]

## Bloco 4: matriz termo-documento (TDM) --------------------------------------
tdm <- sapply(tokens, function(tk) {
  as.integer(table(factor(tk, levels = vocab)))
})
rownames(tdm) <- vocab
tdm[1:6, ]
tdm[(nrow(tdm) - 4):nrow(tdm), ]

## Bloco 5: busca booleana simples --------------------------------------------
busca_booleana <- function(termo, tdm) {
  termo <- tolower(termo)
  if (!termo %in% rownames(tdm)) return(character(0))
  colnames(tdm)[tdm[termo, ] > 0]
}
busca_booleana("documentos", tdm)
busca_booleana("busca", tdm)
print(busca_booleana("python", tdm))
print(busca_booleana("CIENCIA", tdm))

## Bloco 6: TF-IDF --------------------------------------------------------------
N <- ncol(tdm)
df <- rowSums(tdm > 0)
idf <- log(N / df)
tfidf <- tdm * idf
round(tfidf[c("documentos", "recuperacao", "busca", "de"), ], 2)

idf_log10 <- log10(N / df)
tfidf_log10 <- tdm * idf_log10
round(tfidf_log10[c("documentos", "recuperacao", "busca", "de"), ], 2)

## Bloco 7: exemplo de consulta a um verbete da Wikipédia (só para ilustrar a API) -
# Ver 00-preparar-corpus.R para a versão usada de fato no projeto (persistida em .txt).
library(httr2)
baixar_wiki <- function(titulo) {
  request("https://pt.wikipedia.org/w/api.php") |>
    req_url_query(action = "query", prop = "extracts", explaintext = 1,
                  format = "json", redirects = 1, titles = titulo) |>
    req_perform() |> resp_body_json() |>
    (\(r) r$query$pages[[1]]$extract)()
}
texto <- baixar_wiki("Santos (São Paulo)")
substr(texto, 1, 60)

## Bloco 8: regex vs. índice de termos -----------------------------------------
grep("recupera", docs)
busca_booleana("recupera", tdm)
grep("estatist", docs)
busca_booleana("estatist", tdm)
