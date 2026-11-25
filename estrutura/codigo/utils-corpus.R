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

# Tira os acentos e põe em minúsculas, igual em qualquer computador.
# Por que não iconv(x, to = "ASCII//TRANSLIT"): o resultado dele depende do
# idioma configurado na máquina. Em alguns ambientes (Windows, servidores
# sem locale UTF-8) cada letra acentuada vira "?", e "Guarujá" vira "guaruj",
# que não casa com a consulta "guaruja". Aqui a troca é feita à mão, byte a
# byte, e dá o mesmo resultado em qualquer lugar. (Corrigido na Aula 06.)
sem_acentos <- function(x) {
  de <- intToUtf8(c(0xe1, 0xe0, 0xe2, 0xe3, 0xe4, 0xe9, 0xe8, 0xea, 0xeb, 0xed, 0xec, 0xee, 0xef,
                    0xf3, 0xf2, 0xf4, 0xf5, 0xf6, 0xfa, 0xf9, 0xfb, 0xfc, 0xe7, 0xf1,
                    0xc1, 0xc0, 0xc2, 0xc3, 0xc4, 0xc9, 0xc8, 0xca, 0xcb, 0xcd, 0xcc, 0xce, 0xcf,
                    0xd3, 0xd2, 0xd4, 0xd5, 0xd6, 0xda, 0xd9, 0xdb, 0xdc, 0xc7, 0xd1),
                  multiple = TRUE)
  para <- rep(strsplit("aaaaaeeeeiiiiooooouuuucn", "")[[1]], 2)   # maiúscula acentuada vira minúscula sem acento
  x <- enc2utf8(x)
  for (i in seq_along(de)) x <- gsub(de[i], para[i], x, fixed = TRUE, useBytes = TRUE)
  tolower(x)
}
