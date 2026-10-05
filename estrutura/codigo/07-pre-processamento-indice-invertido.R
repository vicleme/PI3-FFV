# 07-pre-processamento-indice-invertido.R
# Aula: Pré-processamento e Índice Invertido (Aula 03, 2026-09-12)
# Normalização de texto, stemming (SnowballC) e índice invertido (postings
# list), aplicados ao corpus real de parágrafos das três cidades — mesma
# granularidade "curta" de 03b-corpus-cidades-paragrafos.R (1 documento por
# parágrafo, ex.: Santos_p1, Santos_p2, ...).
#
# Depende de objetos/funções criados em 03-corpus-cidades-tfidf-busca.R:
# stopwords_pt, tokenizar_limpo (já faz minúsculas + remoção de acento e
# pontuação + colapso de espaços + remoção de stopwords, na mesma ordem do
# limpar() do slide da Aula 03).
#
# Ver consolidado-legado/05-pre-processamento-indice-invertido.md para a interpretação.

source("utils-corpus.R")
corpus <- carregar_corpus()
docs <- corpus$docs
length(docs)

## Bloco 1: normalização (revisão do passo a passo da Aula 03) ----------------
# tokenizar_limpo já faz isso; aqui isolamos só a etapa de limpeza (sem
# tokenizar ainda) para conferir o "antes/depois" de um parágrafo real.
limpar <- function(x) {
  x <- tolower(x)
  x <- iconv(x, to = "ASCII//TRANSLIT")
  x <- gsub("[^a-z0-9 ]", " ", x)
  x <- gsub("\\s+", " ", x)
  trimws(x)
}
substr(docs[["Santos_p1"]], 1, 120)
substr(limpar(docs[["Santos_p1"]]), 1, 120)

## Bloco 2: stemming (SnowballC) -----------------------------------------------
# install.packages("SnowballC") # so na primeira vez
library(SnowballC)

prep <- function(x) {
  termos <- tokenizar_limpo(x) # limpa + tokeniza + remove stopwords (03-corpus-cidades-tfidf-busca.R)
  wordStem(termos, language = "portuguese") # reduz ao radical (tarefa da Aula 03)
}
prep(docs[["Santos_p1"]])[1:12]

# Efeito do stemming no vocabulario: quanto ele reduz o numero de termos distintos
vocab_sem_stem <- sort(unique(unlist(lapply(docs, tokenizar_limpo))))
vocab_com_stem <- sort(unique(unlist(lapply(docs, prep))))
length(vocab_sem_stem)
length(vocab_com_stem)
cat("Reducao de vocabulario por stemming:",
    length(vocab_sem_stem) - length(vocab_com_stem), "termos\n")

## Bloco 3: construindo o índice invertido -------------------------------------
# Mesmo laço da Aula 03 (lê por documento, grava por termo), aplicado aqui
# aos termos já stemizados, para que buscas por variações da mesma palavra
# (ex.: "praia"/"praias", "portuario"/"portuaria") caiam no mesmo radical.
postings <- list()
for (d in names(docs)) {
  for (termo in unique(prep(docs[[d]]))) {
    postings[[termo]] <- c(postings[[termo]], d)
  }
}
length(postings) # termos distintos indexados (deve bater com vocab_com_stem)

## Bloco 4: estatísticas do índice ----------------------------------------------
sort(lengths(postings), decreasing = TRUE)[1:10]

# Também construímos a versão SEM stemming, só para comparar os postings
# de um termo específico nas duas versões do índice.
postings_sem_stem <- list()
for (d in names(docs)) {
  for (termo in unique(tokenizar_limpo(docs[[d]]))) {
    postings_sem_stem[[termo]] <- c(postings_sem_stem[[termo]], d)
  }
}
length(postings_sem_stem)

## Bloco 5: busca_AND e busca_OR -------------------------------------------------
# Consulta AND -> intersecao das listas de postagem (documento precisa ter
# TODOS os termos). Consulta OR -> uniao (documento precisa ter PELO MENOS
# UM termo). Regra de ouro: a consulta passa pelo mesmo prep() dos documentos.
busca_AND <- function(consulta, indice = postings) {
  termos <- unique(prep(consulta))
  termos <- termos[termos %in% names(indice)]
  if (length(termos) == 0) return(character(0))
  Reduce(intersect, indice[termos])
}

busca_OR <- function(consulta, indice = postings) {
  termos <- unique(prep(consulta))
  termos <- termos[termos %in% names(indice)]
  if (length(termos) == 0) return(character(0))
  unique(unlist(indice[termos]))
}

cat("AND('porto turismo'):\n"); print(busca_AND("porto turismo"))
cat("OR('porto turismo'): ", length(busca_OR("porto turismo")), "documentos\n")

cat("\nAND('praia industria'):\n"); print(busca_AND("praia industria"))
cat("OR('praia industria'): ", length(busca_OR("praia industria")), "documentos\n")

cat("\nAND('cafe porto'):\n"); print(busca_AND("cafe porto"))
cat("OR('cafe porto'): ", length(busca_OR("cafe porto")), "documentos\n")
