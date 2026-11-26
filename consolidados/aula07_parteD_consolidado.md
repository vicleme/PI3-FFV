# Consolidado, PI III, Aula 07, Parte D, 2026-11-25
*guia versão 2 · tutora: Claude · sessão de grupo · motor07*
**Grupo:** FFV · **presentes:** Victor, Flávia e Felipe · **digitou:** Victor (Módulo 7), Flávia (Módulo 8), Felipe (Módulo 9)

## 1. O que foi feito
- M7: LSA com $k = 20$ no corpus de 63 parágrafos (energia $0{,}486$). Na q10, os top-5 do BM25 e do LSA têm 1 documento em comum (`Guaruja_p19`). `Cubatao_p9` e `Cubatao_p4`, que só o LSA trouxe, não têm palavra alguma da consulta: ruído. O BM25 trouxe `Guaruja_p10` por "guaruja" e pelo "Santos" de Santos Dumont. Todos os oito, fora o comum, têm grau 0.
- M8: grade $k = 5, 10, 20, 40$. MAP de desenvolvimento: BM25 $0{,}635$; LSA $0{,}204$, $0{,}494$, $0{,}527$, $0{,}570$; híbrido $0{,}524$, $0{,}560$, $0{,}579$, $0{,}603$. Com $k = 40$, o LSA perde para o BM25 em 4 consultas (q02, q05, q07, q09) e o híbrido em 3 (q02, q05, q07); nenhum ganha em consulta alguma. Lidas a q02 (`Guaruja_p2` passou `Santos_p14` por $0{,}0003$ na RRF) e a q05 (`Guaruja_p1` diz "área" e "km²", não "tamanho"; o híbrido com $k = 20$ subiu uma posição). Escolha no desenvolvimento: BM25. Teste rodado uma vez: MAP $0{,}150$ (q01 $0{,}056$; q04 $0{,}333$; q08 $0{,}062$).
- M9: decisão de ficar com o BM25, com `modelo = "bm25"`, `lsa_k = 40` e `rrf_c = 60` no `config.R` (os dois últimos registram o que foi testado). O top-5 do `ranking_motor` na q07 conferiu com o AP do BM25 na tabela ($0{,}367$). Ficha atualizada.

