# Projeto Integrador 3 — Recuperação de Informação

🇧🇷 Português&nbsp;|&nbsp;[🇺🇸 English](README.md)

Notebooks e projeto da disciplina de Recuperação de Informação (Projeto
Integrador 3): exercícios semanais de prática/interpretação propostos pelo
professor ao fim de cada aula, além de um projeto de semestre — um pequeno
motor de busca construído em R, usando ponderação TF-IDF, similaridade de
cosseno e o modelo do espaço vetorial.

## Estrutura do repositório

```
estrutura/
  corpus/            .txt dos verbetes da Wikipédia (Santos, Cubatão, Guarujá)
  código/             scripts em R, separados por aula/bloco
Consolidado/          um .md por aula, com a interpretação do que foi feito
                       (pouco código, foco no aprendizado e no projeto)
trash/                arquivos descontinuados, mantidos por pedido do professor
README.md             versão em inglês (principal) deste arquivo
README.pt-br.md        este arquivo
```

### `estrutura/corpus/`
`Santos.txt`, `Cubatao.txt` e `Guaruja.txt` — os verbetes da Wikipédia em
português (CC BY-SA) usados como corpus real do projeto, baixados e
persistidos em disco por `estrutura/código/00-preparar-corpus.R` em vez de
buscados na API a cada execução.

`paragrafos.csv` — a mesma divisão em parágrafos usada em
`03b-corpus-cidades-paragrafos.R` (colunas `doc_id`, `cidade`,
`paragrafo_num`, `n_caracteres`, `texto`), exportada por
`estrutura/código/00b-exportar-paragrafos-csv.R` para consulta fora do R.

### `estrutura/código/`
- `00-preparar-corpus.R` — baixa os verbetes da Wikipédia e grava em
  `estrutura/corpus/`.
- `utils-corpus.R` — funções compartilhadas para carregar o corpus salvo,
  nas duas granularidades usadas no projeto: `$texto` (1 documento por
  cidade) e `$docs` (1 documento por parágrafo).
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

### `Consolidado/`
Um documento por notebook/aula, descrevendo e interpretando o que foi
feito — com pouco código e foco no que cada etapa representa para o
aprendizado e para o projeto do motor de busca.

### `trash/`
Arquivos descontinuados, mantidos por pedido do professor para fins de
histórico (ver `trash/README.md`).

## Tags sugeridas

`information-retrieval` · `tf-idf` · `vector-space-model` · `search-engine` ·
`r` · `data-science` · `nlp` · `cosine-similarity` · `information-theory` ·
`text-mining`
