# Pré-processamento e Índice Invertido (2026-09-12)

Código completo:
[`07-pre-processamento-indice-invertido.R`](../estrutura/codigo/07-pre-processamento-indice-invertido.R)
(corpus real, granularidade de parágrafo — reaproveita `tokenizar_limpo` e
`stopwords_pt` de
[`03-corpus-cidades-tfidf-busca.R`](../estrutura/codigo/03-corpus-cidades-tfidf-busca.R))

## O que foi feito

Tarefa oficial: montar um índice invertido do corpus, adicionar stemming
com `SnowballC::wordStem(..., "portuguese")` e implementar `busca_AND` e
`busca_OR`, comparando os resultados. Em vez de repetir o corpus de
brinquedo de 8 frases já usado nas aulas anteriores, essa aula foi
aplicada direto ao corpus real dos 63 parágrafos das três cidades (Santos,
Cubatão e Guarujá) — a mesma granularidade de
`03b-corpus-cidades-paragrafos.R`.

Sem stemming, o vocabulário do corpus (já sem stopwords) tem **1.369
termos distintos**, um por chave do índice invertido. Os termos com listas
de postagem mais longas são exatamente os que se espera que dominem um
corpus sobre três cidades vizinhas: `santos` (31 parágrafos), `cidade`
(19), `municipio` (17), `cubatao` (17), `guaruja` (16), `maior` (15),
`santista` (14) — só depois vêm termos mais específicos como `porto` (12)
e `ilha` (12).

Três buscas booleanas ilustram a diferença entre AND e OR:

| Consulta | `busca_AND` | `busca_OR` |
|---|---|---|
| `porto turismo` | 3 parágrafos (`Guaruja_p18`, `Santos_p1`, `Santos_p17`) | 20 parágrafos |
| `praia industria` | **0 parágrafos** | 7 parágrafos |
| `cafe porto` | 4 parágrafos (`Cubatao_p18`, `Santos_p18`, `Santos_p21`, `Santos_p9`) | 14 parágrafos |

## O que isso representa para o projeto

O caso mais revelador é `praia industria`: nenhum parágrafo do corpus
menciona os dois termos ao mesmo tempo, então `busca_AND` devolve uma
lista vazia — um resultado tecnicamente correto, mas inútil para quem
está buscando. É a mesma fragilidade do modelo booleano puro que já havia
aparecido na primeira aula do projeto (busca sim/não, sem noção de
"quase relevante"), só que agora explícita numa consulta real: `OR` ainda
devolve 7 parágrafos plausíveis (praias de um lado, indústria do outro),
mas sem nenhuma forma de dizer qual dos dois termos importa mais nem de
ranquear esses 7 por relevância. Esse é exatamente o problema que o BM25,
na aula seguinte, resolve.

A adição do stemming muda a unidade do índice: em vez de indexar palavras
exatas, indexamos radicais, e uma busca por "portuário" passa a casar com
parágrafos que só mencionam "porto" ou "portuária". O código constrói as
duas versões do índice (com e sem stemming) lado a lado para permitir essa
comparação; o preço, como a Aula 03 avisa, é que o radical deixa de ser
uma palavra real e formas diferentes podem colapsar demais — o mesmo
trade-off recall/precisão discutido no slide sobre o Snowball.

Estruturalmente, essa aula também é a primeira vez que o projeto separa
**indexação** (construção do dicionário de termos → parágrafos, paga uma
única vez) de **busca** (interseção/união de listas já prontas, sem reler
nenhum documento) — o mesmo princípio por trás de qualquer motor de busca
real, só que aqui visível em ~60 linhas de R.
