# Consolidado — PI III — Aula 08 — Tema 8 (posição e título) — 26/11/2026

*guia do tema 8 versão 1 · tutora: Claude · motor08 (o motor09 ainda não estava publicado no repositório do curso; as funções `proximidade` e `reordenar` vieram do `aula08.ipynb` do grupo)*  

**Aluno / grupo:** Victor — Equipe FFV

## 1. O que foi passado

- M1 — bônus de início ($n = 3$): com `"modelo de recuperacao"`, `d1` 2, `d2` 2, `d8` 1 (o `de` conta, porque o `cfg_aula()` não tem stopwords). Checkpoint com `"dados de texto"`: `d1` 1, `d2` 1, `d3` 0, `d8` 2, conferido no R.
- M2 — $\text{BM25} + \beta \cdot \text{ini}$ com $\beta = 0{,}25$ e $k = 3$: o top-3 vira `d1 d2 d3` e o AP cai de $0{,}833$ para $0{,}583$ (RR de $1$ para $0{,}5$). A folga entre `d3` e `d1` era $0{,}0038$, então qualquer $\beta > 0{,}0019$ inverte os dois. Checkpoint com `"dados de texto"`: o ranking não muda (`d8 d3 d1`), e `d1` só passaria `d3` com $\beta > 1{,}84$.
- M3 — BM25F de brinquedo (repetir as 3 primeiras palavras): `d1` 2,502 · `d2` 2,378 · `d3` 1,895, com AP $0{,}583$, como no M2. O ganho de `d2` ($+0{,}691$) foi maior que o de `d1` ($+0{,}633$). Título inventado para os 8 documentos: `d1`, `d4` e `d7` recebem o mesmo bônus 2, e `d4` (grau 0) sobe de 4º para 2º só por dividir a página com `d1`. Checkpoint: com `d3` na página de `d8`, o top-3 não muda (`d8 d3 d1`), porque o título empata e vale o estágio 1.
- M4 — corpus do grupo (63 parágrafos; dev com 7 consultas, teste com 3). Referência no dev, só BM25: AP $0{,}635$ e nDCG graduado $0{,}724$. Grade do MAP no dev: `inicio`$0{,}635 / 0{,}635 / 0{,}624$; `titulo`$0{,}682 / 0{,}725 / 0{,}725$; `ambos`$0{,}682 / 0{,}725 / 0{,}706$ (para $k = 3, 5, 10$). **Escolha pelo dev: `titulo`, $k = 5$**, a menor intervenção entre os empates. Ajudou: `q07` ($0{,}367 \to 0{,}500$) e `q09` ($0{,}5 \to 1{,}0$); nenhuma consulta caiu. Atrapalhou (outra configuração): `inicio` com $k = 10$ em `q07` ($0{,}367 \to 0{,}292$), porque `Cubatao_p3` (etimologia, grau 0) entra na cabeça e passa os dois relevantes. **Teste, rodado uma vez:** AP $0{,}150 \to 0{,}150$ e nDCG graduado $0{,}325 \to 0{,}325$.
## 2. Como foi o aprendizado — opinião da tutora

Contou à mão em todos os módulos, e as contas (bônus, escores somados, AP de `q07` e `q09`) saíram certas antes do R. Entendeu bem a escala de $\beta$: viu que 0,25 não é pequeno perto de uma folga de 0,0038, mas é minúsculo perto de 1,84. Viu a armadilha do título com os próprios olhos, lendo os parágrafos de Cubatão. Quatro previsões erraram e foram corrigidas pelo R: a aposta de que `titulo` seria o campo de risco, a de que `d1` ganharia mais que `d2` no BM25F, a explicação de que `Santos_p15` lideraria por ser curto ou ter palavra rara (o IDF e o `dl` mostraram outra coisa: `ano` pesa $2{,}91$ e `cubatao` só $1{,}30$), e um `qt` antigo que ficou no ambiente e deu uma saída que parecia certa. Mostrou o bom hábito de checar o ambiente com `rm(list = ls())` e de não mexer na escolha depois do teste.

