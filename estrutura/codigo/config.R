# ==========================================================================
#  config.R  --  as decisoes do grupo FFV, para o R
#  Repositorio: estrutura/codigo/config.R
# ==========================================================================
#
#  A ficha do projeto (consolidados/00_FICHA_PROJETO.md) diz as mesmas
#  decisoes em prosa, com o porque. Os dois tem que bater.
#
#  RECONSTRUIDO na Aula 06: este arquivo nao foi criado nas Aulas 01 a 5,5.
#  Os valores abaixo sao os que o grupo usou nos scripts
#  estrutura/codigo/11-rankings-consultas-reais.R e 12-metricas-avaliacao.R.
#
#  Sem acento nas strings (locale do Colab/Windows).
# ==========================================================================

# Lista de stopwords do grupo (a mesma de 11-rankings-consultas-reais.R)
stopwords_pt <- c(
    "a", "ao", "aos", "aquela", "aquelas", "aquele", "aqueles", "aquilo", "as", "ate", "com",
    "como", "da", "das", "de", "dela", "delas", "dele", "deles", "depois", "do", "dos", "e",
    "ela", "elas", "ele", "eles", "em", "entre", "era", "eram", "eramos", "essa", "essas",
    "esse", "esses", "esta", "estamos", "estao", "estar", "estas", "estava", "estavam",
    "estavamos", "este", "esteja", "estejam", "estejamos", "estes", "esteve", "estive",
    "estivemos", "estiver", "estiveram", "estiveremos", "estiverem", "estivermos", "estivesse",
    "estivessem", "estivessemos", "estou", "eu", "foi", "fomos", "for", "fora", "foram",
    "forem", "formos", "fosse", "fossem", "fossemos", "ha", "haja", "hajam", "hajamos",
    "havemos", "haver", "haveria", "haveriam", "haveriamos", "haveremos", "haverao", "hei",
    "houve", "houver", "houvera", "houveram", "houverei", "houverem", "houveremos", "houveria",
    "houveriam", "houveriamos", "houvermos", "houvesse", "houvessem", "houvessemos", "isso",
    "isto", "ja", "lhe", "lhes", "mais", "mas", "me", "mesmo", "meu", "meus", "minha",
    "minhas", "muito", "na", "nao", "nas", "nem", "no", "nos", "nossa", "nossas", "nosso",
    "nossos", "num", "numa", "o", "os", "ou", "para", "pela", "pelas", "pelo", "pelos", "por",
    "qual", "quando", "que", "quem", "se", "seja", "sejam", "sejamos", "sem", "sendo", "ser",
    "sera", "serao", "serei", "seremos", "seria", "seriam", "seriamos", "seu", "seus", "so",
    "somos", "sou", "sua", "suas", "tambem", "te", "tem", "temos", "tenho", "tenha", "tenham",
    "tenhamos", "ter", "tera", "terao", "terei", "teremos", "teria", "teriam", "teriamos",
    "teve", "tinha", "tinham", "tinhamos", "tive", "tiver", "tiveram", "tiveremos", "tiverem",
    "tivermos", "tivesse", "tivessem", "tivessemos", "tu", "tua", "tuas", "um", "uma", "voce",
    "voces", "vos", "sao", "sobre", "segundo", "onde", "partir", "alem", "possui", "apos"
)

cfg <- list(
  # --- Aula 01: o que e um documento ------------------------------------
  minimo = 200,                 # nenhum paragrafo tem menos de 200 caracteres (o menor tem 221): o corte nao remove nada

  # --- Aula 03: limpeza e stopwords ---------------------------------------
  limpar    = TRUE,             # usar a limpeza da Aula 03
  acentos   = "translit",       # i, c, a... sem acento (sem_acentos() de utils-corpus.R)
  stopwords = stopwords_pt,     # lista do grupo, definida acima

  # --- Aula 04: BM25 ------------------------------------------------------
  k1 = 1.2,
  b  = 0.75,

  # --- Aula 5,5: metricas -------------------------------------------------
  limiar = 2,                   # grau minimo para contar como relevante
  juizes = "consenso",          # gabarito = voto majoritario dos tres juizes (qrels_consenso.csv)

  # --- Aula 06: realimentacao ---------------------------------------------
  prf_k   = 0,                            # 0 = sem pseudo-realimentacao; k = usa os top-k
  rocchio = c(a = 1, b = 0.75, g = 0.15), # pesos do Rocchio

  # --- Aula 07: LSA e busca hibrida --------------------------------------
  modelo = "bm25",                        # "bm25", "lsa" ou "hibrido": decisao do grupo (MAP dev 0,635; teste 0,150)
  lsa_k  = 40,                            # melhor k testado (5, 10, 20, 40); registrado, nao usado
  rrf_c  = 60,                            # constante da fusao RRF; registrada, nao usada

  # --- Aula 08: reordenacao (rerank) ------------------------------------
  rerank_k = 5,                           # quantos do topo o reordenador reordena (0 = nao)
  janela   = 5,                           # distancia maxima da proximidade ordenada

  # --- fim ----------------------------------------------------------------
  grupo = "FFV"                 # ultimo campo, sem virgula depois
)
