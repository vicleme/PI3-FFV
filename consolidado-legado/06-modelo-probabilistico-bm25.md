# Modelo Probabilístico: BM25 (2026-09-12)

Código completo:
[`08-bm25.R`](../estrutura/codigo/08-bm25.R)
(corpus real, granularidade de parágrafo — reaproveita `tokenizar_limpo` de
[`03-corpus-cidades-tfidf-busca.R`](../estrutura/codigo/03-corpus-cidades-tfidf-busca.R)
e `cosseno` de
[`04-similaridade-cosseno-cidades.R`](../estrutura/codigo/04-similaridade-cosseno-cidades.R))

## O que foi feito

Tarefa oficial: implementar o BM25, comparar o ranking com o do TF-IDF
para 3 consultas, e variar `k1` e `b` observando o efeito na ordem dos
resultados. Aplicado ao mesmo corpus real de 63 parágrafos usado na aula
anterior, com `avgdl ≈ 39,8` palavras por parágrafo (min. 18, máx. 69) —
essa variação de tamanho é justamente o que o parâmetro `b` corrige.

Para as consultas `"porto industria"`, `"praia turismo"` e `"poluicao
industrial saude"`, BM25 e TF-IDF+cosseno **concordam no top 1 e no top 3**
nas três consultas — sinal de que os dois métodos captam o mesmo sinal
principal (raridade × frequência). A diferença aparece mais abaixo no
ranking: em `"praia turismo"`, por exemplo, o TF-IDF traz `Guaruja_p14`
para o 4º lugar (um parágrafo com bastante peso acumulado de termos
correlatos), enquanto o BM25 mantém `Guaruja_p6` nessa posição — a
saturação de frequência do BM25 limita quanto um documento longo e
repetitivo pode subir no ranking só por acumular menções.

Variando os parâmetros na consulta `"porto industria"`:

- **k1 = 0** (frequência ignorada, vira quase booleano): os empates
  aparecem — três parágrafos diferentes ficam com o mesmo escore
  (1,633), porque só a presença/ausência do termo importa.
- **k1 = 3** (satura devagar, mais perto do TF-IDF linear): parágrafos
  com mais repetições do termo (`Santos_p18`, `Santos_p19`) sobem no
  ranking.
- **b = 0** (tamanho do documento ignorado) vs. **b = 1** (normalização
  total): a ordem entre `Santos_p18` e os parágrafos vizinhos se inverte
  dependendo de quanto o tamanho do parágrafo é penalizado.

## O que isso representa para o projeto

O ponto central da aula — a saturação de frequência não foi *imposta*,
ela *emerge* da matemática do modelo 2-Poisson — se confirma no corpus
real: nenhum parágrafo do projeto é longo o bastante para que a diferença
entre TF-IDF e BM25 seja dramática, mas ela já aparece exatamente onde a
teoria prevê (a partir da 3ª/4ª posição do ranking, quando frequência
bruta e frequência saturada começam a divergir).

O experimento de variar `k1` e `b` é o mais importante para o projeto daqui
pra frente: ele mostra que o BM25 não é "um TF-IDF melhor" de forma fixa,
mas uma família de funções de ranqueamento com dois botões ajustáveis por
corpus. Isso também expõe uma limitação prática que vale registrar: com
apenas 63 parágrafos e um vocabulário concentrado em nomes das próprias
cidades, `k1 = 1,2` e `b = 0,75` (os valores padrão da literatura) não
foram validados empiricamente contra nenhum julgamento de relevância —
eles são um ponto de partida razoável, não um ótimo calibrado para este
corpus específico. Ajustar isso com dados reais de relevância é o gancho
natural para a próxima aula (avaliação: P@k, MAP, nDCG), que por sua vez é
o que permitiria comparar objetivamente TF-IDF e BM25 neste projeto, em
vez de comparar só "no olho" como foi feito aqui.
