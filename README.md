# Projeto Integrador 3 — Information Retrieval

[🇧🇷 Português](README.pt-br.md)&nbsp;|&nbsp;🇺🇸 English

A small search engine, built from scratch in R, for the Information
Retrieval course (Projeto Integrador 3) at Fatec Baixada Santista. No
`tm`, `quanteda`, or search library — every piece (tokenization, TF-IDF
weighting, the vector space model, cosine similarity) is implemented by
hand, then tested against both a toy corpus and a real one: the Wikipedia
entries for three cities in the Baixada Santista region (Santos, Cubatão
and Guarujá).

If you're a recruiter or a curious reader, `estrutura/codigo/` is the
fastest way to see the actual engine; `consolidado-legado/` is where each step's
result is interpreted in plain language, including a couple of the
model's known blind spots found along the way (e.g. TF-IDF surfacing
proper nouns as "relevant" terms, and a city that becomes literally
invisible to cosine similarity once the query vocabulary doesn't overlap
with its text).

## How this repository is organized

```
estrutura/
  corpus/              .txt files of the Wikipedia entries (Santos, Cubatão, Guarujá) and paragrafos.csv
  codigo/              numbered R scripts, the group notebooks (aulaXX.ipynb) and config.R
  banco-de-dados/      the data the engine reads and writes: corpus, qrels, rankings, metrics
  ferramenta/          julgar.html, the page the judges used to grade relevance
entregas/              course deliverables (Entrega 1: .Rnw, .pdf, .bib)
consolidado-legado/    one .md per class, written by the group, interpreting what was done
                       (little code, focused on the learning/project takeaways)
consolidados/          00_FICHA_PROJETO.md and the reports from the AI study-guide sessions
                       (from Class 5.5 on); see consolidados/README.md
trash/                 discontinued files, kept at the professor's request
README.md              this file
README.pt-br.md        Portuguese version of this file
```

### `estrutura/corpus/`
`Santos.txt`, `Cubatao.txt` and `Guaruja.txt` — the Portuguese-language
Wikipedia entries (CC BY-SA) used as the project's real corpus, downloaded
and persisted to disk by `estrutura/codigo/00-preparar-corpus.R` instead of
being fetched from the API on every run.

`paragrafos.csv` — the same paragraph split used in
`03b-corpus-cidades-paragrafos.R` (columns `doc_id`, `cidade`,
`paragrafo_num`, `n_caracteres`, `texto`), exported by
`estrutura/codigo/00b-exportar-paragrafos-csv.R` for inspection outside R.

### `estrutura/banco-de-dados/`
Files the engine reads and writes, in the format the course study guides
expect: `corpus.csv` (`id`, `texto`, one row per paragraph), `origem.rds`
(which entry each document came from), `necessidades.csv` (the 10 queries,
with a `conjunto` column: `dev` or `teste`), the relevance judgments
(`qrels_equipe.csv` with the three judges, one `qrels_<judge>_<date>.csv`
per judge, and `qrels_consolidado.csv` / `qrels_consenso.csv` for the
majority-vote gabarito), `rankings.rds`, and the metrics. The test-set
metrics are in `metricas_teste_LACRADO_nao_abrir.csv`: sealed until the
final report.

### `estrutura/ferramenta/`
`julgar.html`: the page the three judges used to grade each query-paragraph
pair (grades 0, 1 and 2).

### `entregas/`
Course deliverables. Entrega 1 (the corpus): `entrega-1-corpus-ffv.Rnw`
(source), its PDF and `referencias.bib`.

### `estrutura/codigo/`
Two kinds of files live here, and the names tell them apart:

- **`NN-name.R`** (numbered scripts): the group's own project code, written
  as the classes went on. These are the engine.
- **`aulaXX.ipynb`** (notebooks): the record of each group study session
  ("Parte D" of the study guides), run in Colab on the course engine
  (`motor06`). The one existing before the guides is `12b-metricas-estudo.ipynb`
  (Class 5.5). Individual theory notebooks are not kept here.
