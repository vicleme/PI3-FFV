# Ficha do projeto: Equipe FFV

*reconstruída na Aula 06 em 2026-11-24 (o modelo `FICHA_PROJETO_modelo.md` não foi entregue e a ficha não foi criada na Parte D da Aula 01) · última atualização: Aula 08 Parte D, 2026-11-26, motor08*

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
| `config.R` | 01 | `estrutura/codigo/config.R` | reconstruído na Aula 06; Aula 06 acrescentou `prf_k` e `rocchio`; Aula 07 acrescentou `modelo`, `lsa_k` e `rrf_c`; Aula 08 acrescentou `rerank_k` e `janela` |
| tokenização + TDM | 01 | `01-intro-r.R`, `02-toy-corpus-tfidf.R` | ok |
| TF-IDF + cosseno | 02 | `03-corpus-cidades-tfidf-busca.R`, `03b-...-paragrafos.R`, `04-similaridade-cosseno-cidades.R`, `06-modelo-espaco-vetorial-toy.R` | ok |
| limpeza + stopwords do grupo | 03 | `07-pre-processamento-indice-invertido.R` (também o stemming, só nesse estudo); `utils-corpus.R` (`sem_acentos()`, acrescentada na Aula 06) | ok, acentos corrigidos |
| índice invertido + busca AND | 03 | `07-pre-processamento-indice-invertido.R` | ok |
| BM25 | 04 | `08-bm25.R` | ok |
| julgamento, gabarito, separação dev/teste | 05 | `estrutura/ferramenta/julgar.html`, `09-concordancia-kappa.R`, `10-consolidar-qrels.R`, `13-montar-pool.R`, `14-separar-teste-desenvolvimento.R` | ok |
| métricas (P@k, MAP, MRR, nDCG) dos dois modelos | 5,5 | `12-metricas-avaliacao.R`, `12b-metricas-estudo.ipynb` | ok |
| realimentação (Rocchio, pseudo-realimentação) | 06 | `estrutura/codigo/aula06.ipynb` | testado, desligado (`prf_k = 0`; pesos do Rocchio registrados no `config.R`) |
| LSA e busca híbrida | 07 | `estrutura/codigo/aula07.ipynb` | testado, não usado (`modelo = "bm25"`; `lsa_k = 40` e `rrf_c = 60` registrados no `config.R`) |
| reordenação (proximidade ordenada) | 08 | `estrutura/codigo/aula08.ipynb` | ok (`rerank_k = 5`, `janela = 5` no `config.R`) |

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
- **Aula 07:** modelo do motor = BM25 (sem LSA nem híbrido), $k$ = 40 registrado e não usado, porque nenhuma linha com LSA superou o BM25 no desenvolvimento (MAP dev: BM25 0,635; LSA 0,204, 0,494, 0,527 e 0,570 com $k$ = 5, 10, 20 e 40; híbrido 0,524, 0,560, 0,579 e 0,603 com os mesmos $k$) e, com $k$ = 40, nenhum dos dois ganhou do BM25 em consulta alguma (o LSA perdeu em 4 de 7: q02, q05, q07 e q09; o híbrido, em 3: q02, q05 e q07). Teste rodado uma vez, nas três consultas lacradas: MAP 0,150 (q01 0,056; q04 0,333; q08 0,062), igual para o BM25 e para o escolhido, que é o mesmo modelo. Ressalva: só 7 consultas de desenvolvimento, grade de $k$ até 40 (o máximo é 63) e o MAP ainda subia com o $k$; a queda de 0,635 para 0,150 pode vir do tamanho da amostra de teste (3 consultas) ou de uma dificuldade maior, e os dados não separam os dois efeitos. O teste foi usado: nada mais se ajusta com base nele. Decisão tomada pelo grupo na sessão (Victor, Flávia e Felipe), com o teste rodado só depois de escrita a escolha · `cfg$modelo = "bm25"`, `cfg$lsa_k = 40`, `cfg$rrf_c = 60` (os dois últimos registram o que foi testado).
- **Aula 07, resultado:** LSA no corpus de 63 parágrafos com $k = 20$ guarda 0,486 da energia. Na q10, os top-5 do BM25 e do LSA têm 1 documento em comum (`Guaruja_p19`); os 4 que só o LSA trouxe e os 4 que só o BM25 trouxe têm grau 0. `Cubatao_p9` e `Cubatao_p4` não têm palavra alguma da consulta e só vieram pelas direções da SVD (ruído); o BM25 trouxe `Guaruja_p10` por "guaruja" e por "Santos" de Alberto Santos Dumont · resultado, sem campo.
- **Aula 07, análise (texto do grupo):** com $k = 40$, nenhum dos dois modelos superou o BM25 em consulta alguma no conjunto de desenvolvimento. Ainda assim, vale olhar tanto para uma perda clara na q02 quanto para um movimento discreto na q05 com híbrido em $k = 20$ (0,083 contra 0,077 do BM25), além do empate em 0,500 na q09. Na perda da q02 ("praias santos quantidade"), o BM25 coloca `Santos_p14` em 2º lugar (AP = 0,500), enquanto o híbrido com $k = 40$ o empurra para 3º (AP = 0,333). `Santos_p14` responde à pergunta ao trazer "6 praias" no contexto de Santos. Já `Guaruja_p2` sobe para 1º no LSA e para 2º no híbrido porque reúne vocabulário de praias e turismo de Guarujá, sem dar quantidade nem tratar de Santos. Na RRF com $c = 60$, `Guaruja_p2` ($\frac{1}{61} + \frac{1}{63} = 0{,}0323$) fica à frente de `Santos_p14` ($\frac{1}{62} + \frac{1}{63} = 0{,}0320$) por apenas $0{,}0003$, mostrando que a fusão por posto ignora tanto o que a consulta pede quanto a distância real entre os itens. Na q05 ("tamanho guaruja"), o relevante `Guaruja_p1` responde ao tamanho com "área de 144,794 km²" e "densidade", sem usar a palavra "tamanho", e traz "guaruja" apenas uma vez na abertura, em meio a vários números. Isso cria um descasamento de vocabulário que o LSA foi feito para enfrentar, mas o híbrido com $k = 20$ moveu o relevante apenas uma casa, do 13º para o 12º lugar (passando `Guaruja_p4`). Os dados não mostram por que o avanço foi tão curto; fica como hipótese que o corpus de 63 parágrafos seja pequeno demais para o LSA ligar com força "tamanho" a "área" · resultado, sem campo.

