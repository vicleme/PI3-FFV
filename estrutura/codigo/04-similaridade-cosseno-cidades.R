# 04-similaridade-cosseno-cidades.R
# Atualização de 25/08/2026 (Aulas 1.5 e 2): similaridade de cosseno aplicada
# ao corpus real das cidades, reaproveitando TDM/TF-IDF de
# 03-corpus-cidades-tfidf-busca.R. Mesma lógica do projeto "Similaridade do
# Cosseno" da Flávia (TF-IDF + cosseno para ranquear por proximidade a uma
# query) — aqui o "documento" é o verbete da cidade e a "query" é um
# interesse de busca (ex.: turismo, indústria, porto).
#
# Depende de objetos criados em 03-corpus-cidades-tfidf-busca.R:
# tfidf_cidades, vocab_cidades, idf_cid, tokenizar_limpo.

cosseno <- function(a, b) {
  denom <- sqrt(sum(a^2)) * sqrt(sum(b^2))
  if (denom == 0) return(0) # sem termos em comum com a query -> similaridade 0, não NaN
  sum(a * b) / denom
}

buscar_cidade <- function(consulta_txt, tfidf, vocab, idf) {
  termos_q <- tokenizar_limpo(consulta_txt)
  q  <- as.integer(table(factor(termos_q, levels = vocab)))
  qw <- q * idf
  scores <- apply(tfidf, 2, function(v) cosseno(qw, v))
  sort(scores, decreasing = TRUE)
}

cat("=== Consulta: porto industria petroleo ===\n")
print(round(buscar_cidade("porto industria petroleo", tfidf_cidades, vocab_cidades, idf_cid), 4))

cat("\n=== Consulta: praia turismo ===\n")
print(round(buscar_cidade("praia turismo", tfidf_cidades, vocab_cidades, idf_cid), 4))

cat("\n=== Consulta: poluicao industrial saude ===\n")
print(round(buscar_cidade("poluicao industrial saude", tfidf_cidades, vocab_cidades, idf_cid), 4))

## Verificação com dados já conhecidos da Aula 01 (execução offline) -----------
# Sub-vetores reais já calculados na Aula 01, usados aqui só para demonstrar
# o método sem depender de internet em outro ambiente.
termos_amostra <- c("porto", "industria", "praia", "turismo", "petroleo", "ferrovia")
tfidf_amostra <- cbind(
  Santos  = c(0.00, 0.41, 7.30, 3.65, 1.10, 1.10),
  Cubatao = c(0,    0,    0,    0,    0,    0),
  Guaruja = c(0.00, 0.81, 3.65, 3.65, 0.00, 0.00)
)
rownames(tfidf_amostra) <- termos_amostra

idf_amostra <- c(porto = 0, industria = log(3 / 2), praia = log(3 / 2),
                  turismo = log(3 / 2), petroleo = log(3 / 1), ferrovia = log(3 / 1))

buscar_amostra <- function(termos_consulta) {
  q  <- as.integer(rownames(tfidf_amostra) %in% termos_consulta)
  qw <- q * idf_amostra[rownames(tfidf_amostra)]
  scores <- apply(tfidf_amostra, 2, function(v) cosseno(qw, v))
  sort(scores, decreasing = TRUE)
}

round(buscar_amostra(c("porto", "industria", "petroleo")), 4)
round(buscar_amostra(c("praia", "turismo")), 4)