**Teste final:** acertou M1, M2 e M4; M3 acertou a ideia (as páginas cujo título casa sobem em bloco e, entre si, vale a ordem do estágio 1), com um detalhe a revisar.

## 3. Observações para a frente

- **Revisar:** (1) o título não faz parte do texto do parágrafo: ele vem de `origem`, separado, e é igual para todos os parágrafos da página; (2) antes de explicar um ranking, ler o IDF e o `dl`, em vez de supor; (3) conferir o objeto global (`qt`) antes de ler uma saída.
- **Diagnóstico do teste (só leitura, sem trocar campo nem $k$):** a hipótese de que os 5 primeiros seriam da mesma página e empatariam estava errada. Em `q01` e `q08` o título reordenou o top-5 (`Santos_p21` de 5º para 2º; `Guaruja_p6` de 4º para 1º), mas só entre documentos de grau 0; os relevantes estavam em 18º e 16º, fora do alcance de $k = 5$. Em `q04` ninguém citou uma página no título, todos empataram em 0 e nada mudou (o relevante já estava em 3º). Como a AP só depende da posição dos relevantes, ela ficou em $\frac{1}{3}\left(\frac{1}{18} + \frac{1}{3} + \frac{1}{16}\right) \approx 0{,}150$.
- **Perguntas guardadas:** (1) o estágio 2 só reordena a cabeça: se o relevante está em 16º ou 18º, nem $k = 10$ o alcança, e o gargalo é o estágio 1; (2) `polo industrial` aponta para Cubatão, mas o título só compara palavras e não sabe disso — fica para a Aula 09, sem decidir nada pelo teste.
- **Produzido:**`inicio`, `titulo`, `bonus_pos`, `rerank_pos`, `medir`; escolha do grupo no dev (`titulo`, $k = 5$) e teste rodado uma vez ($0{,}150 \to 0{,}150$). Com 7 consultas no dev, o ganho de $0{,}635 \to 0{,}725$ vem só de `q07` e `q09`, e 3 consultas no teste não permitem concluir.
---



## Estado do R ao fim da sessão

