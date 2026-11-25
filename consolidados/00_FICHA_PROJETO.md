# Ficha do projeto: Equipe FFV

*reconstruída na Aula 06 em 2026-11-24 (o modelo `FICHA_PROJETO_modelo.md` não foi entregue e a ficha não foi criada na Parte D da Aula 01) · última atualização: 2026-11-25 (confirmação da PRF; modo de trabalho da Aula 07 em diante), motor06*

> **Como ler esta reconstrução.** Tudo aqui vem de arquivos do repositório (scripts, CSVs, consolidados do legado, entrega 1). O que o repositório não registra ficou como `—`. O que só o grupo pode confirmar ficou como **CONFIRMAR**. A seção 8 ("Estado do R") não existe ainda: é gerada por `anexar_estado()` no fim da sessão.

---

## 1. O grupo e o ambiente

- **Grupo:** FFV (Victor, Flávia e Felipe)
- **Disciplina:** Projeto Integrador III: Motor de Busca, Tecnologia em Ciência de Dados, Fatec Baixada Santista (Rubens Lara). Prof. Dr. João Paulo Ferreira de Mello
- **Repositório (público):** https://github.com/vicleme/PI3-FFV
- **Endereço Raw (primeira célula do Colab):** `https://raw.githubusercontent.com/vicleme/PI3-FFV/main/`
- **Ambiente:** Google Colab, kernel R
- **Motor da disciplina:** `motor06` (`MOTOR_VERSAO` = "motor06 v2 2026-10-08")
- **Tema da atividade final (Aula 08):** Tema 8, "Onde a palavra aparece" (começo do documento e título)

## 2. O tema e as perguntas

**Tema:** um motor de busca, em R e sem bibliotecas de busca, sobre a Baixada Santista (SP), região da Fatec, que abriga o maior porto da América Latina e um grande polo industrial.

**Quem usaria:** um estudante, um morador ou um visitante que precisa de um fato pontual (um ano, um número, um nome) e não quer ler três verbetes inteiros para achá-lo.

**As três perguntas que guiam a Entrega 1** (são dez no total, ver seção 4):

1. Qual cidade abriga o maior porto da América Latina? (q03)
2. Em que ano Cubatão se tornou município? (q07)
3. Como funciona a travessia de balsa entre Santos e Guarujá? (q10)

## 3. A fonte, o documento e a motivação

- **Fonte:** Wikipédia em português, licença CC BY-SA, acessada em agosto de 2026 por API (extratos em texto puro).
- **Páginas:** os verbetes *Santos*, *Cubatão* e *Guarujá*.
- **Documento:** um parágrafo do verbete (bloco separado por linha em branco), identificado como `Santos_p1`, `Cubatao_p3` etc. É a menor unidade que responde sozinha a uma pergunta.
- **Motivação:** proximidade (a região é a da faculdade), disponibilidade (texto aberto, em português, sem raspagem) e sobreposição entre os verbetes, que dá ao motor algo a distinguir.
- **Alternativa descartada:** notícias de jornais regionais (direitos reservados, exigiriam raspagem). Confirmado pelo grupo em 2026-11-24 (a frase nasceu como redação proposta na Entrega 1; o histórico do repositório não registra a discussão).

## 4. O corpus, as consultas e o gabarito

**Documentos.** N = 63 parágrafos: Santos 23, Cubatão 20, Guarujá 20. Três acima do teto de 60 sugerido para a entrega, por dividir em parágrafos; o grupo manteve todos. Tamanho em caracteres: de 221 a 784 (nenhum abaixo de 200). Tamanho em tokens (contados com `tokenizar()` do motor): de 33 a 124, média 73,3. Vocabulário: 1.791 termos brutos em 4.617 tokens; 1.518 termos depois da limpeza do `config.R` (2.722 tokens, sem stopwords).

