# Recuperação de Informação (2026-08-14, com atualização de 25/08/2026)

Código completo:
[`02-toy-corpus-tfidf.R`](../estrutura/codigo/02-toy-corpus-tfidf.R) ·
[`03-corpus-cidades-tfidf-busca.R`](../estrutura/codigo/03-corpus-cidades-tfidf-busca.R) ·
[`03b-corpus-cidades-paragrafos.R`](../estrutura/codigo/03b-corpus-cidades-paragrafos.R) ·
[`04-similaridade-cosseno-cidades.R`](../estrutura/codigo/04-similaridade-cosseno-cidades.R)

## O que foi feito

### Parte 1 — corpus de brinquedo
Com um corpus fixo de 8 frases curtas (`d1` a `d9` depois de expandido),
percorri o pipeline clássico de um motor de busca em miniatura:
tokenização, vocabulário, matriz termo-documento (TDM), busca booleana
exata e, por fim, o cálculo de TF-IDF (comparando `log` natural e
`log10`). Também explorei a diferença entre `grep` (casa substring) e a
busca booleana baseada em vocabulário (casa token exato).

### Parte 2 — corpus real da Baixada Santista
Apliquei o mesmo pipeline a um corpus real: os verbetes da Wikipédia em
português de Santos, Cubatão e Guarujá, cada cidade tratada inicialmente
como um único documento. Depois de tokenizar, limpar acentos e remover
uma lista ampliada de stopwords em português, montei a TDM e a matriz
TF-IDF das três cidades e implementei busca booleana sobre esse
vocabulário real.

### Atualização de 25/08 — similaridade de cosseno
Numa atualização posterior (também refletida no notebook de Modelo do
Espaço Vetorial), acrescentei a função de similaridade de cosseno e uma
função `buscar_cidade()` que trata uma consulta livre (ex.: "porto
industria petroleo") como um pseudo-documento, pondera pelo IDF e ranqueia
as três cidades por proximidade angular — a mesma lógica de um projeto de
recomendação de filmes por TF-IDF + cosseno feito em outra disciplina.

### Ajustes pedidos pelo professor
Duas mudanças estruturais foram aplicadas depois da entrega original:

1. **Corpus persistido em `.txt`.** Em vez de baixar os verbetes da API da
   Wikipédia a cada execução do notebook, um script dedicado
   (`00-preparar-corpus.R`) baixa e grava cada cidade em
   `estrutura/corpus/*.txt` uma única vez. Os demais scripts leem esses
   arquivos via `utils-corpus.R`, o que deixa o projeto reprodutível sem
   depender de internet a cada execução.
2. **Granularidade de parágrafo.** O professor notou que os exemplos dados
   em aula tratavam cada documento como uma frase curta, enquanto o corpus
   das cidades tratava cada *cidade inteira* como um documento — uma
   diferença de granularidade grande demais. `03b-corpus-cidades-paragrafos.R`
   divide cada verbete em parágrafos (`Santos_p1`, `Santos_p2`, ...), na
   mesma escala "curta" do corpus de brinquedo, e depois agrega os escores
   de volta por cidade para comparar com a visão anterior. As duas visões
   (cidade inteira e parágrafo) ficam disponíveis lado a lado em
   `utils-corpus.R`.

## O que isso representa para o projeto

Essa é a aula onde o corpus de brinquedo dá lugar a dados reais, e onde os
limites teóricos do TF-IDF aparecem na prática: vários dos termos com
maior peso TF-IDF para Cubatão não são palavras temáticas, e sim nomes
próprios citados de passagem no verbete (ex.: "passarelli", "marcia",
"vereador"). Isso acontece porque o TF-IDF pondera por raridade no corpus,
e um nome próprio que só aparece no artigo de uma cidade recebe um IDF
alto mesmo sem representar nenhuma característica geral daquela cidade —
um limite que só uma etapa adicional de reconhecimento de entidades
nomeadas (NER) resolveria, e fica registrado aqui como ponto cego
conhecido do modelo bag-of-words usado até agora.

A divisão em parágrafos também é a primeira vez que o projeto lida
explicitamente com a escolha de "o que conta como um documento" — decisão
que volta a importar em aulas futuras (BM25, embeddings) e que, feita cedo
e de forma explícita, evita ter que reformular o corpus mais tarde.
