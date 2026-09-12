# Teoria da Informação e o TF-IDF (2026-08-25)

Código completo: [`05-teoria-informacao-idf.R`](../estrutura/código/05-teoria-informacao-idf.R)

## O que foi feito

Esta aula reconstrói o IDF a partir da definição de Shannon de informação
em bits (`I(p) = -log2(p)`), em vez de simplesmente aceitar a fórmula
`log(N/df)` como dada. Trabalhando ainda com o corpus de brinquedo de 8
documentos, cada bloco testou uma propriedade da teoria da informação e a
conectou de volta ao TF-IDF:

- Quantos bits custa achar 1 documento entre N (e por que dobrar N custa
  sempre +1 bit, não o dobro).
- Quanto vale, em bits, uma "pista" (um termo de busca) — e como esse
  valor é exatamente o IDF, só que na base 2.
- Quando a informação de dois termos se soma "certinho" (termos
  independentes) e quando a soma superestima a informação real (termos do
  mesmo campo semântico, que tendem a co-ocorrer).
- Um exemplo completo de ranqueamento de documentos somando bits de
  evidência por consulta.
- Um corpus artificial de "rotas" entre as 4 cidades da Baixada Santista
  (permutações das mesmas 4 palavras), usado para mostrar o caso extremo
  em que todo termo tem IDF zero — e portanto o modelo bag-of-words fica
  literalmente cego para diferenças entre documentos.

## O que isso representa para o projeto

O ponto central da aula é que **stopwords têm IDF zero não por
convenção, mas por definição matemática**: um termo presente em 100% dos
documentos não reduz em nada a incerteza sobre qual documento é o
buscado, logo `log2(N/N) = 0`. Isso dá uma justificativa formal, e não
apenas uma regra prática, para a etapa de remoção de stopwords já usada
desde a aula anterior.

O experimento das "rotas" é o mais revelador para o projeto: com 4 cidades
sempre presentes nas 8 rotas (portanto `df = 8` para todo termo), a matriz
TF-IDF inteira colapsa a zero e o cosseno entre duas rotas completamente
diferentes (mas com o mesmo conjunto de palavras) dá exatamente 1 —
idênticas para o modelo, mesmo sendo rotas diferentes na prática. Isso
expõe de forma concreta uma limitação estrutural do bag-of-words que vai
ficar relevante para todo o resto do projeto: **o modelo ignora ordem**, e
sem contraste de vocabulário entre documentos não existe distância
nenhuma para medir. Essa observação é o gancho direto para a aula
seguinte (modelo do espaço vetorial com cosseno) e para os próximos
passos do semestre (BM25, embeddings), que tentam capturar informação que
o TF-IDF puro deixa passar.