**Onde está e em que forma** (`estrutura/`):
- `corpus/Santos.txt`, `Cubatao.txt`, `Guaruja.txt`: os verbetes gravados em UTF-8 (versão congelada).
- `corpus/paragrafos.csv`: a divisão em parágrafos (`doc_id, cidade, paragrafo_num, n_caracteres, texto`).
- `banco-de-dados/corpus.csv` (`id, texto`) e `origem.rds` (vetor nomeado, id para verbete): gerados a partir de `paragrafos.csv` na Aula 06, no formato que o guia espera.
- `banco-de-dados/necessidades.csv`: as 10 consultas (com a coluna `conjunto`, `dev` ou `teste`, acrescentada na Aula 06).
- `banco-de-dados/qrels_equipe.csv`: os julgamentos brutos dos três juízes (1.890 linhas = 630 pares por juiz).
- `banco-de-dados/qrels_victor_2026-09-24.csv`, `qrels_flavia_2026-09-25.csv`, `qrels_felipe_2026-09-25.csv`: um arquivo por juiz, regenerados em 2026-11-24 a partir do `qrels_equipe.csv`; a data de cada nome é a da última marcação.
- `banco-de-dados/qrels_consolidado.csv` (3 colunas) e `qrels_consenso.csv` (as mesmas, mais a coluna `juiz = "consenso"`, que é o formato que `ler_qrels` exige): o gabarito do grupo.
- `banco-de-dados/guia_julgamento.md`, `split_teste_desenvolvimento.csv`, `metricas_*.csv`, `rankings.rds`.

**Consultas** (texto digitado; conjunto):

| consulta | texto | conjunto |
|---|---|---|
| q01 | fundacao santos ano | teste |
| q02 | praias santos quantidade | dev |
| q03 | maior porto america latina | dev |
| q04 | polo industrial | teste |
| q05 | tamanho guaruja | dev |
| q06 | jogador santos futebol historia | dev |
| q07 | cubatao virou municipio ano | dev |
| q08 | significado nome guaruja | teste |
| q09 | populacao cubatao censo | dev |
| q10 | travessia balsa santos guaruja | dev |

As consultas de teste (q01, q04, q08) ficam lacradas; os resultados delas estão em `metricas_teste_LACRADO_nao_abrir.csv`.

**Gabarito.** Os três integrantes julgaram os 630 pares (10 consultas), graus 0, 1 e 2, **sem combinar critérios antes**; o `guia_julgamento.md` foi escrito depois, a partir das discordâncias. Concordância (κ de Cohen): Victor×Flávia 0,618; Victor×Felipe 0,500; Flávia×Felipe 0,520. Gabarito consolidado: voto majoritário (mediana quando os três divergem). Graus no consolidado: 607 de grau 0, 9 de grau 1, 14 de grau 2. Toda consulta tem ao menos um relevante com grau ≥ 2 (nenhuma fica fora da avaliação por $R = 0$).

**Peculiaridades que atrapalham:**
- acentos, pontuação grudada e dígitos no texto bruto (tratados na limpeza);
- `Cubatao_p20` e `Guaruja_p20` são listas de indicadores do Censo de 2010 em frases curtas; mantidos, porque o de Cubatão responde à pergunta sobre a população pelo Censo;
- no TF-IDF, nomes próprios citados de passagem (como "passarelli" e "marcia", em Cubatão) ganham peso alto: limite do modelo, não da coleta;
- Santos domina o corpus (23 de 63) por ter o verbete mais longo.

**Pendências de gabarito:** nenhuma consulta de trabalho fica sem julgamento.

## 5. O que cada aula entregou