- **Aula 08:** reordenação = top-5 do BM25, janela 5, sobre o estágio 1 `bm25`, porque foi a combinação de maior MAP no desenvolvimento, com ganho em duas consultas e nenhuma perda · MAP dev: estágio 1 0,635; grade (linhas $k$ = 3, 5, 10; colunas janela 2, 3, 5): k3 0,635 / 0,635 / 0,706, k5 0,654 / 0,654 / 0,725, k10 0,654 / 0,654 / 0,718; escolhido $k$ = 5, janela 5 (0,725). Ganho em q02 (0,500 → 1,000) e q07 (0,367 → 0,500), sem perda nas outras 5 das 7. Teste rodado uma vez: MAP 0,150 → 0,150 (q01 0,056; q04 0,333; q08 0,062, sem mudança em nenhuma). Ressalvas: só 7 consultas de desenvolvimento; as 3 de teste já tinham sido vistas na Aula 07 (o teste foi rodado de novo hoje, sem ajuste depois); o ganho da q02 veio de vizinhança entre frases (o `santos` que ficou a 4 posições de `praias` em `Santos_p14` está na frase do clima, e `quantidade` não existe no texto); na q05 o relevante (`Guaruja_p1`) está em 13º no BM25, fora do alcance de qualquer $k$ da grade. Decisão tomada pelo grupo na sessão (Victor, Flávia e Felipe), com o teste rodado só depois de escrita a escolha · `cfg$rerank_k = 5`, `cfg$janela = 5`.
- **Aula 08, resultado:** na q03 (desenvolvimento), com $k$ = 10 e janela 3, 3 dos 5 do topo mudaram de posição (`Santos_p18` 2º → 1º, `Santos_p1` 3º → 2º, `Santos_p19` 1º → 3º); `Santos_p18` e `Santos_p1` empataram no escore máximo de proximidade (4,333, com "maior porto america latina" colado) e ficaram na ordem do estágio 1; o gabarito dá grau 2 aos três, então o AP ficou em 1 antes e depois. O `ranking_final` com $k$ = 5 e janela 5 deu `Santos_p18 Santos_p1 Santos_p19 Santos_p17 Santos_p22` · resultado, sem campo.
- **Aula 08, análise (texto do grupo):** com $k$ = 5 e janela 5, a reordenação ganhou na q02 e na q07, não mudou a q05, e o placar vem junto de coincidências de vizinhança. **Ganho na q02 ("praias santos quantidade"):** o AP subiu de 0,500 para 1,000, porque `Santos_p14`, o único relevante (grau 2), passou à frente de `Guaruja_p2` (grau 0), que era o 1º no BM25. `Santos_p14` responde à necessidade ao dizer que a orla santista tem 6 praias em oito quilômetros; `Guaruja_p2` fala das praias e do turismo de Guarujá sem número algum. Mas o ganho não veio da contagem: "quantidade" não aparece no texto, e a proximidade vem de "santos", que está na frase seguinte (sobre o clima), a 4 posições de "praias"; a ordem saiu certa por uma vizinhança que atravessa o ponto final. **Ganho frágil na q07 ("cubatao virou municipio ano"):** o AP subiu de 0,367 para 0,500, e a grade mostra que isso vem do $k$ (de 3 para 5), não da janela. `Cubatao_p9` (grau 2, "elevação de Cubatão à categoria de município", 1949) estava em 5º, entrou no recorte com proximidade 0,50 e foi para 2º. Porém `Cubatao_p1` (grau 0, área e população) foi para 1º com proximidade 1,00 só por abrir com "Cubatão é um município", e `Cubatao_p8` (grau 2, emancipação em 1949) desceu de 3º para 4º, porque "emancipação" não é palavra da consulta. Com $k$ = 10 e janela 5 o AP cai para 0,450: `Cubatao_p18` (grau 0, "Cubatão … Sede do Município", proximidade 0,25) sobe para 3º e empurra `Cubatao_p8` para 5º. **Sem mudança na q05 ("tamanho guaruja"):** o AP ficou em 0,077 (1/13): `Guaruja_p1` (grau 2, área de 144,794 km²) está em 13º no BM25. O texto responde à necessidade, mas não usa "tamanho" e traz "Guarujá" só uma vez, no começo, o que pode ajudar a explicar a posição no BM25. Como a reordenação só relê os $k$ primeiros e o maior $k$ da grade é 10, o relevante fica fora do alcance de qualquer configuração. **Nota de observação:** o sinal de proximidade também subiu documentos de grau 0 por coincidência de termos próximos ou iniciais (`Cubatao_p1` para 1º na q07 com $k$ = 5 e 10; `Cubatao_p18` para 3º com $k$ = 10); o detalhe completo fica no relatório · resultado, sem campo.

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
- **2026-11-25 (Aula 07, teoria e Parte D):** a teoria (LSA e RRF) foi feita em equipe, em revezamento (consolidado `aula07_consolidado.md`, acertos em todos os seis módulos do teste), e a Parte D no mesmo dia. Presentes na Parte D: Victor, Flávia e Felipe. Digitaram: Victor (Módulo 7), Flávia (Módulo 8), Felipe (Módulo 9). Feito: LSA com $k = 20$ no corpus de 63 parágrafos e leitura dos textos na q10; BM25, LSA ($k$ = 5, 10, 20 e 40) e híbrido (RRF, $c = 60$) nas 7 consultas de desenvolvimento; leitura da q02 (perda) e da q05 (ganho mínimo); decisão de ficar com o BM25; teste rodado uma vez (MAP 0,150); registro no `config.R`; o top-5 da q07 pelo `ranking_motor` conferiu com o AP do BM25 na tabela (0,367). Produzido: `cfg$modelo`, `cfg$lsa_k` e `cfg$rrf_c` no `config.R`; funções `lsa`, `ranking_lsa`, `rrf` (copiadas da teoria), `ranking_modelo`, `ap_modelo` e `ranking_motor` (em `aula07.ipynb`); análise de ganho e perda. Pendente: enviar ao GitHub o `config.R` editado, o `aula07.ipynb` e os consolidados (inclusive os da Aula 06 que ainda faltem, conforme a linha de 2026-11-25 acima); `prf_k` segue em 0, então não há pendência de PRF com LSA; o teste foi usado, e qualquer ajuste novo precisa de outra base que não ele; a pergunta sobre significância da diferença entre modelos fica para a Aula 16.
- **2026-11-26 (Aula 08, teoria):** feita em dupla por Victor e Felipe (consolidado `aula08_consolidado.md`, acertos em todos os seis módulos do teste). A teoria de Flávia da Aula 08 não aparece nos arquivos: **CONFIRMAR**.
- **2026-11-26 (Aula 08, Parte D):** presentes: Victor, Flávia e Felipe. Digitaram: Flávia (Módulo 7), Victor (Módulo 8), Felipe (Módulo 9). Feito: `proximidade` e `reordenar` copiadas e testadas; estágio 1 = BM25 (`cfg$modelo`); top-5 antes × depois na q03, lendo os textos; grade $k \in \{3, 5, 10\}$ × janela $\in \{2, 3, 5\}$ nas 7 consultas de desenvolvimento; leitura da q02 (ganho) e da q05 (fora do alcance); decisão $k$ = 5, janela 5, tomada pelo grupo; teste rodado uma vez (MAP 0,150 → 0,150); registro no `config.R`; `ranking_final` na q03. Produzido: `cfg$rerank_k` e `cfg$janela` no `config.R`; funções `proximidade` e `reordenar` (copiadas da teoria), `estagio1`, `rerank_prox`, `ap_rerank` e `ranking_final` (em `aula08.ipynb`). Feito depois da sessão (2026-11-26): análise em prosa da q02 (ganho), da q07 (ganho frágil, vindo do $k$ e não da janela, conferido no top-10 com a proximidade) e da q05 (sem mudança), com a nota sobre documentos de grau 0 elevados pela proximidade, na seção 6; texto aprovado pelo grupo (informado pelo Victor). Pendente: enviar ao GitHub o `config.R` editado, o `aula08.ipynb`, a ficha e os consolidados (quem envia o quê não foi definido); levar a análise ao relatório; o teste foi usado de novo, e qualquer ajuste novo precisa de outra base que não ele.

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

