# 14-separar-teste-desenvolvimento.R
# Aula 5,5 — Módulo 8 do guia: separar consultas de teste ANTES de julgar
# qualquer item, para evitar contaminação quando o gabarito virar rótulo
# de treino (Aula 09, learning to rank).
#
# Só faz sentido rodar isto uma vez, antes de abrir estrutura/ferramenta/
# julgar.html para q06-q10. Depois de gerado, split_teste_desenvolvimento.csv
# é fixo até o relatório final — não se re-sorteia para "melhorar" o
# resultado.
#
# Entrada:  estrutura/banco-de-dados/necessidades.csv (10 consultas)
# Saída:    estrutura/banco-de-dados/split_teste_desenvolvimento.csv
#           (consulta,dificuldade,conjunto)

necessidades <- read.csv(file.path("estrutura", "banco-de-dados", "necessidades.csv"),
                          stringsAsFactors = FALSE)

## 1. Classificação de dificuldade -------------------------------------------
# Critério: dificuldade não é opinião solta, é sobre DISTÂNCIA LÉXICA entre a
# consulta e o parágrafo que responde (o mesmo ponto do Módulo 6 do guia:
# "casamento léxico != relevância"). Cada linha foi conferida à mão contra
# estrutura/corpus/*.txt antes de classificar.
#
#   facil   - a resposta usa (quase) as mesmas palavras da consulta, num só
#             parágrafo, sem concorrente próximo.
#   medio   - a resposta existe, mas precisa de um sinônimo ou há um
#             distrator no mesmo documento que compartilha vocabulário.
#   dificil - o termo exato da consulta não aparece em lugar nenhum do
#             corpus (exige sinônimo real) OU há vários candidatos
#             plausíveis e só um responde de fato.
dificuldade <- c(
  q01 = "facil",   # "Fundada em 1546" -- quase verbatim, 1 parágrafo, sem concorrente
  q02 = "facil",   # "orla santista e composta por 6 praias" -- verbatim, 1 frase
  q03 = "facil",   # "Abriga o maior porto da America Latina" -- quase verbatim
  q04 = "dificil", # "polo industrial" NUNCA aparece no corpus; a info está
                    # espalhada em "parque industrial" (Cubatao_p3) e "maior
                    # distrito industrial do pais" (Guaruja_p35) -- dois
                    # documentos, dois sinônimos, nenhum usa a palavra da consulta
  q05 = "medio",   # "area de 144,794 km2" -- exige ligar "tamanho" a "area"
  q06 = "facil",   # "jogadores", "futebol", Pele/Neymar -- vocabulário direto,
                    # só existe em Santos.txt, sem distrator de outra cidade
  q07 = "dificil", # 4 anos candidatos no mesmo parágrafo (1803, 1833, 1841,
                    # 1949) -- so 1949 e "emancipacao"/"virou municipio";
                    # os outros são povoado e incorporação, não emancipação
  q08 = "medio",   # etimologia usa "derivado do termo tupi", não usa
                    # "significado"/"nome"; distrator no parágrafo anterior
                    # (apelido turístico "Pérola do Atlântico")
  q09 = "medio",   # "Censo" aparece literalmente, mas no mesmo documento há
                    # uma estimativa do IBGE de 2023 (não censitária) sobre a
                    # mesma cidade -- exige distinguir a fonte, não só o termo
  q10 = "facil"    # "balsas da Travessia Santos-Guaruja" -- verbatim
)

necessidades$dificuldade <- dificuldade[necessidades$consulta]

cat("Distribuição de dificuldade:\n")
print(table(necessidades$dificuldade))

## 2. Sorteio estratificado, 70/30 -------------------------------------------
# 10 consultas -> 7 desenvolvimento / 3 teste. Para não deixar a sorte
# concentrar o teste numa única faixa de dificuldade (e também pra não
# deixar a escolha na mão de ninguém do grupo), sorteamos 1 de cada grupo
# de dificuldade -- 1 facil, 1 medio, 1 dificil -- e o resto vira
# desenvolvimento.
#
# set.seed fixo e documentado: qualquer pessoa do grupo que rodar este
# script obtém o MESMO sorteio. Não trocar a seed depois de decidido.
set.seed(2026)

sortear_um <- function(grupo) {
  sample(sort(necessidades$consulta[necessidades$dificuldade == grupo]), 1)
}

teste <- c(
  facil   = sortear_um("facil"),
  medio   = sortear_um("medio"),
  dificil = sortear_um("dificil")
)

necessidades$conjunto <- ifelse(necessidades$consulta %in% teste,
                                 "teste", "desenvolvimento")

cat("\nSorteados para TESTE (1 por faixa de dificuldade):\n")
print(teste)

cat("\nConjunto final:\n")
print(necessidades[order(necessidades$conjunto, necessidades$dificuldade),
                    c("consulta", "dificuldade", "conjunto")])

write.csv(necessidades[, c("consulta", "dificuldade", "conjunto")],
          file.path("estrutura", "banco-de-dados", "split_teste_desenvolvimento.csv"),
          row.names = FALSE)

cat("\nGravado estrutura/banco-de-dados/split_teste_desenvolvimento.csv\n")
cat("Lembrete: as 3 consultas de teste NÃO se olham até o relatório final ",
    "(Módulo 8 do guia) -- nem para ajustar k1/b do BM25, nem para calibrar ",
    "o LLM juiz nas próximas aulas.\n", sep = "")