| o que | aula | arquivo | estado |
|---|---|---|---|
| corpus (`corpus.csv`) | 01 e 05 | `estrutura/codigo/00-preparar-corpus.R`, `utils-corpus.R`, `00b-exportar-paragrafos-csv.R`; `banco-de-dados/corpus.csv` | ok |
| `config.R` | 01 | `estrutura/codigo/config.R` | reconstruído na Aula 06; Aula 06 acrescentou `prf_k` e `rocchio` |
| tokenização + TDM | 01 | `01-intro-r.R`, `02-toy-corpus-tfidf.R` | ok |
| TF-IDF + cosseno | 02 | `03-corpus-cidades-tfidf-busca.R`, `03b-...-paragrafos.R`, `04-similaridade-cosseno-cidades.R`, `06-modelo-espaco-vetorial-toy.R` | ok |
| limpeza + stopwords do grupo | 03 | `07-pre-processamento-indice-invertido.R` (também o stemming, só nesse estudo); `utils-corpus.R` (`sem_acentos()`, acrescentada na Aula 06) | ok, acentos corrigidos |
| índice invertido + busca AND | 03 | `07-pre-processamento-indice-invertido.R` | ok |
| BM25 | 04 | `08-bm25.R` | ok |
| julgamento, gabarito, separação dev/teste | 05 | `estrutura/ferramenta/julgar.html`, `09-concordancia-kappa.R`, `10-consolidar-qrels.R`, `13-montar-pool.R`, `14-separar-teste-desenvolvimento.R` | ok |
| métricas (P@k, MAP, MRR, nDCG) dos dois modelos | 5,5 | `12-metricas-avaliacao.R`, `12b-metricas-estudo.ipynb` | ok |
| realimentação (Rocchio, pseudo-realimentação) | 06 | `estrutura/codigo/aula06.ipynb` | testado, desligado (`prf_k = 0`; pesos do Rocchio registrados no `config.R`) |

**Observação.** Os guias esperam um `aulaXX.ipynb` por Parte D. O grupo trabalhou com scripts numerados e documentou cada etapa em `consolidado-legado/`; o único notebook do repositório antes da Aula 06 era o `12b`. Isso ainda **não** é registro de Parte D feita nos moldes do guia para as Aulas 01 a 5,5; **CONFIRMAR** com o professor se isso basta.

## 6. As decisões, uma linha cada