- `config.R`: the group's decisions as R values (accent handling, stopwords,
  BM25 `k1` and `b`, relevance threshold). The project sheet
  `consolidados/00_FICHA_PROJETO.md` says the same decisions in prose, and
  the two must agree.

Scripts:

- `00-preparar-corpus.R` — downloads the Wikipedia entries and writes them
  to `estrutura/corpus/`.
- `utils-corpus.R` — shared functions to load the saved corpus, at the two
  granularities used in the project: `$texto` (1 document per city) and
  `$docs` (1 document per paragraph); also `sem_acentos()`, which strips
  accents the same way on any computer (it replaced `iconv`, which turns
  accented letters into `?` in some environments).
- `00b-exportar-paragrafos-csv.R` — exports the paragraph split to
  `estrutura/corpus/paragrafos.csv`.
- `01-intro-r.R` — R syntax exercises (Class 1).
- `02-toy-corpus-tfidf.R` — TDM, boolean search and TF-IDF on the toy
  corpus (Class 2, Part 1).
- `03-corpus-cidades-tfidf-busca.R` — the same pipeline applied to the real
  city corpus, at whole-city granularity (Class 2, Part 2).
- `03b-corpus-cidades-paragrafos.R` — the same analysis at paragraph
  granularity, aggregated back up to the city level.
- `04-similaridade-cosseno-cidades.R` — cosine similarity and proximity
  search on the real city corpus (Classes 1.5/2).
- `05-teoria-informacao-idf.R` — IDF rebuilt from Shannon's information
  theory, in bits.
- `06-modelo-espaco-vetorial-toy.R` — TF-IDF + cosine on the toy corpus,
  with 3 example queries.
- `07-pre-processamento-indice-invertido.R` — text normalization,
  Portuguese stemming (SnowballC) and an inverted index (postings list),
  applied to the real corpus at paragraph granularity, with boolean
  `AND`/`OR` search (Class 3).
- `08-bm25.R` — BM25 (frequency saturation `k1`, length normalization
  `b`), applied to the same corpus and compared against the TF-IDF +
  cosine ranking (Class 4).
- `09-concordancia-kappa.R`: Cohen's kappa, pairwise, between the three
  judges (victor, flavia, felipe), over all 63 paragraphs of the 10 queries.
- `10-consolidar-qrels.R`: merges the three judgments into one gabarito
  by majority vote (median when all three disagree); writes
  `qrels_consolidado.csv`.
- `11-rankings-consultas-reais.R`: rankings of three models (Boolean
  ranked by coordination level, TF-IDF + cosine, BM25) for the 10 real
  queries, at paragraph granularity; writes `rankings.rds`.
- `12-metricas-avaliacao.R`: P@k, R@k, AP, RR and nDCG (binary and
  graded), validated on the 8-document example and applied to the
  rankings with threshold grade >= 2; test-set results go to a sealed file.
- `12b-metricas-estudo.ipynb`: study notebook (R kernel, runs in Colab)
  with the five metrics computed by hand and then on the team's judgments,
  comparing cosine and BM25 on the seven development queries, with a BM25
  on/off test of saturation and length normalization (Class 5.5).
- `13-montar-pool.R`: builds the pool (top-10 per model, deduplicated)
  and shows what it would have missed of the gabarito.
- `14-separar-teste-desenvolvimento.R`: classifies each query by
  difficulty and splits 7 development / 3 test queries with a stratified,
  seeded draw; writes `split_teste_desenvolvimento.csv`.

### `consolidado-legado/`
One document per notebook/class, describing and interpreting what was
done — with little code and a focus on what each step means for the
learning and for the search engine project. Written by the group before the
AI study guides existed.

### `consolidados/`
The project sheet (`00_FICHA_PROJETO.md`) and one report per AI study-guide
session (from Class 5.5 on). Group-session reports sit directly in the
folder; theory sessions go in a folder named after who did them
(`equipe/` when done together, `victor/` when done alone). See
`consolidados/README.md`.

### `trash/`
Discontinued files, kept at the professor's request for historical record
(see `trash/README.md`).
