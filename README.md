# Projeto Integrador 3 — Information Retrieval

[🇧🇷 Português](README.pt-br.md)&nbsp;|&nbsp;🇺🇸 English

Notebooks and project for the Information Retrieval course (Projeto
Integrador 3): weekly practice/interpretation exercises assigned by the
professor at the end of each class, alongside a semester-long project — a
small search engine built in R using TF-IDF weighting, cosine similarity
and the vector space model.

## Repository structure

```
estrutura/
  corpus/            .txt files of the Wikipedia entries (Santos, Cubatão, Guarujá)
  código/             R scripts, split by class/block
Consolidado/          one .md per class, interpreting what was done
                       (little code, focused on the learning/project takeaways)
trash/                discontinued files, kept at the professor's request
README.md             this file
README.pt-br.md        Portuguese version of this file
```

### `estrutura/corpus/`
`Santos.txt`, `Cubatao.txt` and `Guaruja.txt` — the Portuguese-language
Wikipedia entries (CC BY-SA) used as the project's real corpus, downloaded
and persisted to disk by `estrutura/código/00-preparar-corpus.R` instead of
being fetched from the API on every run.

`paragrafos.csv` — the same paragraph split used in
`03b-corpus-cidades-paragrafos.R` (columns `doc_id`, `cidade`,
`paragrafo_num`, `n_caracteres`, `texto`), exported by
`estrutura/código/00b-exportar-paragrafos-csv.R` for inspection outside R.

### `estrutura/código/`
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

### `Consolidado/`
One document per notebook/class, describing and interpreting what was
done — with little code and a focus on what each step means for the
learning and for the search engine project.

### `trash/`
Discontinued files, kept at the professor's request for historical record
(see `trash/README.md`).

## Suggested tags

`information-retrieval` · `tf-idf` · `vector-space-model` · `search-engine` ·
`r` · `data-science` · `nlp` · `cosine-similarity` · `information-theory` ·
`text-mining`