- **Aula 01:** tema Baixada Santista, fonte Wikipédia, documento = parágrafo, porque é a menor unidade que responde sozinha a uma pergunta (o corpus nasceu com um documento por cidade e o professor apontou o descompasso) · `cfg$minimo = 200` (nenhum parágrafo tem menos de 200 caracteres, o corte não remove nada).
- **Aula 02:** consultas de trabalho: as 10 necessidades da seção 4 (em vez de 3), cada uma com necessidade e escopo em `necessidades.csv` · sem campo no `config.R`.
- **Aula 03:** acentos transliterados (tirados, "Guarujá" vira "guaruja") e lista de 203 stopwords do grupo (`stopwords_pt` em `11-rankings-consultas-reais.R`); o stemming do `07` foi estudo do índice e não entra nos rankings, para que a diferença entre os modelos venha do modelo e não do pré-processamento (motivo escrito pelo grupo nos comentários de `08-bm25.R` e `11-rankings-consultas-reais.R`) · `cfg$limpar = TRUE`, `cfg$acentos = "translit"`, `cfg$stopwords`. **Correção de 2026-11-24:** a retirada de acentos agora é feita por `sem_acentos()` (em `utils-corpus.R`), e não mais por `iconv`; ver o aviso depois da seção 6.
- **Aula 04:** BM25 com $k_1 = 1{,}2$ e $b = 0{,}75$, os parâmetros padrão (Robertson), sem ajuste · `cfg$k1 = 1.2`, `cfg$b = 0.75`.
- **Aula 05:** corpus congelado com N = 63 documentos, lido do disco (e não da API a cada execução), para fixar uma versão; 3 juízes sobre os mesmos 630 pares; consultas separadas em 7 de desenvolvimento e 3 de teste por sorteio estratificado por dificuldade, com semente fixa, teste lacrado · `banco-de-dados/corpus.csv`, `split_teste_desenvolvimento.csv`.
- **Aula 5,5:** limiar de relevância grau ≥ 2 para os dois sistemas, porque o grau 1 "toca o assunto mas não responde" · `cfg$limiar = 2`. **Gabarito = voto majoritário dos três juízes, e não prioridade entre juízes**, porque os três julgaram todos os pares e o κ entre eles é moderado (0,50 a 0,62); manter o consolidado também preserva a comparação com os resultados já registrados · `cfg$juizes = "consenso"` (a justificativa completa será escrita no trabalho).
- **Aula 5,5, resultado (corrigido em 2026-11-24):** na média das 7 consultas de desenvolvimento, MAP cosseno 0,610, BM25 0,644 e Booleano (OR por coordenação) 0,810. O BM25 fica na frente do cosseno em duas consultas (q02, q07), o cosseno em uma (q05) e os dois empatam nas outras quatro; o Booleano empata ou vence em todas as consultas, menos q02. A diferença entre BM25 e cosseno vem de poucas consultas, então a ressalva continua. Os números originais da Aula 5,5 (0,573 e 0,597, BM25 na frente só em q02) foram calculados com a retirada de acentos falhando, e ficam como registro histórico nos consolidados. Teste estatístico fica para a Aula 16.
- **Aula 06:** não usar pseudo-realimentação (PRF), mantendo o ranking base, porque nenhum $k$ (documentos do topo assumidos como relevantes) superou a base no desenvolvimento (MAP 0,606 sem PRF; 0,566 com $k=2$; 0,553 com $k=3$; 0,528 com $k=5$) e a PRF piorou de 3 a 4 das 7 consultas conforme o $k$. Sem teste: q01, q04 e q08 seguem lacradas. Ressalva: só 7 consultas de desenvolvimento, e a PRF melhora no máximo duas delas (q09; e q02 com $k=3$). Decisão tomada pelo Victor na sessão e confirmada por Flávia e Felipe (informado pelo Victor em 2026-11-25) · `cfg$prf_k = 0`, `cfg$rocchio = c(a = 1, b = 0.75, g = 0.15)` (pesos mantidos como registro do que foi testado).
- **Aula 06, resultado:** Rocchio na consulta q07: AP na coleção completa 0,267 → 1,000; na residual com só `Cubatao_p8` marcado como relevante (mais quatro de grau 0 como não relevantes) 1,0 → 0,5. A completa é otimista porque `Cubatao_p8` e `Cubatao_p9`, que sobem ao topo, estavam em $D_r$; na residual, `Cubatao_p9`, não marcado, perdeu o 1º lugar para `Cubatao_p7`, parágrafo sobre o povoado e não sobre o município · resultado, sem campo.
- **Aula 06, análise do drift:** na consulta q06 ("jogador santos futebol historia"), a PRF com $k = 3$ incluiu `Cubatao_p17` (grau 0, sobre a história política e eleitoral de Cubatão) no centroide dos relevantes, ao lado de `Santos_p22` e `Santos_p23`, favorecido pelo fato de "historia" ser a única palavra da consulta original presente no texto de `Cubatao_p17`. Com isso, a consulta reformulada passou a ser dominada por termos políticos de Cubatão (6 dos 10 novos termos de maior peso, liderados por "marcia", com 4,143), enquanto os outros 4 vêm dos parágrafos de Santos ("esporte" e "surfe" de `Santos_p23`, "titulos" e "tres" de `Santos_p22`), com "esporte" (3,107) empatado com "rosa" e "vice". Esse desvio (drift) jogou `Cubatao_p17` para o 1º lugar, empurrou o relevante `Santos_p22` para o 2º e derrubou o AP da consulta de 1,0 para 0,5. A palavra "jogador" não está no vocabulário do corpus, então a consulta atuou só com "futebol", "historia" e "santos" · resultado, sem campo.

> **Correção dos acentos e linha de base da Aula 06 (2026-11-24).** Os rankings da Aula 5,5 saíram de uma máquina em que `iconv(..., "ASCII//TRANSLIT")` troca cada letra acentuada por `?` (o resultado depende do idioma configurado no computador). "Guarujá" virava "guaruj" e "Cubatão" virava "cubat", que não casam com as consultas q05 ("guaruja") e q07 ("cubatao"): todos os escores dessas consultas eram zero, nos três modelos. Reproduzido: o script `11` em um ambiente com o `iconv` falhando devolve exatamente o `rankings.rds` antigo. Correção: `sem_acentos()` em `utils-corpus.R`, que dá o mesmo resultado em qualquer computador, usada em `03`, `03b`, `07` e `11`. Foram regenerados `rankings.rds`, `metricas_por_consulta.csv`, `metricas_medias.csv` e `metricas_teste_LACRADO_nao_abrir.csv` (este último foi recalculado pelo próprio script `12`, **sem ser aberto**). Por esse motivo, as métricas de teste que o grupo eventualmente tenha anotado antes de hoje não valem mais.
>
> **Linha de base para comparar o Rocchio:** use o `motor06` com o `config.R`: MAP de desenvolvimento 0,606 (cosseno) e 0,635 (BM25). Os scripts do grupo dão 0,610 e 0,644. A diferença restante vem só de uma escolha de limpeza: os scripts descartam dígitos e letras soltas, e o `motor06` os mantém (rodando o `motor06` com a regra do grupo, o MAP bate exatamente). Compare sempre antes e depois do Rocchio **no mesmo motor**.

