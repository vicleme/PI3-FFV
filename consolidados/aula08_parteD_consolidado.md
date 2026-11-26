# Consolidado — PI III — Aula 08 — Parte D — 2026-11-26
*guia versão 2 · tutora: Claude · sessão de grupo · motor08*
**Grupo:** FFV · **presentes:** Victor, Flávia e Felipe · **digitou:** Flávia (Módulo 7), Victor (Módulo 8), Felipe (Módulo 9)

## 1. O que foi feito
- M7 — `proximidade` e `reordenar` copiadas e testadas (`0,5`; `b a c`); estágio 1 = BM25 (`cfg$modelo`); top-5 antes × depois na q03 (desenvolvimento), com $k = 10$ e janela 3, lendo `Santos_p19`, `Santos_p18` e `Santos_p1`
- M8 — grade $k \in \{3, 5, 10\}$ × janela $\in \{2, 3, 5\}$ nas 7 consultas de desenvolvimento; escolha no desenvolvimento; leitura da q02 (ganho) e da q05 (fora do alcance); teste relatado uma vez
- M9 — decisão $k = 5$, janela 5; `config.R` recarregado (`5` e `5`); `ranking_final` na q03

## 2. Como o grupo trabalhou — opinião da tutora
Copiaram as funções, rodaram os testes e acertaram por que o `c` não sobe no `reordenar`: o estágio 2 só relê a cabeça. Leram os textos da q03 e da q02 em vez de ficar nos números, e separaram "fala do porto" de "responde à pergunta". Escolheram no desenvolvimento e relataram o teste uma vez, como saiu ($0{,}150 \to 0{,}150$), sem mexer em nada depois; a decisão saiu do grupo, em uma frase, com os três de acordo. As respostas vieram em uma voz só, com revezamento na digitação, então não sei quem entendeu cada ponto. Os tropeços foram corrigidos ao ver o dado: leram $4{,}333$ como proximidade baixa, quando é o máximo para 4 termos; apostaram o terceiro relevante da q03 fora do top-10, e estava no top-3; e afirmaram que a reordenação "alinhou com quem responde", quando o gabarito dá grau 2 aos três. Previram pouco ganho na grade e o MAP foi de $0{,}635$ a $0{,}725$. A explicação do ganho da q07 pela janela 5 passou sem conferência, e a falha também foi minha: pela grade, o ganho de $0{,}133$ já aparece com janela 2 e 3 em $k = 5$, então parece vir do $k$ e não da janela. Isso foi conferido na tarefa, depois da sessão: com o top-10 da q07 e a proximidade de cada documento, o ganho vem do $k$ (de 3 para 5), porque `Cubatao_p9` (grau 2) sobe de 5º para 2º ao entrar no recorte, já com janela 2. A mesma tabela mostrou o lado frágil: `Cubatao_p1` (1º, proximidade $1{,}00$) e `Cubatao_p18` (3º com $k = 10$), ambos de grau 0, subiram por termos próximos ou iniciais, e a queda para $0{,}450$ em $k = 10$ vem daí. Na tarefa, a prosa da q02, da q07 e da q05 também foi escrita e conferida contra o corpus.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 09):** `config.R` (com `rerank_k = 5` e `janela = 5`), `aula08.ipynb`, a ficha e os consolidados no GitHub; a Aula 09 reusa a `proximidade` como sinal. Quem envia o quê: o grupo não definiu na sessão.
- **Perguntas guardadas:** nenhuma.
- **Produzido:** ver a entrada "Aula 08" na linha do tempo da ficha do projeto; análise em prosa (q02, q07, q05) na seção 6 da ficha, com a nota sobre documentos de grau 0 elevados pela proximidade; falta levá-la ao relatório
- **Ficha atualizada:** sim — seções alteradas: 5, 6 (incluindo a análise da Aula 08), 7, cabeçalho

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-26 18:59 · R version 4.6.1 (2026-06-24) · motor08 v2 2026-10-22 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `a` | character | 1 | qrels_consenso.csv |
| `ap0` | numeric, nomeado | 7 | q02 0.5, q03 1, q05 0.07692, q06 1, q07 0.3667, q09 0.5, ... |
| `ap1` | numeric, nomeado | 7 | q02 1, q03 1, q05 0.07692, q06 1, q07 0.5, q09 0.5, ... |
| `arqs` | character | 1 | qrels_consenso.csv |
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
| `d` | character | 3 | Santos_p1, Santos_p18, Santos_p19 |
| `dev` | character | 7 | q02, q03, q05, q06, q07, q09, ... |
| `docs` | character, nomeado | 63 | Santos_p1 Santos é um município brasi..., Santos_p2 Fundada em 1546 por Brás Cu..., Santos_p3 Cidade mais populosa do lit..., Santos_p4 O principal cartão-postal d..., Santos_p5 Verificam-se relatos a resp..., Santos_p6 Em 1543, com o término da c..., ... |
| `grade` | matrix | 3 × 3 | linhas: k3, k5, k10 \| colunas: janela2, janela3, janela5 |
| `grade_q07` | matrix | 3 × 3 | linhas: k3, k5, k10 \| colunas: janela2, janela3, janela5 |
| `ix$tokens` | list | 63 | elementos: Santos_p1, Santos_p2, Santos_p3, Santos_p4, Santos_p5, Santos_p6, Santos_p7, Santos_p8, ... |
| `ix$vocab` | character | 1518 | 0, 000, 034, 041, 048, 1, ... |
| `ix$tf` | matrix | 1518 × 63 | linhas: 0, 000, 034, ... \| colunas: Santos_p1, Santos_p2, Santos_p3, Santos_p4, ... |
| `ix$N` | integer | 1 | 63 |
| `ix$df` | numeric, nomeado | 1518 | 0 3, 000 3, 034 1, 041 1, 048 1, 1 8, ... |
| `ix$idf_tfidf` | numeric, nomeado | 1518 | 0 3.045, 000 3.045, 034 4.143, 041 4.143, 048 4.143, 1 2.064, ... |
| `ix$w` | matrix | 1518 × 63 | linhas: 0, 000, 034, ... \| colunas: Santos_p1, Santos_p2, Santos_p3, Santos_p4, ... |
| `ix$wn` | matrix | 1518 × 63 | linhas: 0, 000, 034, ... \| colunas: Santos_p1, Santos_p2, Santos_p3, Santos_p4, ... |
| `ix$postings` | list | 1518 | elementos: santos, municipio, brasileiro, litoral, estado, paulo, regiao, sudeste, ... |
| `ix$dl` | numeric, nomeado | 63 | Santos_p1 57, Santos_p2 62, Santos_p3 40, Santos_p4 65, Santos_p5 33, Santos_p6 59, ... |
| `ix$avgdl` | numeric | 1 | 43.21 |
| `ix$idf_bm25` | numeric, nomeado | 1518 | 0 2.906, 000 2.906, 034 3.753, 041 3.753, 048 3.753, 1 2.019, ... |
| `j_esc` | numeric | 1 | 5 |
| `k_esc` | numeric | 1 | 5 |
| `m` | NULL | 0 |  |
| `map0` | numeric | 1 | 0.6348 |
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
| `nec` | data.frame | 10 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `origem` | character, nomeado | 63 | Santos_p1 Santos, Santos_p2 Santos, Santos_p3 Santos, Santos_p4 Santos, Santos_p5 Santos, Santos_p6 Santos, ... |
| `prox7` | numeric, nomeado | 10 | Santos_p15 0, Cubatao_p1 1, Cubatao_p8 0, Cubatao_p4 0, Cubatao_p9 0.5, Cubatao_p18 0.25, ... |
| `q` | character | 1 | q02 |
| `q7` | character | 1 | q07 |
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
| `qt` | character | 4 | maior, porto, america, latina |
| `qt7` | character | 4 | cubatao, virou, municipio, ano |
| `qts$q01` | character | 3 | fundacao, santos, ano |
| `qts$q02` | character | 3 | praias, santos, quantidade |
| `qts$q03` | character | 4 | maior, porto, america, latina |
| `qts$q04` | character | 2 | polo, industrial |
| `qts$q05` | character | 2 | tamanho, guaruja |
| `qts$q06` | character | 4 | jogador, santos, futebol, historia |
| `qts$q07` | character | 4 | cubatao, virou, municipio, ano |
| `qts$q08` | character | 3 | significado, nome, guaruja |
| `qts$q09` | character | 3 | populacao, cubatao, censo |
| `qts$q10` | character | 4 | travessia, balsa, santos, guaruja |
| `R_q` | integer, nomeado | 10 | q01 1, q02 1, q03 3, q04 1, q05 1, q06 1, ... |
| `r5` | character | 1 | Guaruja_p1 |
| `rel` | character | 3 | Santos_p1, Santos_p18, Santos_p19 |
| `REPO` | character | 1 | https://raw.githubuserconte... |
| `rk` | numeric, nomeado | 63 | Santos_p19 9.406, Santos_p18 8.731, Santos_p1 7.617, Santos_p17 3.799, Santos_p22 3.76, Guaruja_p18 3.483, ... |
| `rk7` | numeric, nomeado | 63 | Santos_p15 4.251, Cubatao_p1 3.295, Cubatao_p8 3.273, Cubatao_p4 2.996, Cubatao_p9 2.992, Cubatao_p18 2.883, ... |
| `rks$q01` | numeric, nomeado | 63 | Guaruja_p9 4.81, Santos_p15 3.657, Cubatao_p20 2.592, Guaruja_p20 2.592, Santos_p21 1.238, Santos_p11 1.205, ... |
| `rks$q02` | numeric, nomeado | 63 | Santos_p11 3.316, Santos_p14 3.076, Guaruja_p2 2.696, Santos_p12 2.674, Guaruja_p17 2.323, Guaruja_p15 1.98, ... |
| `rks$q03` | numeric, nomeado | 63 | Santos_p19 9.406, Santos_p18 8.731, Santos_p1 7.617, Santos_p17 3.799, Santos_p22 3.76, Guaruja_p18 3.483, ... |
| `rks$q04` | numeric, nomeado | 63 | Guaruja_p18 3.232, Cubatao_p11 3, Cubatao_p2 2.634, Santos_p19 2.413, Cubatao_p9 2.369, Santos_p1 0, ... |
| `rks$q05` | numeric, nomeado | 63 | Guaruja_p19 1.942, Guaruja_p12 1.854, Guaruja_p2 1.741, Guaruja_p9 1.737, Guaruja_p10 1.7, Guaruja_p3 1.601, ... |
| `rks$q06` | numeric, nomeado | 63 | Santos_p22 5.536, Santos_p23 4.772, Cubatao_p17 2.529, Santos_p21 1.238, Santos_p11 1.205, Santos_p18 1.133, ... |
| `rks$q07` | numeric, nomeado | 63 | Santos_p15 4.251, Cubatao_p1 3.295, Cubatao_p8 3.273, Cubatao_p4 2.996, Cubatao_p9 2.992, Cubatao_p18 2.883, ... |
| `rks$q08` | numeric, nomeado | 63 | Santos_p5 3.91, Cubatao_p3 3.362, Cubatao_p19 3.002, Guaruja_p6 2.821, Guaruja_p19 1.942, Guaruja_p12 1.854, ... |
| `rks$q09` | numeric, nomeado | 63 | Santos_p15 4.869, Cubatao_p20 4.294, Guaruja_p20 4.294, Cubatao_p1 3.151, Santos_p8 2.18, Santos_p9 2.112, ... |
| `rks$q10` | numeric, nomeado | 63 | Guaruja_p19 9.044, Guaruja_p10 2.322, Santos_p16 2.129, Guaruja_p4 2.03, Guaruja_p18 1.94, Guaruja_p12 1.854, ... |
| `rn` | character | 63 | Santos_p18, Santos_p1, Santos_p19, Santos_p17, Santos_p22, Guaruja_p18, ... |
| `rn7_k10` | character | 63 | Cubatao_p1, Cubatao_p9, Cubatao_p18, Santos_p15, Cubatao_p8, Cubatao_p4, ... |
| `rn7_k5` | character | 63 | Cubatao_p1, Cubatao_p9, Santos_p15, Cubatao_p8, Cubatao_p4, Cubatao_p18, ... |
| `stopwords_pt` | character | 203 | a, ao, aos, aquela, aquelas, aquele, ... |
| `tab_teste` | matrix | 2 × 3 | linhas: estagio1, rerank \| colunas: q01, q04, q08 |
| `teste` | character | 3 | q01, q04, q08 |
| `top10_7` | character | 10 | Santos_p15, Cubatao_p1, Cubatao_p8, Cubatao_p4, Cubatao_p9, Cubatao_p18, ... |
| `usar` | character | 10 | q01, q02, q03, q04, q05, q06, ... |

### Funções definidas

`anexar_estado`, `ap`, `ap_rerank`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `estagio1`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `proximidade`, `ranking_bm25`, `ranking_cosseno`, `ranking_final`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `reordenar`, `rerank_prox`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

