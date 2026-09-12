# 03-corpus-cidades-tfidf-busca.R
# Aula: Recuperação de Informação (2026-08-14) — Parte 2: corpus real
# (Santos, Cubatão e Guarujá). TDM, TF-IDF e busca booleana no nível de cidade.
#
# Atualização: o corpus agora é lido de estrutura/corpus/*.txt (gerado por
# 00-preparar-corpus.R) em vez de baixado da API a cada execução — ver
# utils-corpus.R. cidades_docs aqui usa a visão "1 documento por cidade"
# (corpus$texto); para a granularidade de parágrafo (corpus$docs), ver
# 03b-corpus-cidades-paragrafos.R.
#
# Ver Consolidado/02-recuperacao-de-informacao.md para a interpretação.

source("utils-corpus.R")
corpus <- carregar_corpus()
cidades_docs <- corpus$texto
sapply(cidades_docs, nchar)

## Bloco 2: limpeza, tokenização e remoção de stopwords -----------------------
stopwords_pt <- c(
  "a", "ao", "aos", "aquela", "aquelas", "aquele", "aqueles", "aquilo", "as", "ate", "com", "como", "da", "das",
  "de", "dela", "delas", "dele", "deles", "depois", "do", "dos", "e", "ela", "elas", "ele", "eles", "em",
  "entre", "era", "eram", "eramos", "essa", "essas", "esse", "esses", "esta", "estamos", "estao", "estar", "estas",
  "estava", "estavam", "estavamos", "este", "esteja", "estejam", "estejamos", "estes", "esteve", "estive", "estivemos",
  "estiver", "estiveram", "estiveremos", "estiverem", "estivermos", "estivesse", "estivessem", "estivessemos", "estou",
  "eu", "foi", "fomos", "for", "fora", "foram", "forem", "formos", "fosse", "fossem", "fossemos", "ha", "haja",
  "hajam", "hajamos", "havemos", "haver", "haveria", "haveriam", "haveriamos", "haveremos", "haverao", "hei", "houve",
  "houver", "houvera", "houveram", "houverei", "houverem", "houveremos", "houveria", "houveriam", "houveriamos",
  "houvermos", "houvesse", "houvessem", "houvessemos", "isso", "isto", "ja", "lhe", "lhes", "mais", "mas",
  "me", "mesmo", "meu", "meus", "minha", "minhas", "muito", "na", "nao", "nas", "nem", "no", "nos", "nossa",
  "nossas", "nosso", "nossos", "num", "numa", "o", "os", "ou", "para", "pela", "pelas", "pelo", "pelos", "por",
  "qual", "quando", "que", "quem", "se", "seja", "sejam", "sejamos", "sem", "sendo", "ser", "sera", "serao",
  "serei", "seremos", "seria", "seriam", "seriamos", "seu", "seus", "so", "somos", "sou", "sua", "suas", "tambem",
  "te", "tem", "temos", "tenho", "tenha", "tenham", "tenhamos", "ter", "tera", "terao", "terei", "teremos",
  "teria", "teriam", "teriamos", "teve", "tinha", "tinham", "tinhamos", "tive", "tiver", "tiveram", "tiveremos",
  "tiverem", "tivermos", "tivesse", "tivessem", "tivessemos", "tu", "tua", "tuas", "um", "uma", "voce", "voces",
  "vos", "sao", "sobre", "segundo", "onde", "partir", "alem", "possui", "apos"
)

tokenizar_limpo <- function(texto) {
  texto <- tolower(texto)
  texto <- iconv(texto, to = "ASCII//TRANSLIT")
  texto <- gsub("[^a-z\\s]", " ", texto)
  tk <- unlist(strsplit(texto, "\\s+"))
  tk <- tk[nchar(tk) > 1]
  tk <- tk[!tk %in% stopwords_pt]
  return(tk)
}

tokens_cidades <- lapply(cidades_docs, tokenizar_limpo)
sapply(tokens_cidades, length)

## Bloco 3: matriz termo-documento (TDM) ---------------------------------------
vocab_cidades <- sort(unique(unlist(tokens_cidades)))
cat("Tamanho do vocabulário único:", length(vocab_cidades), "\n")

tdm_cidades <- sapply(tokens_cidades, function(tk) {
  as.integer(table(factor(tk, levels = vocab_cidades)))
})
rownames(tdm_cidades) <- vocab_cidades

termos_amostra <- c("porto", "industria", "praia", "turismo", "petroleo", "ferrovia")
termos_validos <- termos_amostra[termos_amostra %in% rownames(tdm_cidades)]
tdm_cidades[termos_validos, ]

## Bloco 4: matriz TF-IDF --------------------------------------------------------
N_cid <- ncol(tdm_cidades)
df_cid <- rowSums(tdm_cidades > 0)
idf_cid <- log(N_cid / df_cid)
tfidf_cidades <- tdm_cidades * idf_cid
round(tfidf_cidades[termos_validos, ], 2)

## Bloco 5: termos mais relevantes de cada cidade --------------------------------
top_termos_cidade <- function(cidade, top_n = 10) {
  pesos <- tfidf_cidades[, cidade]
  head(sort(pesos, decreasing = TRUE), top_n)
}

cat("--- TOP TERMOS: SANTOS ---\n")
print(round(top_termos_cidade("Santos", 8), 2))
cat("\n--- TOP TERMOS: CUBATÃO ---\n")
print(round(top_termos_cidade("Cubatao", 8), 2))
cat("\n--- TOP TERMOS: GUARUJÁ ---\n")
print(round(top_termos_cidade("Guaruja", 8), 2))

## Bloco 6: consultas e busca booleana ---------------------------------------------
busca_cidades <- function(termo, tdm) {
  termo <- tolower(termo)
  termo <- iconv(termo, to = "ASCII//TRANSLIT")
  if (!termo %in% rownames(tdm)) return("Termo não encontrado no vocabulário")
  docs_encontrados <- colnames(tdm)[tdm[termo, ] > 0]
  return(docs_encontrados)
}

cat("Busca por 'porto':", busca_cidades("porto", tdm_cidades), "\n")
cat("Busca por 'industria':", busca_cidades("industria", tdm_cidades), "\n")
cat("Busca por 'ecoturismo':", busca_cidades("ecoturismo", tdm_cidades), "\n")
