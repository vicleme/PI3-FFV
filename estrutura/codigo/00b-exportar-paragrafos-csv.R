# 00b-exportar-paragrafos-csv.R
#
# Exporta a visão em parágrafos do corpus (corpus$docs, de utils-corpus.R)
# para um .csv em estrutura/corpus/paragrafos.csv — útil para inspecionar
# a divisão fora do R (Excel, pandas, revisão do professor) sem precisar
# rodar nenhum notebook.
#
# Rodar depois de 00-preparar-corpus.R (precisa dos .txt já salvos).

source("utils-corpus.R")
corpus <- carregar_corpus()

cidade_de <- sub("_p\\d+$", "", names(corpus$docs))
paragrafo_num <- as.integer(sub(".*_p", "", names(corpus$docs)))

tabela_paragrafos <- data.frame(
  doc_id = names(corpus$docs),
  cidade = cidade_de,
  paragrafo_num = paragrafo_num,
  n_caracteres = nchar(corpus$docs),
  texto = corpus$docs,
  row.names = NULL,
  stringsAsFactors = FALSE
)

write.csv(
  tabela_paragrafos,
  file.path("estrutura", "corpus", "paragrafos.csv"),
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

cat(nrow(tabela_paragrafos), "parágrafos exportados para estrutura/corpus/paragrafos.csv\n")
table(tabela_paragrafos$cidade)