---

## 7. Linha do tempo

*Datas dos documentos de `consolidado-legado/`. O número da aula de cada entrada foi atribuído pelos títulos dos PDFs das aulas, que coincidem com os títulos do legado. Presentes e quem digitou: `—` (não registrado).*

- **2026-08-07 (Aula 00):** introdução ao R (`consolidado-legado/01`). Produzido: `01-intro-r.R`.
- **2026-08-14 (Aula 01; atualizado em 25/08):** recuperação de informação, corpus de brinquedo (`02`). Produzido: TDM e busca booleana no corpus de exemplo.
- **2026-08-25 (Aulas 1,5 e 02):** teoria da informação e TF-IDF (`03`, Aula 1,5), modelo do espaço vetorial e cosseno (`04`, Aula 02). Produzido: o pipeline aplicado ao corpus das cidades, em dois níveis (cidade e parágrafo).
- **2026-09-12 (Aulas 03 e 04):** pré-processamento e índice invertido (`05`, Aula 03), BM25 (`06`, Aula 04).
- **2026-09-12 a 2026-09-25 (Aula 05):** julgamento dos 630 pares pelos três integrantes (`julgar.html`); consolidado `07` (separação teste/desenvolvimento e desvios do guia, 2026-09-25).
- **2026-09-29 (Aulas 05 e 5,5):** concordância κ, gabarito consolidado e métricas (`08`).
- **2026-10-05 e 2026-10-06:** Aula 5,5, teoria (`consolidados/equipe/`) e Parte D (`consolidados/`). Feito: as cinco métricas, o cosseno contra o BM25 nas 7 consultas de desenvolvimento, MAP e MRR. Pendente na época: por que seis de sete consultas empatam (superado: eram quatro de sete, depois da correção de 2026-11-24).
- **2026-10-09 e 2026-11-24:** Aula 06, teoria individual (Victor), consolidado em `consolidados/victor/`.
- **2026-11-24:** corrigida a retirada de acentos (`sem_acentos()`) e regenerados rankings e métricas (seção 6); esta reconstrução da ficha; gerados `config.R`, `corpus.csv`, `origem.rds`, `qrels_consenso.csv` e os `qrels_<juiz>_<data>.csv`; `necessidades.csv` ganhou a coluna `conjunto`.
- **2026-11-25:** Aula 06, Parte D. Presente: Victor (sozinho). Digitou: Victor (Módulos 7, 8 e 9). Feito: Rocchio na q07, na coleção completa e na residual; pseudo-realimentação com $k$ = 2, 3 e 5 nas 7 consultas de desenvolvimento; drift na q06 (`Cubatao_p17`); decisão de não usar PRF, com o teste mantido lacrado. Produzido: `cfg$prf_k` e `cfg$rocchio` no `config.R`; funções `rocchio`, `ranking_vetor`, `residual`, `prf`, `ap_q` e `ranking_motor` (em `aula06.ipynb`); análise do drift. Pendente: enviar ao GitHub o `config.R` editado, o `aula06.ipynb` e os consolidados; teoria da Aula 06 de Flávia e Felipe em `consolidados/<nome>/`, se ainda não estiver lá; perguntar ao professor se scripts numerados bastam nas Partes D das Aulas 01 a 5,5.
- **2026-11-25 (depois da Parte D):** Flávia e Felipe confirmaram a decisão de não usar PRF (informado pelo Victor). O grupo combinou fazer, a partir da Aula 07, a teoria e a Parte D juntos, em uma sessão só, com consolidado de equipe em `consolidados/equipe/`; cada integrante segue enviando ao menos um arquivo com a própria conta do GitHub. As Aulas 5 e 5,5 já tinham sido feitas assim. Pendente: perguntar ao professor se esse formato é aceito (decidido não perguntar por ora, pelo prazo).

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

