# Separação teste/desenvolvimento e desvios do guia (2026-09-25)

Código completo:
[`14-separar-teste-desenvolvimento.R`](../estrutura/codigo/14-separar-teste-desenvolvimento.R)

## O que foi feito

Antes de julgar as consultas, o grupo parou para resolver uma pendência 
do Módulo 8 do guia: **a separação teste/desenvolvimento tem que ser decidida 
antes do primeiro julgamento**, porque não tem conserto depois.

### 1. Classificação de dificuldade

Cada uma das 10 consultas foi conferida à mão contra `estrutura/corpus/*.txt`
e classificada por **distância léxica** entre a consulta e o parágrafo que
responde — o mesmo critério do Módulo 6 (*casamento léxico ≠ relevância*):

| grupo | consultas | por quê |
|---|---|---|
| **fácil** | q01, q02, q03, q06, q10 | a resposta usa quase as mesmas palavras da consulta, num parágrafo só, sem concorrente próximo (ex.: q10 — "balsas da Travessia Santos-Guarujá" aparece quase *verbatim*) |
| **médio** | q05, q08, q09 | a resposta existe, mas exige um sinônimo (q05: "tamanho" → "área") ou tem um distrator no mesmo documento que compartilha vocabulário (q09: "Censo" aparece literal, mas o mesmo texto também cita uma estimativa do IBGE de 2023 — não censitária — sobre a mesma cidade) |
| **difícil** | q04, q07 | o termo exato da consulta não existe em lugar nenhum do corpus, ou há vários candidatos plausíveis. q04 ("polo industrial") nunca aparece — a informação está espalhada em "parque industrial" (Cubatão) e "maior distrito industrial do país" (Guarujá, falando de Cubatão). q07 tem 4 anos candidatos no mesmo parágrafo (1803, 1833, 1841, 1949); só 1949 é a emancipação — os outros são povoado e incorporação a Santos |

### 2. Sorteio estratificado, proporção 70/30

Com 10 consultas, 70/30 dá 7 desenvolvimento / 3 teste. Em vez de sortear
3 entre as 10 de uma vez (risco de sair as 3 fáceis, ou as 3 do mesmo
assunto), sorteamos **1 de cada faixa de dificuldade** — 1 fácil, 1 média,
1 difícil — para o teste, garantindo que o relatório final seja avaliado
contra um pouco de cada nível.

Resultado do sorteio (seed fixa `2026`, documentada no script, para
qualquer pessoa do grupo poder auditar):

| conjunto | consultas |
|---|---|
| **teste** (não se olha até o relatório final) | q01 (fácil), q08 (médio), q04 (difícil) |
| **desenvolvimento** | q02, q03, q05, q06, q07, q09, q10 |

> Nota sobre reprodutibilidade: o ambiente usado para gerar este documento
> não tinha R disponível, então o sorteio acima foi rodado uma vez em
> Python com o mesmo procedimento e a mesma seed (2026). `14-separar-teste-
> desenvolvimento.R` faz a mesma coisa nativamente em R — ao rodar no
> RStudio do grupo, o gerador de números aleatórios do R não é
> necessariamente idêntico ao do Python, então o sorteio pode sair
> diferente. **Vale o que o script der quando rodado no R do grupo**; se
> divergir do resultado acima, regravem `split_teste_desenvolvimento.csv`
> com a saída do R e atualizem esta tabela. O que importa para a validade
> do experimento não é reproduzir o mesmo Python usado aqui, é que a
> decisão tenha sido tomada **uma vez, antes de julgar**, com um critério
> auditável — não escolhida a dedo.

### 3. Duas pendências de documentação, resolvidas aqui

**(a) 10 consultas em vez de 15–25.** O guia (Entregável 2) pede
15 a 25 necessidades. O grupo fez 10 (q01–q10) e decidiu parar aí depois
de perceber o ponto (b) abaixo: com um corpus de só 3 documentos/63
parágrafos, julgar 100% do corpus para cada consulta — em vez da amostra
de 20% prevista pelo guia — já multiplicou o esforço por consulta. Ampliar
para 15–25 consultas mantendo julgamento de 100% inviabilizaria o prazo do
grupo. É uma troca consciente: menos consultas, mais completas, em vez de
mais consultas, mais superficiais.

**(b) Julgamento de 100%, não 80/20.** Já documentado em
[`09-concordancia-kappa.R`](../estrutura/codigo/09-concordancia-kappa.R):
o guia sugere que 20% da pool seja julgada em duplicata (para medir kappa)
e o resto dividido entre os juízes. O grupo (victor, flavia, felipe)
julgou os 63 parágrafos inteiros para cada consulta, individualmente —
overlap de 100%. Isso deixa o kappa mais robusto (calculado sobre todo o
gabarito, não uma amostra), ao custo de 3x mais julgamentos por pessoa.
Essa decisão continua valendo para q06–q10.

## O que isso representa para o projeto

A partir daqui, `estrutura/ferramenta/julgar.html` pode ser aberto para
julgar sabendo, de antemão, quais 3 consultas são teste. As 7 de desenvolvimento 
são onde o grupo pode errar, ajustar `k1`/`b` do BM25, comparar TF-IDF x BM25 e 
testar ideias nas próximas aulas — as 3 de teste ficam fechadas até o relatório final,
inclusive quando a Aula 09 (learning to rank) transformar o gabarito em
rótulo de treino.