*gerado por `anexar_estado()` em 2026-11-27 01:00 · R version 4.6.1 (2026-06-24) · motor08 v2 2026-10-22 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
| --- | --- | --- | --- |
| `a` | character | 1 | qrels_consenso.csv |
| `antes$q02` | numeric, nomeado | 63 | Santos_p11 3.316, Santos_p14 3.076, Guaruja_p2 2.696, Santos_p12 2.674, Guaruja_p17 2.323, Guaruja_p15 1.98, ... |
| `antes$q03` | numeric, nomeado | 63 | Santos_p19 9.406, Santos_p18 8.731, Santos_p1 7.617, Santos_p17 3.799, Santos_p22 3.76, Guaruja_p18 3.483, ... |
| `antes$q05` | numeric, nomeado | 63 | Guaruja_p19 1.942, Guaruja_p12 1.854, Guaruja_p2 1.741, Guaruja_p9 1.737, Guaruja_p10 1.7, Guaruja_p3 1.601, ... |
| `antes$q06` | numeric, nomeado | 63 | Santos_p22 5.536, Santos_p23 4.772, Cubatao_p17 2.529, Santos_p21 1.238, Santos_p11 1.205, Santos_p18 1.133, ... |
| `antes$q07` | numeric, nomeado | 63 | Santos_p15 4.251, Cubatao_p1 3.295, Cubatao_p8 3.273, Cubatao_p4 2.996, Cubatao_p9 2.992, Cubatao_p18 2.883, ... |
| `antes$q09` | numeric, nomeado | 63 | Santos_p15 4.869, Cubatao_p20 4.294, Guaruja_p20 4.294, Cubatao_p1 3.151, Santos_p8 2.18, Santos_p9 2.112, ... |
| `antes$q10` | numeric, nomeado | 63 | Guaruja_p19 9.044, Guaruja_p10 2.322, Santos_p16 2.129, Guaruja_p4 2.03, Guaruja_p18 1.94, Guaruja_p12 1.854, ... |
| `antes_t$q01` | numeric, nomeado | 63 | Guaruja_p9 4.81, Santos_p15 3.657, Cubatao_p20 2.592, Guaruja_p20 2.592, Santos_p21 1.238, Santos_p11 1.205, ... |
| `antes_t$q04` | numeric, nomeado | 63 | Guaruja_p18 3.232, Cubatao_p11 3, Cubatao_p2 2.634, Santos_p19 2.413, Cubatao_p9 2.369, Santos_p1 0, ... |
| `antes_t$q08` | numeric, nomeado | 63 | Santos_p5 3.91, Cubatao_p3 3.362, Cubatao_p19 3.002, Guaruja_p6 2.821, Guaruja_p19 1.942, Guaruja_p12 1.854, ... |
| `ap_dev` | matrix | 2 × 7 | linhas: antes, depois | colunas: q02, q03, q05, q06, ... |
| `ap2` | numeric, nomeado | 7 | q02 0.5, q03 1, q05 0.07692, q06 1, q07 0.2917, q09 0.5, ... |
| `arqs` | character | 1 | qrels_consenso.csv |
| `c_esc` | character | 1 | titulo |
| `cfg$minimo` | numeric | 1 | 200 |
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | translit |
| `cfg$stopwords` | character | 203 | a, ao, aos, aquela, aquelas, aquele, ... |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | numeric | 1 | 2 |
| `cfg$juizes` | character | 1 | consenso |
| `cfg$prf_k` | numeric | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `cfg$modelo` | character | 1 | bm25 |
| `cfg$lsa_k` | numeric | 1 | 40 |
| `cfg$rrf_c` | numeric | 1 | 60 |
| `cfg$rerank_k` | numeric | 1 | 5 |
| `cfg$janela` | numeric | 1 | 5 |
| `cfg$grupo` | character | 1 | FFV |
| `consultas` | character, nomeado | 10 | q01 fundacao santos ano, q02 praias santos quantidade, q03 maior porto america latina, q04 polo industrial, q05 tamanho guaruja, q06 jogador santos futebol hist..., ... |
| `cp` | data.frame | 63 × 2 | colunas: id, texto |
| `depois_t$q01` | character | 63 | Santos_p15, Santos_p21, Guaruja_p9, Cubatao_p20, Guaruja_p20, Santos_p11, ... |
| `depois_t$q04` | character | 63 | Guaruja_p18, Cubatao_p11, Cubatao_p2, Santos_p19, Cubatao_p9, Santos_p1, ... |
| `depois_t$q08` | character | 63 | Guaruja_p6, Guaruja_p19, Santos_p5, Cubatao_p3, Cubatao_p19, Guaruja_p12, ... |
| `dev` | character | 7 | q02, q03, q05, q06, q07, q09, ... |
| `docs` | character, nomeado | 63 | Santos_p1 Santos é um município brasi..., Santos_p2 Fundada em 1546 por Brás Cu..., Santos_p3 Cidade mais populosa do lit..., Santos_p4 O principal cartão-postal d..., Santos_p5 Verificam-se relatos a resp..., Santos_p6 Em 1543, com o término da c..., ... |
| `grade` | matrix | 3 × 3 | linhas: k3, k5, k10 | colunas: inicio, titulo, ambos |
| `ix$tokens` | list | 63 | elementos: Santos_p1, Santos_p2, Santos_p3, Santos_p4, Santos_p5, Santos_p6, Santos_p7, Santos_p8, ... |
| `ix$vocab` | character | 1518 | 0, 000, 034, 041, 048, 1, ... |
| `ix$tf` | matrix | 1518 × 63 | linhas: 0, 000, 034, ... | colunas: Santos_p1, Santos_p2, Santos_p3, Santos_p4, ... |
| `ix$N` | integer | 1 | 63 |
| `ix$df` | numeric, nomeado | 1518 | 0 3, 000 3, 034 1, 041 1, 048 1, 1 8, ... |
| `ix$idf_tfidf` | numeric, nomeado | 1518 | 0 3.045, 000 3.045, 034 4.143, 041 4.143, 048 4.143, 1 2.064, ... |
| `ix$w` | matrix | 1518 × 63 | linhas: 0, 000, 034, ... | colunas: Santos_p1, Santos_p2, Santos_p3, Santos_p4, ... |
| `ix$wn` | matrix | 1518 × 63 | linhas: 0, 000, 034, ... | colunas: Santos_p1, Santos_p2, Santos_p3, Santos_p4, ... |
| `ix$postings` | list | 1518 | elementos: santos, municipio, brasileiro, litoral, estado, paulo, regiao, sudeste, ... |
| `ix$dl` | numeric, nomeado | 63 | Santos_p1 57, Santos_p2 62, Santos_p3 40, Santos_p4 65, Santos_p5 33, Santos_p6 59, ... |
| `ix$avgdl` | numeric | 1 | 43.21 |
| `ix$idf_bm25` | numeric, nomeado | 1518 | 0 2.906, 000 2.906, 034 3.753, 041 3.753, 048 3.753, 1 2.019, ... |
| `k_esc` | numeric | 1 | 5 |
| `m` | NULL | 0 |  |
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
| `nec` | data.frame | 10 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `origem` | character, nomeado | 63 | Santos_p1 Santos, Santos_p2 Santos, Santos_p3 Santos, Santos_p4 Santos, Santos_p5 Santos, Santos_p6 Santos, ... |
| `q` | character | 1 | q09 |
| `qrels$q01` | numeric, nomeado | 63 | Cubatao_p1 0, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 0, Cubatao_p13 0, Cubatao_p14 0, ... |
| `qrels$q02` | numeric, nomeado | 63 | Cubatao_p1 0, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 0, Cubatao_p13 0, Cubatao_p14 0, ... |
| `qrels$q03` | numeric, nomeado | 63 | Cubatao_p1 0, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 0, Cubatao_p13 0, Cubatao_p14 0, ... |
| `qrels$q04` | numeric, nomeado | 63 | Cubatao_p1 0, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 1, Cubatao_p13 0, Cubatao_p14 0, ... |
| `qrels$q05` | numeric, nomeado | 63 | Cubatao_p1 0, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 0, Cubatao_p13 0, Cubatao_p14 0, ... |
| `qrels$q06` | numeric, nomeado | 63 | Cubatao_p1 0, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 0, Cubatao_p13 0, Cubatao_p14 0, ... |
| `qrels$q07` | numeric, nomeado | 63 | Cubatao_p1 0, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 0, Cubatao_p13 0, Cubatao_p14 0, ... |
| `qrels$q08` | numeric, nomeado | 63 | Cubatao_p1 0, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 0, Cubatao_p13 0, Cubatao_p14 0, ... |
| `qrels$q09` | numeric, nomeado | 63 | Cubatao_p1 2, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 0, Cubatao_p13 0, Cubatao_p14 0, ... |
| `qrels$q10` | numeric, nomeado | 63 | Cubatao_p1 0, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 0, Cubatao_p13 0, Cubatao_p14 0, ... |
| `qt` | character | 3 | populacao, cubatao, censo |
| `R_q` | integer, nomeado | 10 | q01 1, q02 1, q03 3, q04 1, q05 1, q06 1, ... |
| `REPO` | character | 1 | https://raw.githubuserconte... |
| `stopwords_pt` | character | 203 | a, ao, aos, aquela, aquelas, aquele, ... |
| `tab_q07` | data.frame | 10 × 5 | colunas: doc, pagina, grau, antes, depois |
| `teste` | character | 3 | q01, q04, q08 |
| `usar` | character | 10 | q01, q02, q03, q04, q05, q06, ... |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `bonus_pos`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `estagio1`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `inicio`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `medir`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `proximidade`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `reordenar`, `rerank_pos`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `titulo`, `tokenizar`, `ver`, `vetor_consulta`