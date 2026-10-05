# Avaliação: concordância, gabarito consolidado e métricas (2026-09-29)

Código completo:
[`09-concordancia-kappa.R`](../estrutura/codigo/09-concordancia-kappa.R) ·
[`10-consolidar-qrels.R`](../estrutura/codigo/10-consolidar-qrels.R) ·
[`11-rankings-consultas-reais.R`](../estrutura/codigo/11-rankings-consultas-reais.R) ·
[`12-metricas-avaliacao.R`](../estrutura/codigo/12-metricas-avaliacao.R)

Dados: [`guia_julgamento.md`](../estrutura/banco-de-dados/guia_julgamento.md) ·
[`qrels_equipe.csv`](../estrutura/banco-de-dados/qrels_equipe.csv) ·
[`qrels_consolidado.csv`](../estrutura/banco-de-dados/qrels_consolidado.csv)

## O que foi feito

Continuação de [`07-separacao-teste-desenvolvimento.md`](07-separacao-teste-desenvolvimento.md):
com as 10 consultas já julgadas por victor, flavia e felipe (630 julgamentos
cada, overlap de 100%), faltava medir a concordância entre os três, consolidar
num gabarito único, rodar os três modelos e calcular as métricas.

### 1. Julgamento sem guia prévio — e a consequência disso

O grupo julgou os 630 pares **sem combinar critérios antes**: a ferramenta foi
enviada pulando essa etapa do fluxo recomendado pelo Módulo 3 do guia da
disciplina (*necessidade → consulta → JULGAR*, com o guia de julgamento
decidido antes do julgamento, não depois). Isso não é hipótese — é o que os
dados mostram a seguir.

### 2. Concordância entre juízes (κ de Cohen)

Sobre os 630 pares julgados pelos três:

| par | κ | po (observada) | pe (esperada por acaso) |
|---|---|---|---|
| victor × flavia | 0,618 | 0,975 | 0,934 |
| victor × felipe | 0,500 | 0,951 | 0,902 |
| flavia × felipe | 0,520 | 0,951 | 0,897 |

Concordância bruta acima de 95% nos três pares, mas isso é inflado pela
maioria esmagadora de grau 0 (a maior parte dos parágrafos não responde à
maior parte das consultas) — o κ corrige esse viés, e por isso fica bem mais
baixo que a concordância bruta. **Moderada a boa** (escala do guia: <0,4
fraca, 0,4–0,6 moderada, ≥0,6 boa), não excelente — consistente com um grupo
que não alinhou critério antes de julgar. Se tivessem combinado os casos de
fronteira do `guia_julgamento.md` (escrito só depois, ver abaixo) antes de
julgar, o esperado seria κ mais alto.

### 3. `guia_julgamento.md` reconstruído *a posteriori*

Como não houve guia prévio, os critérios foram reconstruídos depois, a partir
das discordâncias reais: 8 casos onde um juiz deu 0 e outro deu 2, e 30 casos
com diferença de 1 grau (24 deles no padrão "dois juízes deram 0, um deu 1").
O documento resultante não *preveniu* discordância nenhuma — não pode, veio
depois — mas **formaliza o critério implícito** que já estava por trás
dos julgamentos, incluindo um caso de fronteira que os três juízes tiveram
que decidir retroativamente (as duas datas candidatas para a fundação de
Santos, 1543 e 1546, confirmado por victor, flavia e felipe em 2026-09-29).
Ver o arquivo pra a lista completa dos 5 casos.

### 4. Consolidação do gabarito (voto majoritário)

`10-consolidar-qrels.R` consolida os 3 julgamentos por maioria (mediana nos
empates triplos):

| grau | pares |
|---|---|
| 0 | 607 |
| 1 | 9 |
| 2 | 14 |

Apenas **2 de 630 pares** tiveram os três juízes totalmente divergentes
(0/1/2 nos três), resolvidos por mediana.

### 5. Rankings e métricas, com a blindagem teste/desenvolvimento

