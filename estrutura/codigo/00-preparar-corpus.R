# 00-preparar-corpus.R
#
# Baixa os verbetes da Wikipédia em português para Santos, Cubatão e
# Guarujá e grava cada um em um .txt separado dentro de estrutura/corpus/.
#
# Rodar este script uma única vez (ou sempre que quiser atualizar o
# corpus). Os demais scripts e notebooks leem os .txt salvos aqui via
# utils-corpus.R, em vez de baixar da API a cada execução.

library(httr2)

baixar_wiki <- function(titulo) {
  request("https://pt.wikipedia.org/w/api.php") |>
    req_url_query(action = "query", prop = "extracts", explaintext = 1,
                  format = "json", redirects = 1, titles = titulo) |>
    req_perform() |> resp_body_json() |>
    (\(r) r$query$pages[[1]]$extract)()
}

dir.create(file.path("estrutura", "corpus"), showWarnings = FALSE, recursive = TRUE)

cidades <- c(Santos = "Santos", Cubatao = "Cubatão", Guaruja = "Guarujá")

for (nome in names(cidades)) {
  texto <- baixar_wiki(cidades[[nome]])
  writeLines(texto, file.path("estrutura", "corpus", paste0(nome, ".txt")), useBytes = TRUE)
  cat("Salvo:", nome, "-", nchar(texto), "caracteres\n")
}

# Fonte: Wikipédia em português (CC BY-SA). Ver estrutura/corpus/
# para os .txt já baixados e usados pelo restante do projeto.
