# Guia de julgamento de relevância

Projeto Integrador III — Motor de Busca. Critérios usados por victor, flavia e
felipe para julgar os 630 pares (consulta, documento) do `qrels_equipe.csv`.

Reconstruído *a posteriori*: o grupo não combinou critérios antes de julgar.
Este guia foi escrito depois, a partir das discordâncias reais entre os três
juízes (8 casos extremos — um deu 0, outro deu 2 — e 30 casos leves), pra
documentar o critério que teria evitado essas discordâncias. Ver
`consolidado-legado/` para a interpretação completa; aqui só as regras.

## Os graus

**Grau 0 — não serve.** O parágrafo não fala do assunto da necessidade, ou
fala de um evento do mesmo tema geral mas que não é o marco perguntado
(outra data, outro personagem, outro episódio histórico).

**Grau 1 — fala do assunto.** O parágrafo toca no tema da necessidade mas
não dá o dado específico pedido (ano, número, nome) — ou dá esse dado de
forma incompleta ou só implícita.

**Grau 2 — responde.** O parágrafo dá o dado específico pedido pela
necessidade, **mesmo que não seja o foco do parágrafo** e apareça só numa
frase no meio ou no fim do texto. A resposta não precisa ser a informação
central do trecho.

## Casos de fronteira

### 1. Resposta enterrada num parágrafo que fala principalmente de outra coisa
`q07 / Cubatao_p8`: o parágrafo abre falando da tentativa de povoamento de
1833 e da incorporação a Santos em 1841 — datas que o escopo de q07
explicitamente exclui ("outros marcos históricos... sem indicar o ano da
emancipação política"). Mas a última frase diz "a emancipação de Cubatão
ocorreria 108 anos depois, em 1949" — a resposta certa, só que no fim do
parágrafo, não no começo.
**Decisão:** grau 2. Não vale julgar só pela primeira impressão do
parágrafo; ler até o fim antes de decidir.

### 2. Evento do mesmo tema, mas não é o marco perguntado
`q01 / Santos_p8`: fala do ataque pirata de 1591 e da lenda de Nossa Senhora
do Monte Serrat — evento posterior à fundação, sem relação com o marco
fundacional.
**Decisão:** grau 0, mesmo contendo uma data e sendo sobre a história antiga
de Santos. Citar uma data no período certo não basta; a data tem que ser do
evento perguntado.

### 3. Fundação de Santos: duas datas candidatas no próprio corpus
O corpus contém dois marcos que poderiam ser lidos como "a fundação" de
Santos:
- **1543** (`Santos_p6`) — construção da capela por Luís de Góis, transferência
  do porto, e o povoado passa a ser chamado "Todos os Santos";
- **1546** (`Santos_p7`) — elevação à condição de vila por Brás Cubas.

Essa ambiguidade sozinha explica 3 dos 8 casos extremos de discordância em
q01.
**Decisão do grupo (confirmada por victor, flavia e felipe em 2026-09-29):**
contam as duas — qualquer parágrafo que dê uma das duas datas no contexto
certo recebe grau 2. Não há uma "fundação oficial" única no corpus, e
forçar uma escolha seria julgar contra uma informação que o próprio
material não resolve.

### 4. Etimologia dada na forma original, sem repetir o nome atual
`q08 / Guaruja_p6`: dá a origem tupi do nome — "Guaru-ya, passagem estreita"
— sem escrever "Guarujá" em nenhum momento do parágrafo.
**Decisão:** grau 2. A necessidade pede a origem e o significado do nome; a
forma tupi anterior à aportuguesamento *é* essa origem, mesmo sem repetir a
grafia atual.

### 5. Estimativa oficial como fonte de população, em vez de censo
`q09 / Cubatao_p1`: dá a população via "estimativas do IBGE de 2023", não
via "censo" no sentido estrito.
**Decisão:** grau 2. O próprio escopo de q09 já implica isso ("não contam...
estimativas **sem** fonte censitária") — uma estimativa **com** fonte
oficial (IBGE) conta. Estimativa sem fonte nomeada (blogs, "por volta de",
etc.) continua valendo 0.

## Nota sobre a linha de fratura real

Os 8 casos acima chamam atenção por serem extremos, mas a maior fonte de
discordância no gabarito são os 30 casos leves — e 24 deles seguem o mesmo
padrão: dois juízes deram 0, um deu 1. Ou seja, a fronteira que mais gerou
divergência no projeto não foi "relevante vs. não relevante" (grau 1 vs. 2),
foi **"não fala do assunto" vs. "fala do assunto mas não responde"** (grau 0
vs. 1). As definições de grau 0 e grau 1 acima foram escritas com isso em
mente; se um caso novo cair nessa fronteira, aplicar o mesmo teste: o
parágrafo *menciona* o tema, ou só *é do mesmo domínio geral* (mesma
cidade, mesmo assunto amplo) sem tocar no que foi perguntado?
