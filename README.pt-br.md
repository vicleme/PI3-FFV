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
  corpus/            .txt dos verbetes da Wikipédia (Santos, Cubatão, Guarujá)
  codigo/             scripts em R, separados por aula/bloco
consolidado-legado/   um .md por aula, escritos pelo grupo, com a interpretação do que foi feito
                       (pouco código, foco no aprendizado e no projeto)
consolidados/         relatórios das sessões dos guias de estudo com IA (da Aula 5,5 em diante)
trash/                arquivos descontinuados, mantidos por pedido do professor
README.md             versão em inglês (principal) deste arquivo
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

### `estrutura/codigo/`
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
- `07-pre-processamento-indice-invertido.R` — normalização de texto,
  stemming em português (SnowballC) e índice invertido (postings list),
  aplicados ao corpus real em granularidade de parágrafo, com busca
  booleana `AND`/`OR` (Aula 3).
- `08-bm25.R` — BM25 (saturação de frequência `k1`, normalização de
  tamanho `b`), aplicado ao mesmo corpus e comparado com o ranking de
  TF-IDF + cosseno (Aula 4).

### `consolidado-legado/`
Um documento por notebook/aula, descrevendo e interpretando o que foi
feito — com pouco código e foco no que cada etapa representa para o
aprendizado e para o projeto do motor de busca. Escritos pelo grupo antes dos
guias de estudo com IA.

### `consolidados/`
Um relatório por sessão dos guias de estudo com IA (da Aula 5,5 em diante),
com os nomes que os guias definem (ex.: `aula05b_consolidado.md`).

### `trash/`
Arquivos descontinuados, mantidos por pedido do professor para fins de
histórico (ver `trash/README.md`).
