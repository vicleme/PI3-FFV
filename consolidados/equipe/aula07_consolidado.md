# Consolidado: PI III, Aula 07, 2026-11-25
*guia versão 2 · tutora: Claude · sessão de equipe (teoria) · motor07*
**Equipe:** Victor, Flávia e Felipe · digitaram em revezamento

## 1. O que foi passado
- M1, descasamento de vocabulário: "busca", "ranqueamento", "buscar" (vetor nulo, ordem do corpus), "ordenar documentos"
- M2, esparso × denso: `d1` com 7 de 45 coordenadas; fração não nula $0{,}172$; hipótese distribucional
- M3, LSA: $W = U\,\Sigma\,V^{\top}$; energia $0{,}170$ com $k = 1$, $0{,}323$ com $k = 2$, $0{,}459$ com $k = 3$; $k = 6$ para $80\%$
- M4, consulta dobrada $(-0{,}370;\ 0{,}445)$ com a primeira coordenada à mão; AP $1$; tabela de $k$ ($2$, $3$, $4$, $8$); cosseno negativo do `d7`
- M5, limites do LSA: `d4` em 1º para "busca" (ruído) e `d1` de $0$ a $0{,}967$ (ganho), mesmo mecanismo; `d3` × `d8` de $0{,}058$ a $1$; com $k = 8$ só `d3` pontua
- M6, RRF: `d1` e `d2` à mão; híbrido com nDCG graduado $0{,}990$; `d6` à mão ($0{,}0308$, 5º)

## 2. Como foi o aprendizado: opinião da tutora
A equipe respondeu com uma voz só, por escrito, então não sei quem respondeu cada pergunta. Fizeram à mão a energia com $k = 2$ e $k = 3$, a primeira coordenada da consulta dobrada, o cosseno do `d7`, a AP e o $\text{P@}3$, e a RRF do `d1`, do `d2` e do `d6`. Ao pedir a saída do `docs`, vieram com a objeção de que a saída crua estava ilegível, e passamos a usar `data.frame`. As funções `lsa`, `ranking_lsa` e `rrf` vieram prontas da minha apresentação, no ciclo de mostrar, prever e rodar. Nas previsões, houve acertos e alguns reparos: disseram que a fração não nula seria "até mais baixa" que $0{,}1$ (deu $0{,}172$); previram `d5` e `d7` nas duas primeiras posições de "busca" (o 1º foi `d4`); citaram uma palavra em comum entre `d3` e `d8` (eram duas, `e` e `de`); e pontuaram o `d2` como principal vizinho do `d3` em "ranqueamento", quando quem empatou foi o `d8`. Chegaram sozinhos à objeção de método sobre escolher $k$ com uma só consulta e ao mecanismo único de ganho e ruído. Explicaram por que o cosseno do LSA pode ser negativo e por que $k = 8$ devolve a ordem do léxico. Pediram uma definição mais elaborada da LSA no meio da sessão, e eu a dei.

**Teste final:** acertaram M1, M2, M3, M4, M5 e M6. Nenhum módulo para revisão no teste.

## 3. Observações para a frente
- **Revisar antes da Aula 08:** nada vindo do teste. Dois pontos de atenção das previsões: ler o texto dos documentos antes de afirmar quais palavras têm em comum, e conferir o tamanho do vetor antes de rodar. As revisões pendentes da Aula 06 não apareceram nos Módulos 4 e 6.
- **Para a próxima tutora:** a equipe é confortável com matrizes e com o R, prevê antes de rodar e mostra as contas passo a passo. Funciona melhor com saída em tabela e com um passo por mensagem.
- **Perguntas guardadas:** "A diferença entre os modelos é significativa?" para a Aula 16.
- **Produzido:** `lsa`, `ranking_lsa`, `rrf`; LSA $k = 2$: `d2 d3 d8 d6 d5 d1 d4 d7`; híbrido: `d3 d2 d1 d8 d6 d4 d5 d7`; comparação cosseno × BM25 × LSA × híbrido (AP $0{,}5$ / $0{,}833$ / $1$ / $1$; nDCG graduado $0{,}837$ / $0{,}951$ / $0{,}966$ / $0{,}990$)
- **Parte D (sessão de grupo):** a marcar, com a ficha do projeto

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-25 21:33 · R version 4.6.1 (2026-06-24) · motor07 v1 2026-10-15 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `b` | numeric, nomeado | 8 | d4 0.9985, d7 0.9822, d1 0.967, d5 0.9418, d6 0.5661, d2 0.1487, ... |
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | manter |
| `cfg$stopwords` | character | 0 |  |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | numeric | 1 | 2 |
| `cfg$prf_k` | numeric | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
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
| `ks` | numeric | 4 | 2, 3, 4, 8 |
| `m2$U` | matrix | 45 × 2 | linhas: a, acelera, aprendizado, ... \| colunas: (sem nomes) |
| `m2$S` | numeric | 2 | 5.602, 5.313 |
| `m2$D` | matrix | 8 × 2 | linhas: d1, d2, d3, ... \| colunas: (sem nomes) |
| `m8$U` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: (sem nomes) |
| `m8$S` | numeric | 8 | 5.602, 5.313, 5.022, 4.783, 4.672, 4.522, ... |
| `m8$D` | matrix | 8 × 8 | linhas: d1, d2, d3, ... \| colunas: (sem nomes) |
| `MOTOR_VERSAO` | character | 1 | motor07 v1 2026-10-15 |
| `q0` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `qk` | matrix | 2 × 1 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `r` | numeric, nomeado | 8 | d8 0.9993, d3 0.9993, d2 0.9489, d6 0.7154, d5 0.1702, d1 0.08584, ... |
| `r2` | numeric, nomeado | 8 | d2 1, d3 0.9596, d8 0.9596, d6 0.8999, d5 0.4736, d1 0.3971, ... |
| `r8` | numeric, nomeado | 8 | d3 0.9923, d2 1.25e-15, d7 4.843e-16, d1 3.923e-16, d4 2.706e-16, d6 -4.283e-16, ... |
| `rb` | numeric, nomeado | 8 | d3 1.873, d1 1.869, d2 1.687, d4 1.427, d8 0.519, d6 0.4925, ... |
| `rc` | numeric, nomeado | 8 | d1 0.2539, d3 0.2327, d4 0.2148, d2 0.2078, d6 0.02485, d8 0.02295, ... |
| `rh` | numeric, nomeado | 8 | d3 0.03252, d2 0.03227, d1 0.03128, d8 0.03126, d6 0.03078, d4 0.03055, ... |
| `s$d` | numeric | 8 | 5.602, 5.313, 5.022, 4.783, 4.672, 4.522, ... |
| `s$u` | matrix | 45 × 8 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `s$v` | matrix | 8 × 8 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `tab` | matrix | 4 × 5 | linhas: k=2, k=3, k=4, ... \| colunas: P_at_k, AP, RR, nDCG_bin, ... |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