## 2. Como o grupo trabalhou, opinião da tutora
Trabalhei com os três, um por módulo, e as respostas vieram por escrito numa voz só, então sei quem digitou cada módulo, não quem pensou cada resposta. As funções `lsa`, `ranking_lsa` e `rrf` vieram da teoria, como o guia pede, e `ranking_modelo` e `ap_modelo` vieram do guia. O que foi do grupo: trocaram a grade de $k$ por conta própria (5, 10, 20 e 40) e justificaram, leram os textos do top-5 antes de concluir, e acertaram o diagnóstico de cada caso lido (ruído do LSA na q10, vocabulário diferente na q05). Várias previsões bateram (o MAP do BM25, o LSA abaixo do BM25 em todo $k$, quais consultas perdem), e outras precisaram de ajuste: a interseção da q10 (previram 2, foram 1), as palavras da consulta nos quatro documentos (previram 3, foram 2), a distância entre `Guaruja_p2` e `Santos_p14` no LSA, e o MAP de teste (previram de $0{,}45$ a $0{,}55$, deu $0{,}150$). Explicaram sozinhos por que o `lsa(ix, cfg$lsa_k)` não é calculado com `"bm25"`. A escolha saiu do desenvolvimento, com a frase escrita antes do teste, e o grupo não quis mexer nela depois. Na primeira versão da análise em prosa houve dois deslizes (misturar $k = 40$ com $k = 20$ e explicar a q05 sem ter lido o texto); os dois foram corrigidos depois da leitura. A decisão está bem sustentada, mas depende de 7 consultas de desenvolvimento e de uma grade que parou em $k = 40$, e a queda para $0{,}150$ no teste não se explica com os dados que há.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 08):** o `config.R` editado (com `modelo`, `lsa_k`, `rrf_c`, `prf_k` e `rocchio`) e o `aula07.ipynb` precisam estar no repositório. O briefing da Aula 08 deve trazer a nota: mostrar vetores nomeados em tabela, com `rbind(...)` ou `cbind(...)` e `round(..., 3)`. O teste já foi usado uma vez ($0{,}150$); a Aula 08 não deve ajustar nada olhando para ele.
- **Perguntas guardadas:** "a diferença entre os modelos é significativa?" para a Aula 16. Pista para a Aula 08: na q02, o relevante é o que traz o número ("6 praias"), e nenhum modelo da aula sabe que "quantidade" pede um número.
- **Produzido:** ver a entrada "Aula 07" na linha do tempo da ficha do projeto
- **Ficha atualizada:** sim, seções alteradas: 5, 6, 7 e cabeçalho

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-26 00:54 · R version 4.6.1 (2026-06-24) · motor07 v1 2026-10-15 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `a` | character | 1 | qrels_consenso.csv |
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
| `cfg$grupo` | character | 1 | FFV |
| `consultas` | character, nomeado | 10 | q01 fundacao santos ano, q02 praias santos quantidade, q03 maior porto america latina, q04 polo industrial, q05 tamanho guaruja, q06 jogador santos futebol hist..., ... |
| `cp` | data.frame | 63 × 2 | colunas: id, texto |
| `dev` | character | 7 | q02, q03, q05, q06, q07, q09, ... |
| `docs` | character, nomeado | 63 | Santos_p1 Santos é um município brasi..., Santos_p2 Fundada em 1546 por Brás Cu..., Santos_p3 Cidade mais populosa do lit..., Santos_p4 O principal cartão-postal d..., Santos_p5 Verificam-se relatos a resp..., Santos_p6 Em 1543, com o término da c..., ... |
| `escolha` | character | 1 | bm25 |
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
| `ks` | numeric | 4 | 5, 10, 20, 40 |
| `m20$U` | matrix | 1518 × 20 | linhas: 0, 000, 034, ... \| colunas: (sem nomes) |
| `m20$S` | numeric | 20 | 41.45, 36.82, 34.11, 33.36, 31.35, 30.9, ... |
| `m20$D` | matrix | 63 × 20 | linhas: Santos_p1, Santos_p2, Santos_p3, ... \| colunas: (sem nomes) |
| `MOTOR_VERSAO` | character | 1 | motor07 v1 2026-10-15 |
| `ms$k5` | list | 3 | elementos: U, S, D |
| `ms$k10` | list | 3 | elementos: U, S, D |
| `ms$k20` | list | 3 | elementos: U, S, D |
| `ms$k40` | list | 3 | elementos: U, S, D |
| `nec` | data.frame | 10 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `origem` | character, nomeado | 63 | Santos_p1 Santos, Santos_p2 Santos, Santos_p3 Santos, Santos_p4 Santos, Santos_p5 Santos, Santos_p6 Santos, ... |
| `q` | character | 1 | q05 |
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
| `R_q` | integer, nomeado | 10 | q01 1, q02 1, q03 3, q04 1, q05 1, q06 1, ... |
| `rb` | numeric, nomeado | 63 | Guaruja_p19 1.942, Guaruja_p12 1.854, Guaruja_p2 1.741, Guaruja_p9 1.737, Guaruja_p10 1.7, Guaruja_p3 1.601, ... |
| `rel` | character | 1 | Guaruja_p1 |
| `REPO` | character | 1 | https://raw.githubuserconte... |
| `rh` | numeric, nomeado | 63 | Guaruja_p19 0.03227, Guaruja_p2 0.03227, Guaruja_p9 0.03175, Guaruja_p12 0.03151, Guaruja_p3 0.03078, Guaruja_p10 0.02967, ... |
| `rl` | numeric, nomeado | 63 | Guaruja_p2 0.7699, Santos_p11 0.5374, Santos_p14 0.5073, Guaruja_p15 0.4087, Santos_p12 0.3727, Guaruja_p9 0.3326, ... |
| `s$d` | numeric | 63 | 41.45, 36.82, 34.11, 33.36, 31.35, 30.9, ... |
| `s$u` | matrix | 1518 × 63 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `s$v` | matrix | 63 × 63 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `so_bm25` | character | 4 | Guaruja_p10, Santos_p16, Guaruja_p4, Guaruja_p18 |
| `so_lsa` | character | 4 | Cubatao_p8, Guaruja_p2, Cubatao_p9, Cubatao_p4 |
| `stopwords_pt` | character | 203 | a, ao, aos, aquela, aquelas, aquele, ... |
| `tab_dev` | matrix | 9 × 7 | linhas: bm25, lsa.k5, lsa.k10, ... \| colunas: q02, q03, q05, q06, ... |
| `tab_teste` | matrix | 2 × 3 | linhas: bm25, escolhido \| colunas: q01, q04, q08 |
| `teste` | character | 3 | q01, q04, q08 |
| `usar` | character | 10 | q01, q02, q03, q04, q05, q06, ... |

### Funções definidas

`anexar_estado`, `ap`, `ap_modelo`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_modelo`, `ranking_motor`, `ranking_vetor`, `recall_k`, `relevancia`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

