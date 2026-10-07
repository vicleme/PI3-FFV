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
  corpus/            .txt files of the Wikipedia entries (Santos, Cubatão, Guarujá)
  codigo/             R scripts, split by class/block
consolidado-legado/   one .md per class, written by the group, interpreting what was done
                       (little code, focused on the learning/project takeaways)
consolidados/         reports from the AI study-guide sessions (from Class 5.5 on)
trash/                discontinued files, kept at the professor's request
README.md             this file
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

### `estrutura/codigo/`
- `00-preparar-corpus.R` — downloads the Wikipedia entries and writes them
  to `estrutura/corpus/`.
- `utils-corpus.R` — shared functions to load the saved corpus, at the two
  granularities used in the project: `$texto` (1 document per city) and
  `$docs` (1 document per paragraph).
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
One report per AI study-guide session (from Class 5.5 on), following the
file names the guides define (e.g. `aula05b_consolidado.md`).

### `trash/`
Discontinued files, kept at the professor's request for historical record
(see `trash/README.md`).
