# Introdução ao R (2026-08-07)

Código completo: [`estrutura/código/01-intro-r.R`](../estrutura/código/01-intro-r.R)

## O que foi feito

Primeira aula do semestre, focada em pegar familiaridade com a sintaxe do R
que sustenta todo o motor de busca construído ao longo do curso: vetores
nomeados, funções, `lapply`/`sapply`, `factor`/`table` e as principais
funções de regex (`grep`, `grepl`, `sub`, `gsub`).

A atividade teve três partes: copiar e explicar com minhas próprias
palavras os blocos de código dados em aula, alterar algum parâmetro de cada
bloco e prever o resultado antes de rodar, e responder um conjunto de
perguntas de investigação livre.

## O que isso representa para o projeto

Praticamente todo o vocabulário técnico usado nas aulas seguintes aparece
aqui em miniatura:

- **Vetor nomeado** (`docs <- c(d1 = "...", d2 = "...")`) é a estrutura de
  dados que vira, três aulas depois, o próprio corpus de documentos do
  motor de busca.
- **`table(factor(tokens, levels = vocab))`** é o núcleo da matriz
  termo-documento (TDM): sem o `factor` fixando os `levels`, termos do
  vocabulário que não aparecem num documento específico simplesmente somem
  da contagem, em vez de aparecerem como zero — o que quebraria qualquer
  matriz que dependa de todas as colunas terem o mesmo número de linhas.
- **Reciclagem de vetores** (`m * peso`) é o mesmo mecanismo, mais tarde,
  por trás de `tdm * idf`: multiplicar uma matriz por um vetor mais curto
  recicla o vetor linha a linha. Entender quando a reciclagem é "limpa"
  (múltiplo exato) e quando gera aviso foi importante para não introduzir
  bugs silenciosos nos cálculos de TF-IDF.
- **Regex** (`grep`, `sub`, `gsub`) antecipa a diferença, explorada na Aula
  02, entre buscar por *substring* (regex, mais permissivo, mas ambíguo —
  "Porto de Santos" também casa com a busca por "Santos") e buscar por
  *token exato no vocabulário* (busca booleana, mais rígida, mas precisa).
  A "pegadinha" da missão final (distinguir "Santos" cidade de "Santos"
  dentro de "Porto de Santos" usando só regex) já deixa claro que regex
  puro não basta: falta a etapa de tokenização proposta na aula seguinte.

Essa base de sintaxe é o que permitiu focar, nas aulas seguintes, nos
conceitos de recuperação de informação em si, sem precisar parar para
explicar `sapply` ou `factor` no meio de um raciocínio sobre TF-IDF.
