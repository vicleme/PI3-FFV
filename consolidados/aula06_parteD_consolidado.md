# Consolidado, PI III, Aula 06, Parte D, 2026-11-25
*guia versão 1 · tutora: Claude · sessão de grupo · motor06*
**Grupo:** FFV · **presentes:** Victor (sozinho nesta sessão) · **digitou:** Victor, nos Módulos 7, 8 e 9

## 1. O que foi feito
- M7: Rocchio no gabarito do grupo, na consulta q07. Na coleção completa, o AP foi de 0,267 para 1,000. Na residual com só `Cubatao_p8` marcado, foi de 1,0 para 0,5, porque `Cubatao_p9` (não marcado) perdeu o 1º lugar para `Cubatao_p7` (sobre o povoado). Conclusão do grupo: a completa é otimista, pois mede os próprios documentos marcados.
- M8: pseudo-realimentação nas 7 consultas de desenvolvimento. MAP: 0,606 sem PRF, 0,566 com $k=2$, 0,553 com $k=3$ e 0,528 com $k=5$. A PRF piorou 3 consultas com $k=2$, 3 com $k=3$ e 4 com $k=5$. Drift na q06: `Cubatao_p17` (grau 0, política de Cubatão) entrou em $D_r$ com $k=3$ e derrubou o AP de 1,0 para 0,5. O conjunto de teste (q01, q04, q08) não foi rodado.
- M9: decisão de não usar PRF, com `cfg$prf_k = 0` e pesos do Rocchio $\alpha = 1$, $\beta = 0{,}75$, $\gamma = 0{,}15$ registrados no `config.R`. O top-5 do motor na q07 conferiu com o ranking base. Ficha atualizada.

