# Consolidado, PI III, Aula 08, 2026-11-26

*guia versão 2 · tutora: Claude · sessão em dupla (teoria) · motor08*  

**Alunos:** Victor e Felipe

## 1. O que foi passado

- M1: dois estágios; $\text{R@}2 = 0{,}5$ e $\text{R@}3 = 1$; com limiar 1, $k = 6$ para entregar todos os relevantes
- M2: pontuar cada lado separado (BM25, LSA) × ler o par; custo em leituras do par ($1\,000$ contra $100\,000$); `d2` embaralhado, mesmo BM25
- M3: proximidade ordenada: `d2`$1$, `d3`$0{,}5$, `d1`$0$ à mão; `"modelo de texto"`$1{,}5$ contra $1$; janela $w = 1$ só deixa o `d2`
- M4: `reordenar`: $k = 2$ não muda; $k = 3$ leva `d2` ao topo e o AP de $0{,}833$ a $1$; empate pela ordem do estágio 1 em `"vetores de documentos"`
- M5: limites do brinquedo (`"documentos busca"` dá $0$ a todos); *cross-encoder* como conceito
- M6: latência × qualidade; o AP para de subir em $k = 3$; $k$ e janela se escolhem no desenvolvimento
- Tarefa: `"recuperacao de informacao"` e `"busca de documentos"`, com $k = 2$ e $k = 4$
## 2. Como foi o aprendizado: opinião da tutora

Victor informou que fez a sessão junto com Felipe. As respostas vieram por escrito, com as contas passo a passo, numa voz só, então não sei quem respondeu cada pergunta. A dupla contou a proximidade à mão antes do R em `d3`, `d2` e na consulta `"modelo de texto"`, e acertou o descarte da distância fora da janela e o uso só da menor distância válida. Previram a saída antes de rodar quase sempre. Duas vezes (perguntas 3 e 5 do teste) a conta começou com o sinal da diferença errado e foi corrigida no mesmo parágrafo, chegando ao número certo. Na tabela do Módulo 4 confundiram o $k$ do `reordenar` com o $k$ padrão do `metricas` ($\text{P@}3$); com duas perguntas curtas chegaram sozinhos à diferença. Entenderam que o estágio 2 não recupera: a cauda fica intacta, e usaram o empate certo no Checkpoint 4. Chegaram sozinhos à objeção de que $k$ se escolhe com várias consultas. Pediram que eu explicasse "brinquedo" e "*cross-encoder*", e eu expliquei; as funções `proximidade` e `reordenar` vieram prontas da minha apresentação, no ciclo de mostrar, prever e rodar.

Na tarefa, a proximidade e a reordenação saíram certas, inclusive o empate de `d5`, `d1` e `d6` em $\frac{1}{3}$ e a leitura de que o ganho com $k = 4$ era frágil. Mas a primeira versão partiu de um BM25 escrito sem rodar `ranking_bm25`: deram $0$ ao `d8`, que tem `de`, e trataram `d2`, `d3` e `d6` como empatados. Depois de rodar, refizeram a cabeça e o ranking final de cada consulta sem mudar a conclusão.

**Teste final:** acertaram M1, M2, M3, M4, M5 e M6. Na M6, a explicação de que o MAP menor em $k = 50$ vem de ruído promovido pelo estágio 2 é compatível com os números, mas três valores de MAP não provam isso; a tutora pediu que se diga "pode ser". A escolha de $k = 10$ e a regra de não usar o teste para desempatar estavam certas. Nenhum módulo para refazer; os itens de revisão da seção 3 vêm dos tropeços descritos acima.

## 3. Observações para a frente

