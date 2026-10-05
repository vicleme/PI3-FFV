# 11-rankings-consultas-reais.R
# Aula 5,5 — Entregável 6: gera o ranking de cada modelo (Booleano, TF-IDF,
# BM25) para as 10 consultas reais (necessidades.csv), sobre o corpus de
# parágrafos (mesma unidade usada no gabarito: Santos_p1, Cubatao_p3, ...).
#
# Reaproveita tokenizar_limpo() de 03-corpus-cidades-tfidf-busca.R e a
# lógica de BM25 de 08-bm25.R, agora aplicadas ao corpus$docs (parágrafo)
# em vez de cidades_docs (cidade inteira) — granularidade do gabarito.
#
# Importante: os 3 modelos usam a MESMA tokenização (tokenizar_limpo, sem
# stemming), pra que a diferença de ranking venha do MODELO, não do
# pré-processamento (ver nota em 08-bm25.R). O "Booleano" aqui é OR
# ranqueado por nível de coordenação (nº de termos da consulta presentes no
# documento) — o Booleano clássico (AND/OR de 07) devolve um conjunto, não
# um ranking, e não dá pra calcular P@k/MAP sobre um conjunto sem ordem.

# Nota: este script (como 09/10/12) assume pasta de trabalho na raiz do
# repo, igual carregar_corpus() abaixo espera. Por isso NÃO dá source() no
# 03-corpus-cidades-tfidf-busca.R inteiro: ele mistura a definição de
# tokenizar_limpo()/stopwords_pt com um carregar_corpus() já executado no
# topo do próprio arquivo, que só resolve rodando de dentro de
# estrutura/codigo/ -- incompatível com a convenção de pasta-raiz daqui.
# tokenizar_limpo()/stopwords_pt abaixo são o mesmo corpo de função de
# 03-corpus-cidades-tfidf-busca.R (linhas 19-47), copiado em vez de
# reaproveitado por source(), pra manter a MESMA tokenização sem herdar essa
# inconsistência de diretório.
source(file.path("estrutura", "codigo", "utils-corpus.R"), chdir = TRUE)

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

corpus <- carregar_corpus()
docs <- corpus$docs                         # 1 doc por parágrafo (63 no total)
doc_ids <- names(docs)
tokens_docs <- lapply(docs, tokenizar_limpo)

vocab <- sort(unique(unlist(tokens_docs)))
N <- length(doc_ids)
tdm <- sapply(tokens_docs, function(tk) as.integer(table(factor(tk, levels = vocab))))
rownames(tdm) <- vocab
dl <- sapply(tokens_docs, length)
avgdl <- mean(dl)
df_ <- rowSums(tdm > 0)

idf_tfidf <- log(N / df_)
tfidf <- tdm * idf_tfidf

idf_bm25 <- log((N - df_ + 0.5) / (df_ + 0.5) + 1)

## Modelo 1: Booleano por coordenação -----------------------------------------
ranking_booleano <- function(consulta_txt) {
  termos <- unique(tokenizar_limpo(consulta_txt))
  termos <- termos[termos %in% vocab]
  if (length(termos) == 0) return(setNames(rep(0, N), doc_ids))
  if (length(termos) == 1) scores <- tdm[termos, ] > 0
  else scores <- colSums(tdm[termos, , drop = FALSE] > 0)
  sort(scores, decreasing = TRUE)
}

## Modelo 2: TF-IDF + cosseno --------------------------------------------------
cosseno <- function(a, b) {
  denom <- sqrt(sum(a^2)) * sqrt(sum(b^2))
  if (denom == 0) return(0)
  sum(a * b) / denom
}

ranking_tfidf <- function(consulta_txt) {
  termos_q <- tokenizar_limpo(consulta_txt)
  q <- as.integer(table(factor(termos_q, levels = vocab)))
  qw <- q * idf_tfidf
  scores <- apply(tfidf, 2, function(v) cosseno(qw, v))
  sort(scores, decreasing = TRUE)
}

## Modelo 3: BM25 (Okapi, k1=1.2, b=0.75) --------------------------------------
ranking_bm25 <- function(consulta_txt, k1 = 1.2, b = 0.75) {
  termos_q <- unique(tokenizar_limpo(consulta_txt))
  termos_q <- termos_q[termos_q %in% vocab]
  scores <- setNames(rep(0, N), doc_ids)
  for (t in termos_q) {
    f <- tdm[t, ]
    K <- k1 * (1 - b + b * dl / avgdl)
    scores <- scores + idf_bm25[t] * (f * (k1 + 1)) / (f + K)
  }
  sort(scores, decreasing = TRUE)
}

## Rodar as 5 consultas reais nos 3 modelos ------------------------------------
necessidades <- read.csv(file.path("estrutura", "banco-de-dados", "necessidades.csv"),
                          stringsAsFactors = FALSE)

rankings <- list(Booleano = list(), `TF-IDF` = list(), BM25 = list())
for (i in seq_len(nrow(necessidades))) {
  qid <- necessidades$consulta[i]
  qtxt <- necessidades$texto_consulta[i]
  rankings$Booleano[[qid]] <- names(ranking_booleano(qtxt))
  rankings$`TF-IDF`[[qid]] <- names(ranking_tfidf(qtxt))
  rankings$BM25[[qid]] <- names(ranking_bm25(qtxt))
  cat(sprintf("\n=== %s: %s ===\n", qid, qtxt))
  cat("BM25   top5:", head(rankings$BM25[[qid]], 5), "\n")
  cat("TF-IDF top5:", head(rankings$`TF-IDF`[[qid]], 5), "\n")
  cat("Bool.  top5:", head(rankings$Booleano[[qid]], 5), "\n")
}

saveRDS(rankings, file.path("estrutura", "banco-de-dados", "rankings.rds"))
cat("\nGravado estrutura/banco-de-dados/rankings.rds\n")
