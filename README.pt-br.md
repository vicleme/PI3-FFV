# Projeto Integrador 3 — Recuperação de Informação

🇧🇷 Português&nbsp;|&nbsp;[🇺🇸 English](README.md)

Um pequeno motor de busca, construído do zero em R, para a disciplina de
Recuperação de Informação (Projeto Integrador 3) da Fatec Baixada
Santista. Sem `tm`, `quanteda` nem nenhuma biblioteca pronta de busca:
cada peça (tokenização, ponderação TF-IDF, modelo do espaço vetorial,
similaridade de cosseno) é implementada manualmente, e depois testada
tanto num corpus de brinquedo quanto num corpus real — os verbetes da
Wikipédia de três cidades da Baixada Santista (Santos, Cubatão e
Guarujá).

Se você é um recrutador ou alguém só curioso, `estrutura/codigo/` é o
caminho mais rápido pra ver o motor em si; `consolidado-legado/` é onde o
resultado de cada etapa é interpretado em linguagem simples, incluindo
alguns dos limites conhecidos do modelo encontrados no caminho (ex.: o
TF-IDF destacando nomes próprios como se fossem termos "relevantes", e
uma cidade que fica literalmente invisível pra similaridade de cosseno
quando o vocabulário da consulta não tem sobreposição com o texto dela).

## Como este repositório está organizado

```
estrutura/
  corpus/              .txt dos verbetes da Wikipédia (Santos, Cubatão, Guarujá) e paragrafos.csv
  codigo/              scripts em R numerados, notebooks do grupo (aulaXX.ipynb) e config.R
  banco-de-dados/      os dados que o motor lê e grava: corpus, qrels, rankings, métricas
  ferramenta/          julgar.html, a página que os juízes usaram para dar as notas
entregas/              entregas da disciplina (Entrega 1: .Rnw, .pdf, .bib)
consolidado-legado/    um .md por aula, escritos pelo grupo, com a interpretação do que foi feito
                       (pouco código, foco no aprendizado e no projeto)
consolidados/          00_FICHA_PROJETO.md e os relatórios das sessões dos guias de estudo
                       com IA (da Aula 5,5 em diante); ver consolidados/README.md
trash/                 arquivos descontinuados, mantidos por pedido do professor
README.md              versão em inglês (principal) deste arquivo
README.pt-br.md        este arquivo
```

### `estrutura/corpus/`
`Santos.txt`, `Cubatao.txt` e `Guaruja.txt` — os verbetes da Wikipédia em
português (CC BY-SA) usados como corpus real do projeto, baixados e
persistidos em disco por `estrutura/codigo/00-preparar-corpus.R` em vez de
buscados na API a cada execução.

`paragrafos.csv` — a mesma divisão em parágrafos usada em
`03b-corpus-cidades-paragrafos.R` (colunas `doc_id`, `cidade`,
`paragrafo_num`, `n_caracteres`, `texto`), exportada por
`estrutura/codigo/00b-exportar-paragrafos-csv.R` para consulta fora do R.

### `estrutura/banco-de-dados/`
Arquivos que o motor lê e grava, no formato que os guias da disciplina
esperam: `corpus.csv` (`id`, `texto`, uma linha por parágrafo), `origem.rds`
(de qual verbete veio cada documento), `necessidades.csv` (as 10 consultas,
com a coluna `conjunto`: `dev` ou `teste`), os julgamentos de relevância
(`qrels_equipe.csv` com os três juízes, um `qrels_<juiz>_<data>.csv` por
juiz, e `qrels_consolidado.csv` / `qrels_consenso.csv` para o gabarito por
voto majoritário), `rankings.rds` e as métricas. As métricas do teste estão
em `metricas_teste_LACRADO_nao_abrir.csv`: lacradas até o relatório final.

### `estrutura/ferramenta/`
`julgar.html`: a página em que os três juízes deram a nota de cada par
consulta-parágrafo (graus 0, 1 e 2).

### `entregas/`
Entregas da disciplina. Entrega 1 (o corpus): `entrega-1-corpus-ffv.Rnw`
(fonte), o PDF e `referencias.bib`.

### `estrutura/codigo/`
Moram aqui dois tipos de arquivo, e o nome diz qual é qual:

- **`NN-nome.R`** (scripts numerados): o código do próprio projeto do grupo,
  escrito ao longo das aulas. É o motor.
- **`aulaXX.ipynb`** (notebooks): o registro de cada sessão de estudo em
  grupo ("Parte D" dos guias), rodada no Colab com o motor da disciplina
  (`motor06`). O que existia antes dos guias é o `12b-metricas-estudo.ipynb`
  (Aula 5,5). Notebooks individuais de teoria não ficam aqui.