`11-rankings-consultas-reais.R` roda Booleano (coordenação), TF-IDF+cosseno e
BM25 (k1=1.2, b=0.75) para as 10 consultas. `12-metricas-avaliacao.R` calcula
P@k, R@k, AP/MAP, MRR e nDCG (binário e graduado) — validado contra o
exemplo do Módulo 6 do guia antes de aplicar aos dados reais (P@3=0,667,
AP=0,833, MRR=1,000, nDCG bin.=0,920, nDCG grad.=0,951 — bateu 1:1).

A separação teste/desenvolvimento decidida em `07` é aplicada **antes** de
qualquer `print()` ou `write.csv()`: as métricas das 3 consultas de teste
(q01, q04, q08) nunca passam pelo console nem pelo `metricas_por_consulta.csv`
— vão só para `metricas_teste_LACRADO_nao_abrir.csv`, que só deve ser aberto
na hora de escrever o relatório final.

Médias em desenvolvimento (7 consultas: q02, q03, q05, q06, q07, q09, q10):

| modelo | MAP | MRR | nDCG@10 bin. | nDCG@10 grad. |
|---|---|---|---|---|
| BM25 | 0,597 | 0,591 | 0,612 | 0,589 |
| Booleano | 0,597 | 0,627 | 0,615 | 0,589 |
| TF-IDF | 0,573 | 0,567 | 0,593 | 0,574 |

Os três ficam próximos, com Booleano à frente em MRR — plausível com só 7
consultas de desenvolvimento e relevância concentrada em poucos parágrafos
por consulta; não necessariamente sinal de que o BM25 não ajuda. Vale
investigar consulta a consulta no relatório final, quando as 3 de teste
também entrarem na análise.

### 6. Autoconsistência (Módulo 13) — decidido não fazer

O guia da disciplina prevê, para quem julga sozinho, uma segunda passada
(20% dos itens, rejulgados pelo mesmo juiz após ao menos 1 dia, comparando
consigo mesmo). O grupo decidiu **não fazer**: com overlap de 100% entre os
três juízes (630 pares cada, não os 20% mínimos que o guia pede), a
concordância entre juízes já é uma medida mais forte do que a
autoconsistência supriria — e repetir mais de 100 julgamentos por pessoa,
depois de já terem feito mais de 600, não compensava.

### 7. Bugs encontrados e corrigidos no caminho

Documentados nos próprios scripts, resumidos aqui porque afetaram a saída:

- **BOM UTF-8** em `qrels_equipe.csv` (exportação do `julgar.html`) quebrava
  a leitura da 1ª coluna no R — corrigido com `fileEncoding = "UTF-8-BOM"`
  em `09` e `10`.
- **Vírgula sem aspas** no campo `escopo` da linha q07 de `necessidades.csv`
  quebrava o parsing do CSV e gerava uma 11ª consulta fantasma — corrigido
  colocando o campo entre aspas.
- **Bug na função `ndcg()`** de `12-metricas-avaliacao.R`: `as.numeric()`
  derrubava os nomes do vetor de graus antes de indexar por nome, dando `NA`
  em toda métrica de nDCG binário (inclusive na validação contra o Módulo 6)
  e quebrando o `aggregate()` das médias. Corrigido preservando os nomes com
  `setNames()`.

## O que isso representa para o projeto

O gabarito (`qrels_consolidado.csv`) e as métricas de desenvolvimento estão
prontos para orientar ajuste de `k1`/`b` do BM25 e comparação entre modelos
nas próximas aulas. As métricas de teste (q01, q04, q08) ficam lacradas até o
relatório final, junto com uma limitação real para registrar nele: o grupo
julgou sem alinhar critérios antes, o κ entre juízes saiu moderado como
consequência disso, e o guia de julgamento só existe reconstruído
retroativamente — o oposto do fluxo que o Módulo 3 recomenda, e um resultado
em si sobre o que falta quando essa etapa é pulada.
