# Consolidado: PI III, Aula 06, 2026-11-24

*guia versão 1 · tutora: Claude · sessão individual (teoria) · motor06*  

**Aluno:** Victor

## 1. O que foi passado

- M1: o ciclo de realimentação; $D_r$ e $D_{nr}$ no ranking do cosseno
- M2: a consulta como vetor; centroide; `rowMeans`, `drop = FALSE`
- M3: a fórmula de Rocchio; `modelo` = 2,426 à mão; expansão: 3 para 21 termos
- M4: o novo ranking; cosseno negativo; AP $0{,}5 \to 1$; `pmax`
- M5: coleção residual: `NA` com limiar 2, empate com limiar 1, ganho real com só `d3` marcado
- M6: pseudo-realimentação; $k = 1$ (AP $0{,}417$), $k = 2$ (AP $0{,}833$), $k = 3$ (AP $0{,}750$): *drift*
## 2. Como foi o aprendizado: opinião da tutora

Minha leitura: o aluno aprende bem quando faz a conta à mão e vê o número aparecer no R, e perde o fio quando o termo é novo ou quando passa muito tempo parado. A sessão começou em um dia e foi retomada posteriormente, e ele recuperou o ritmo em passos pequenos. Fez o centroide à mão e acertou, reparou sozinho que o zero de `espaco` era o ponto importante, e previu certo o ranking, a queda do `d4`, o AP subindo e a direção do *drift*. Os tropeços foram de atenção e de leitura da fórmula: esqueceu o $\gamma$ numa conta e digitou 1,3786 no lugar de 1,386, e três vezes usou o $R$ como denominador da precisão, quando o denominador é a posição. Também inverteu a relação entre grau e limiar (relevante é grau $\geq$ limiar). Pediu explicação quando o termo era novo ("de onde vem `ix$w`?", "que usuário?") e avisou quando a saída do R estava feia, o que melhorou a sessão. A explicação de por que a consulta cresce de 3 para 21 termos só saiu depois de ele ver um termo concreto na tela e preencher uma frase com lacunas. O que foi entregue em vez de construído: a formulação da resposta da pergunta 5 do teste, que ele não conseguiu montar e que eu escrevi com lacunas para ele completar.

**Teste final:** acertou M2, M3 e M6; a revisar M1, M4 e M5.

- M1: $D_r$ certo, mas pôs o `d1` (grau 1) em $D_{nr}$; o grau 1 fica sem marca.
- M4: achou o termo `a` olhando a tabela de produtos, com apoio; o sinal do cosseno vem do produto escalar.
- M5: reconheceu o viés, mas não montou a objeção nem lembrou o nome "coleção residual".
## 3. Observações para a frente

- **Revisar antes da Aula 07:** (1) quem entra em $D_r$, em $D_{nr}$ e quem fica sem marca; (2) na precisão, o denominador é a posição, e só entram as posições dos relevantes; (3) a coleção residual: o que é e por que a avaliação completa é otimista.
- **Para a próxima tutora:** passos pequenos, uma conta por mensagem. Termos técnicos explicados antes de usar. Saída de código sempre em tabela (`data.frame`), nunca vetor quebrado. Texto sem travessão. Conferir o denominador da precisão e a relação entre grau e limiar. Retomadas depois de muito tempo pedem um resumo do fio antes de continuar.
- **Perguntas guardadas:** nenhuma.
- **Produzido:**`rocchio`, `ranking_vetor`; ranking Rocchio `d3 d2 d1 d6 d8 d5 d7 d4`; residual: empate com os três marcados, ganho com só `d3` marcado; PRF com $k = 1$, $k = 2$ e $k = 3$.
- **Parte D (sessão de grupo):** a marcar, com a ficha do projeto.
---



## Estado do R ao fim da sessão