- `config.R`: as decisões do grupo como valores em R (tratamento de acentos,
  stopwords, `k1` e `b` do BM25, limiar de relevância). A ficha do projeto,
  `consolidados/00_FICHA_PROJETO.md`, diz as mesmas decisões em prosa, e as
  duas têm que bater.

Scripts:

- `00-preparar-corpus.R` — baixa os verbetes da Wikipédia e grava em
  `estrutura/corpus/`.
- `utils-corpus.R` — funções compartilhadas para carregar o corpus salvo,
  nas duas granularidades usadas no projeto: `$texto` (1 documento por
  cidade) e `$docs` (1 documento por parágrafo); também `sem_acentos()`,
  que tira os acentos do mesmo jeito em qualquer computador (ela substituiu
  o `iconv`, que em alguns ambientes troca letra acentuada por `?`).
- `00b-exportar-paragrafos-csv.R` — exporta a divisão em parágrafos para
  `estrutura/corpus/paragrafos.csv`.
- `01-intro-r.R` — exercícios de sintaxe do R (Aula 1).
- `02-toy-corpus-tfidf.R` — TDM, busca booleana e TF-IDF no corpus de
  brinquedo (Aula 2, Parte 1).
- `03-corpus-cidades-tfidf-busca.R` — mesmo pipeline aplicado ao corpus
  real das cidades, no nível de cidade inteira (Aula 2, Parte 2).
- `03b-corpus-cidades-paragrafos.R` — a mesma análise no nível de
  parágrafo, com agregação de volta por cidade.
- `04-similaridade-cosseno-cidades.R` — similaridade de cosseno e busca
  por proximidade no corpus real das cidades (Aulas 1.5/2).
- `05-teoria-informacao-idf.R` — o IDF reconstruído a partir da teoria da
  informação de Shannon, em bits.
- `06-modelo-espaco-vetorial-toy.R` — TF-IDF + cosseno no corpus de
  brinquedo, com 3 consultas de exemplo.
- `07-pre-processamento-indice-invertido.R` — normalização de texto,
  stemming em português (SnowballC) e índice invertido (postings list),
  aplicados ao corpus real em granularidade de parágrafo, com busca
  booleana `AND`/`OR` (Aula 3).
- `08-bm25.R` — BM25 (saturação de frequência `k1`, normalização de
  tamanho `b`), aplicado ao mesmo corpus e comparado com o ranking de
  TF-IDF + cosseno (Aula 4).
- `09-concordancia-kappa.R`: kappa de Cohen, par a par, entre os três
  juízes (victor, flavia, felipe), sobre os 63 parágrafos das 10 consultas.
- `10-consolidar-qrels.R`: junta os três julgamentos em um gabarito por
  voto majoritário (mediana quando os três divergem); grava
  `qrels_consolidado.csv`.
- `11-rankings-consultas-reais.R`: rankings de três modelos (Booleano
  ranqueado por nível de coordenação, TF-IDF + cosseno, BM25) para as 10
  consultas reais, em granularidade de parágrafo; grava `rankings.rds`.
- `12-metricas-avaliacao.R`: P@k, R@k, AP, RR e nDCG (binário e
  graduado), validados no exemplo de 8 documentos e aplicados aos rankings
  com limiar grau >= 2; o resultado do teste vai para um arquivo lacrado.
- `12b-metricas-estudo.ipynb`: notebook de estudo (kernel R, roda no
  Colab) com as cinco métricas feitas à mão e depois no gabarito da
  equipe, comparando cosseno e BM25 nas sete consultas de desenvolvimento,
  com teste liga/desliga da saturação e da normalização de tamanho do BM25
  (Aula 5,5).
- `13-montar-pool.R`: monta a pool (top-10 por modelo, sem repetição) e
  mostra o que ela teria deixado de fora do gabarito.
- `14-separar-teste-desenvolvimento.R`: classifica cada consulta por
  dificuldade e separa 7 de desenvolvimento e 3 de teste por sorteio
  estratificado com semente fixa; grava `split_teste_desenvolvimento.csv`.

### `consolidado-legado/`
Um documento por notebook/aula, descrevendo e interpretando o que foi
feito — com pouco código e foco no que cada etapa representa para o
aprendizado e para o projeto do motor de busca. Escritos pelo grupo antes dos
guias de estudo com IA.

### `consolidados/`
A ficha do projeto (`00_FICHA_PROJETO.md`) e um relatório por sessão dos
guias de estudo com IA (da Aula 5,5 em diante). Os relatórios de sessão em
grupo ficam direto na pasta; os de teoria vão numa pasta com o nome de quem
fez (`equipe/` quando feita junto, `victor/` quando feita sozinho). Ver
`consolidados/README.md`.

### `trash/`
Arquivos descontinuados, mantidos por pedido do professor para fins de
histórico (ver `trash/README.md`).
