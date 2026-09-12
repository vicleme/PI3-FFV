# 03b-corpus-cidades-paragrafos.R
#
# Versão em granularidade de parágrafo do corpus das cidades, pedida pelo
# professor: em vez de 1 documento = 1 cidade inteira, cada parágrafo do
# verbete vira um documento (Santos_p1, Santos_p2, ...), na mesma lógica
# "curta" do corpus de brinquedo (d1...d8).
#
# Mantemos as duas visões (ver utils-corpus.R):
#   - corpus$texto -> usado em 03-corpus-cidades-tfidf-busca.R (1 doc/cidade)
#   - corpus$docs  -> usado aqui (1 doc/parágrafo)
#
# Depois de rodar a TDM/TF-IDF no nível de parágrafo, agregamos os escores
# de volta por cidade (soma dos parágrafos) para comparar com a visão
# agregada do script anterior.

source("utils-corpus.R")
corpus <- carregar_corpus()
cidades_docs_par <- corpus$docs

length(cidades_docs_par)
table(sub("_p\\d+$", "", names(cidades_docs_par))) # quantos parágrafos por cidade

## Tokenização (reaproveita a mesma função de limpeza do script anterior) -----
tokenizar_limpo <- function(texto) {
  texto <- tolower(texto)
  texto <- iconv(texto, to = "ASCII//TRANSLIT")
  texto <- gsub("[^a-z\\s]", " ", texto)
  tk <- unlist(strsplit(texto, "\\s+"))
  tk <- tk[nchar(tk) > 1]
  return(tk)
}

tokens_par <- lapply(cidades_docs_par, tokenizar_limpo)
vocab_par <- sort(unique(unlist(tokens_par)))

tdm_par <- sapply(tokens_par, function(tk) {
  as.integer(table(factor(tk, levels = vocab_par)))
})
rownames(tdm_par) <- vocab_par

N_par <- ncol(tdm_par)
df_par <- rowSums(tdm_par > 0)
idf_par <- log(N_par / df_par)
tfidf_par <- tdm_par * idf_par

## Top termos por parágrafo (granularidade fina) -------------------------------
top_termos_paragrafo <- function(paragrafo, top_n = 8) {
  pesos <- tfidf_par[, paragrafo]
  head(sort(pesos, decreasing = TRUE), top_n)
}
round(top_termos_paragrafo("Santos_p1"), 2)

## Agregação de volta por cidade (soma dos escores dos parágrafos) ------------
agregar_por_cidade <- function(tfidf_matriz) {
  cidade_de <- sub("_p\\d+$", "", colnames(tfidf_matriz))
  scores_cidade <- sapply(unique(cidade_de), function(c) {
    rowSums(tfidf_matriz[, cidade_de == c, drop = FALSE])
  })
  colnames(scores_cidade) <- unique(cidade_de)
  scores_cidade
}

tfidf_agregado <- agregar_por_cidade(tfidf_par)
top_termos_agregado <- function(cidade, top_n = 8) {
  head(sort(tfidf_agregado[, cidade], decreasing = TRUE), top_n)
}
round(top_termos_agregado("Santos"), 2)
round(top_termos_agregado("Cubatao"), 2)
round(top_termos_agregado("Guaruja"), 2)