*gerado por `anexar_estado()` em 2026-11-25 00:02 · R version 4.6.1 (2026-06-24) · motor06 v2 2026-10-08 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
| --- | --- | --- | --- |
| `b_a` | numeric, nomeado | 6 | d1 0.2539, d2 0.2078, d6 0.02485, d8 0.02295, d5 0, d7 0 |
| `b_res` | numeric, nomeado | 5 | d1 0.2539, d6 0.02485, d8 0.02295, d5 0, d7 0 |
| `base` | numeric, nomeado | 8 | d1 0.2539, d3 0.2327, d4 0.2148, d2 0.2078, d6 0.02485, d8 0.02295, ... |
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | manter |
| `cfg$stopwords` | character | 0 |  |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | numeric | 1 | 2 |
| `cr` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 1.04, busca 0, ... |
| `cr3` | numeric, nomeado | 45 | a 0.231, acelera 0, aprendizado 0.6931, avaliacao 0, bm25 0.6931, busca 0, ... |
| `d4` | numeric, nomeado | 45 | a 0.6931, acelera 0, aprendizado 2.079, avaliacao 0, bm25 0, busca 0, ... |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `docs3` | character | 3 | d2, d3, d4 |
| `fora` | character | 3 | d2, d3, d4 |
| `fora_a` | character | 2 | d3, d4 |
| `g_a` | numeric, nomeado | 6 | d1 1, d2 2, d5 0, d6 1, d7 0, d8 0 |
| `g_res` | numeric, nomeado | 5 | d1 1, d5 0, d6 1, d7 0, d8 0 |
| `grau` | numeric, nomeado | 8 | d1 1, d2 2, d3 2, d4 0, d5 0, d6 1, ... |
| `ix$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... | colunas: d1, d2, d3, d4, ... |
| `ix$N` | integer | 1 | 8 |
| `ix$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... | colunas: d1, d2, d3, d4, ... |
| `ix$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... | colunas: d1, d2, d3, d4, ... |
| `ix$postings` | list | 45 | elementos: recuperacao, de, informacao, ordena, documentos, por, relevancia, o, ... |
| `ix$dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, ... |
| `ix$avgdl` | numeric | 1 | 8 |
| `ix$idf_bm25` | numeric, nomeado | 45 | a 0.6931, acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, ... |
| `m` | numeric, nomeado | 5 | P_at_k 0.3333, AP 0.5, RR 0.5, nDCG_bin 0.6509, nDCG_grad 0.8372 |
| `MOTOR_VERSAO` | character | 1 | motor06 v2 2026-10-08 |
| `n_a` | numeric, nomeado | 6 | d2 0.1641, d1 0.112, d6 0.05843, d8 0.05719, d5 -0.003006, d7 -0.005905 |
| `n_res` | numeric, nomeado | 5 | d1 0.1398, d6 0.05454, d8 0.04455, d5 0.04132, d7 -0.007059 |
| `neg` | character | 5 | a, aprendizado, estatistico, fundamenta, moderna |
| `novo` | numeric, nomeado | 8 | d3 0.6495, d2 0.6434, d1 0.1398, d6 0.05454, d8 0.04455, d5 0.04132, ... |
| `novo_a` | numeric, nomeado | 8 | d3 0.9107, d2 0.1641, d1 0.112, d6 0.05843, d8 0.05719, d5 -0.003006, ... |
| `novo0` | numeric, nomeado | 8 | d3 0.6582, d2 0.652, d1 0.1417, d4 0.09559, d6 0.05951, d5 0.04551, ... |
| `q_a` | numeric, nomeado | 45 | a -0.104, acelera 0, aprendizado -0.3119, avaliacao 0, bm25 1.56, busca 0, ... |
| `q_prf` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0.7798, busca 0, ... |
| `q_prf1` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `q_prf3` | numeric, nomeado | 45 | a 0.1733, acelera 0, aprendizado 0.5199, avaliacao 0, bm25 0.5199, busca 0, ... |
| `q0` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `qm` | numeric, nomeado | 45 | a -0.104, acelera 0, aprendizado -0.3119, avaliacao 0, bm25 0.7798, busca 0, ... |
| `qm0` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0.7798, busca 0, ... |
| `r_prf` | numeric, nomeado | 8 | d3 0.6484, d1 0.5751, d2 0.1745, d4 0.1614, d6 0.06213, d8 0.04714, ... |
| `r_prf1` | numeric, nomeado | 8 | d1 0.8821, d4 0.1831, d3 0.1292, d2 0.126, d7 0.06654, d6 0.04093, ... |
| `r_prf3` | numeric, nomeado | 8 | d3 0.5165, d1 0.5014, d4 0.4871, d2 0.1678, d6 0.05804, d7 0.04063, ... |
| `tem` | logical, nomeado | 45 | a TRUE, acelera FALSE, aprendizado TRUE, avaliacao FALSE, bm25 FALSE, busca FALSE, ... |
| `termos` | character | 3 | aprendizado, modelo, de |
| `teste` | numeric, nomeado | 8 | d1 0.2539, d3 0.2327, d4 0.2148, d2 0.2078, d6 0.02485, d8 0.02295, ... |
| `top` | character | 2 | d1, d3 |
| `top1` | character | 1 | d1 |
| `top3` | character | 3 | d1, d3, d4 |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `ranking_bm25`, `ranking_cosseno`, `ranking_vetor`, `recall_k`, `relevancia`, `rocchio`, `rr`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`