- **Revisar antes da Aula 09:** (1) o $k$ do `reordenar` (quantos candidatos o estágio 2 lê) é diferente do $k$ do `metricas` (até que posição a métrica olha); (2) conferir o sinal da diferença $p_j - p_i$ antes de concluir; (3) rodar o estágio 1 antes de reordenar: o ranking final herda qualquer erro do BM25, então não se prevê o BM25 de cabeça.
- **Para a próxima tutora:** a dupla é confortável com laços e com o R, faz as contas à mão, gosta de saída em tabela e de saber o que um termo significa antes de usá-lo. Funciona melhor com um passo por mensagem.
- **Perguntas guardadas:** nenhuma.
- **Produzido:**`proximidade`, `reordenar`; BM25 reordenado com $k = 3$: `d2 d3 d1 d4 d8 d6 d5 d7`; tarefa, `"busca de documentos"` com $k = 4$: `d5 d1 d6 d7 d2 d3 d8 d4`
- **Parte D (sessão de grupo):** a marcar, com a ficha do projeto

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-26 15:41 · R version 4.6.1 (2026-06-24) · motor08 v2 2026-10-22 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `ap_k` | numeric | 8 | 0.8333, 0.8333, 1, 1, 1, 1, ... |
| `c1` | character | 1 | recuperacao de informacao |
| `c2` | character | 1 | busca de documentos |
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | manter |
| `cfg$stopwords` | character | 0 |  |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | numeric | 1 | 2 |
| `cfg$prf_k` | numeric | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `cfg$modelo` | character | 1 | bm25 |
| `cfg$lsa_k` | numeric | 1 | 2 |
| `cfg$rrf_c` | numeric | 1 | 60 |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `docs2` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 vetores como documentos rep..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `g` | numeric, nomeado | 8 | d1 1, d2 2, d3 2, d4 0, d5 0, d6 1, ... |
| `ix$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$N` | integer | 1 | 8 |
| `ix$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$postings` | list | 45 | elementos: recuperacao, de, informacao, ordena, documentos, por, relevancia, o, ... |
| `ix$dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, ... |
| `ix$avgdl` | numeric | 1 | 8 |
| `ix$idf_bm25` | numeric, nomeado | 45 | a 0.6931, acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, ... |
| `ix2$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix2$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix2$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix2$N` | integer | 1 | 8 |
| `ix2$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix2$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix2$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix2$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix2$postings` | list | 45 | elementos: recuperacao, de, informacao, ordena, documentos, por, relevancia, vetores, ... |
| `ix2$dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, ... |
| `ix2$avgdl` | numeric | 1 | 8 |
| `ix2$idf_bm25` | numeric, nomeado | 45 | a 0.6931, acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, ... |
| `ks` | integer | 8 | 1, 2, 3, 4, 5, 6, ... |
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
| `ord` | character | 8 | d1, d2, d3, d4, d5, d6, ... |
| `pv` | numeric, nomeado | 8 | d1 0.3333, d2 0, d3 0, d4 0, d5 0, d6 0.3333, ... |
| `px` | numeric, nomeado | 8 | d1 0, d2 1, d3 0.5, d4 0, d5 0, d6 0, ... |
| `qb` | character | 2 | documentos, busca |
| `qo` | character | 3 | ordenar, documentos, relevancia |
| `qt` | character | 3 | modelo, de, recuperacao |
| `qt3` | character | 3 | modelo, de, texto |
| `qv` | character | 3 | vetores, de, documentos |
| `r$rel` | integer | 8 | 1, 0, 1, 0, 0, 0, ... |
| `r$g` | numeric | 8 | 2, 1, 2, 0, 0, 1, ... |
| `r$R` | integer | 1 | 2 |
| `r1` | numeric, nomeado | 8 | d1 3.757, d4 1.427, d3 0.6542, d8 0.519, d6 0.4925, d2 0.4685, ... |
| `r2` | numeric, nomeado | 8 | d5 1.878, d1 1.25, d7 1.219, d6 1.186, d2 1.128, d3 0.6542, ... |
| `rb` | numeric, nomeado | 8 | d3 1.873, d1 1.869, d2 1.687, d4 1.427, d8 0.519, d6 0.4925, ... |
| `rbm` | numeric, nomeado | 8 | d5 1.878, d7 1.219, d1 0.7305, d6 0.6931, d2 0.6594, d3 0, ... |
| `rv` | numeric, nomeado | 8 | d2 2.833, d1 1.25, d6 1.186, d5 0.6594, d3 0.6542, d8 0.519, ... |
| `w1` | numeric, nomeado | 8 | d1 0, d2 1, d3 0, d4 0, d5 0, d6 0, ... |
| `w3` | numeric, nomeado | 8 | d1 0, d2 1, d3 0.5, d4 0, d5 0, d6 0, ... |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `proximidade`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `reordenar`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->