## 2. Como o grupo trabalhou, opinião da tutora
Trabalhei com o Victor sozinho. As funções `rocchio`, `ranking_vetor` e `prf` vieram do código que apresentei, o que o guia aceita (reescrever de memória ou copiar da teoria), e o teste do corpus do curso foi o que garantiu que estavam certas. Ele acertou a lógica do Rocchio e da residual quando perguntei o porquê, e pediu esclarecimentos úteis (o que é o Rocchio, o que é `ix`, o que olhar para prever). Algumas previsões vieram como pergunta e não como compromisso, e duas precisaram de ajuste (AP `NA` contra 0 na residual vazia; a residual da base já estar no teto de 1,0). Ele entendeu por que a tabela completa é otimista e escreveu sozinho a frase do Checkpoint 7. Escolheu o $k$ olhando só o desenvolvimento, decidiu não gastar o teste e manteve q01, q04 e q08 lacradas, o que foi uma boa decisão. Leu os textos do drift (`Cubatao_p7` e `Cubatao_p17`) e escreveu sozinho o parágrafo da análise, que precisou de pequenos ajustes na contagem de termos. A decisão de não usar PRF foi dele e está bem sustentada, mas depende de só 7 consultas. Flávia e Felipe a confirmaram depois da sessão, segundo o Victor.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 07):** o `config.R` editado (com `prf_k` e `rocchio`) precisa estar no repositório. O briefing da Aula 07 deve trazer a nota: mostrar vetores nomeados em tabela, com `rbind(...)` e `round(..., 3)`, porque a saída crua no Colab fica feia.
- **Perguntas guardadas:** nenhuma pendente; as dúvidas sobre o Rocchio, o `ix` e a previsão foram respondidas na hora. Duas ideias ficam para frente: achar documentos com outras palavras (embeddings, Aula 07) e saber se a diferença entre os modelos é significativa (Aula 16).
- **Produzido:** ver a entrada "Aula 06" na linha do tempo da ficha do projeto
- **Ficha atualizada:** sim, seções alteradas: 1 (ramo `main` confirmado), 5, 6, 7 e cabeçalho

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-25 18:33 · R version 4.6.1 (2026-06-24) · motor06 v2 2026-10-08 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `a` | character | 1 | qrels_consenso.csv |
| `arqs` | character | 1 | qrels_consenso.csv |
| `base` | numeric, nomeado | 63 | Santos_p15 0.1398, Cubatao_p20 0.1001, Guaruja_p20 0.09553, Cubatao_p1 0.08983, Cubatao_p8 0.07804, Cubatao_p9 0.05835, ... |
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
| `cfg$grupo` | character | 1 | FFV |
| `consultas` | character, nomeado | 10 | q01 fundacao santos ano, q02 praias santos quantidade, q03 maior porto america latina, q04 polo industrial, q05 tamanho guaruja, q06 jogador santos futebol hist..., ... |
| `cp` | data.frame | 63 × 2 | colunas: id, texto |
| `dev` | character | 7 | q02, q03, q05, q06, q07, q09, ... |
| `Dnr` | character | 4 | Santos_p15, Cubatao_p20, Guaruja_p20, Cubatao_p1 |
| `docs` | character, nomeado | 63 | Santos_p1 Santos é um município brasi..., Santos_p2 Fundada em 1546 por Brás Cu..., Santos_p3 Cidade mais populosa do lit..., Santos_p4 O principal cartão-postal d..., Santos_p5 Verificam-se relatos a resp..., Santos_p6 Em 1543, com o término da c..., ... |
| `Dr` | character | 2 | Cubatao_p8, Cubatao_p9 |
| `Dr_v` | character | 1 | Cubatao_p8 |
| `entrou` | numeric, nomeado | 10 | marcia 4.143, esporte 3.107, rosa 3.107, vice 3.107, assumiu 2.072, donizete 2.072, ... |
| `fora` | character | 6 | Cubatao_p8, Cubatao_p9, Santos_p15, Cubatao_p20, Guaruja_p20, Cubatao_p1 |
| `fora_v` | character | 5 | Cubatao_p8, Santos_p15, Cubatao_p20, Guaruja_p20, Cubatao_p1 |
| `g` | numeric, nomeado | 63 | Cubatao_p1 0, Cubatao_p10 0, Cubatao_p11 0, Cubatao_p12 0, Cubatao_p13 0, Cubatao_p14 0, ... |
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
| `ix_aula$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix_aula$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix_aula$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix_aula$N` | integer | 1 | 8 |
| `ix_aula$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix_aula$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix_aula$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix_aula$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix_aula$postings` | list | 45 | elementos: recuperacao, de, informacao, ordena, documentos, por, relevancia, o, ... |
| `ix_aula$dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, ... |
| `ix_aula$avgdl` | numeric | 1 | 8 |
| `ix_aula$idf_bm25` | numeric, nomeado | 45 | a 0.6931, acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, ... |
| `MOTOR_VERSAO` | character | 1 | motor06 v2 2026-10-08 |
| `nec` | data.frame | 10 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `novo` | numeric, nomeado | 63 | Cubatao_p8 0.6995, Cubatao_p9 0.6974, Cubatao_p7 0.07703, Cubatao_p11 0.07233, Cubatao_p18 0.06686, Cubatao_p6 0.05564, ... |
| `novo_v` | numeric, nomeado | 63 | Cubatao_p8 0.979, Cubatao_p7 0.0689, Cubatao_p9 0.06136, Santos_p6 0.05334, Cubatao_p2 0.05197, Cubatao_p18 0.05143, ... |
| `origem` | character, nomeado | 63 | Santos_p1 Santos, Santos_p2 Santos, Santos_p3 Santos, Santos_p4 Santos, Santos_p5 Santos, Santos_p6 Santos, ... |
| `q` | character | 1 | q07 |
| `q_aula` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `q0` | numeric, nomeado | 1518 | 0 0, 000 0, 034 0, 041 0, 048 0, 1 0, ... |
| `q0_06` | numeric, nomeado | 1518 | 0 0, 000 0, 034 0, 041 0, 048 0, 1 0, ... |
| `q3` | numeric, nomeado | 1518 | 0 0, 000 0, 034 0, 041 0, 048 0, 1 0, ... |
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
| `REPO` | character | 1 | https://raw.githubuserconte... |
| `stopwords_pt` | character | 203 | a, ao, aos, aquela, aquelas, aquele, ... |
| `tab_dev` | matrix | 4 × 7 | linhas: base, k2, k3, ... \| colunas: q02, q03, q05, q06, ... |
| `top3` | character | 3 | Santos_p22, Santos_p23, Cubatao_p17 |
| `usar` | character | 10 | q01, q02, q03, q04, q05, q06, ... |

### Funções definidas

`anexar_estado`, `ap`, `ap_q`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `ranking_bm25`, `ranking_cosseno`, `ranking_motor`, `ranking_vetor`, `recall_k`, `relevancia`, `residual`, `rocchio`, `rr`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

