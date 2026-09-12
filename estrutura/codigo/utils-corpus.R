# utils-corpus.R
#
# Funções compartilhadas para carregar o corpus das três cidades
# (Santos, Cubatão e Guarujá) a partir dos arquivos .txt salvos em
# estrutura/corpus/ (ver 00-preparar-corpus.R).
#
# carregar_corpus() devolve duas visões do mesmo corpus:
#   - $texto -> 1 documento por cidade (texto inteiro), usado nas análises
#               que tratam "o verbete da cidade" como unidade (TDM/TF-IDF
#               por cidade, busca por cidade).
#   - $docs  -> 1 documento por parágrafo (ex.: Santos_p1, Santos_p2, ...),
#               na mesma granularidade "curta" do corpus de brinquedo
#               (d1...d8), usado para análise mais fina por trecho do texto.

dividir_paragrafos <- function(texto) {
  # Separa por uma ou mais linhas em branco (like um parágrafo do Word)
  partes <- strsplit(texto, "\n\\s*\n")[[1]]
  partes <- trimws(partes)
  partes[nchar(partes) > 0]
}

carregar_corpus <- function(pasta = file.path("estrutura", "corpus")) {
  arquivos <- list.files(pasta, pattern = "\\.txt$", full.names = TRUE)
  if (length(arquivos) == 0) {
    stop("Nenhum .txt encontrado em '", pasta, "'. Rode 00-preparar-corpus.R primeiro.")
  }
  names(arquivos) <- tools::file_path_sans_ext(basename(arquivos))

  # Visão 1: texto inteiro por cidade
  cidades_texto <- sapply(arquivos, function(f) {
    paste(readLines(f, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  })

  # Visão 2: parágrafos por cidade (granularidade tipo "frase" do corpus de brinquedo)
  cidades_docs <- unlist(lapply(names(cidades_texto), function(cidade) {
    paragrafos <- dividir_paragrafos(cidades_texto[[cidade]])
    setNames(paragrafos, paste0(cidade, "_p", seq_along(paragrafos)))
  }))

  list(texto = cidades_texto, docs = cidades_docs)
}
