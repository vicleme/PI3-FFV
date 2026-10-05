# Modelo do Espaço Vetorial (2026-08-25)

Código completo:
[`06-modelo-espaco-vetorial-toy.R`](../estrutura/codigo/06-modelo-espaco-vetorial-toy.R)
(corpus de brinquedo) ·
[`03-corpus-cidades-tfidf-busca.R`](../estrutura/codigo/03-corpus-cidades-tfidf-busca.R) e
[`04-similaridade-cosseno-cidades.R`](../estrutura/codigo/04-similaridade-cosseno-cidades.R)
(corpus real das cidades, reaproveitados sem duplicação)

## O que foi feito

Tarefa oficial: reaproveitar o corpus de 8 documentos das aulas
anteriores, implementar a matriz TF-IDF e a função de similaridade de
cosseno do zero, e escolher 3 consultas para reportar o ranking de
documentos de cada uma.

As três consultas testadas foram "modelo de recuperacao", "busca e
avaliacao de relevancia" e "ciencia de dados e aprendizado estatistico".
Na segunda parte do notebook, o mesmo método (TF-IDF + cosseno) foi
reaplicado ao corpus real de Santos, Cubatão e Guarujá — repetição
intencional do que já havia sido implementado na atualização de 25/08 do
notebook de Recuperação de Informação, então o código dessa parte não foi
duplicado neste repositório; ele vive só em
`03-corpus-cidades-tfidf-busca.R` e `04-similaridade-cosseno-cidades.R`.

## O que isso representa para o projeto

Esta é a aula em que o projeto passa de "responder sim/não" (busca
booleana) para "medir o quanto" um documento combina com a consulta. Os
três rankings do corpus de brinquedo mostram isso de formas diferentes:

- Em **"modelo de recuperacao"**, os documentos mais próximos são
  tematicamente próximos entre si (d1, d3, d4), o resultado "esperado".
- Em **"busca e avaliacao de relevancia"**, um único documento (d7)
  domina o ranking porque é o único que reúne quase todos os termos da
  consulta ao mesmo tempo — o mesmo documento que já havia concentrado os
  bits de evidência na aula de teoria da informação.
- Em **"ciencia de dados e aprendizado estatistico"**, dois documentos
  ficam próximos e acima de um terceiro por grau, não por presença ou
  ausência simples — diferença que a busca booleana da primeira aula não
  conseguiria expressar.

Reaplicar o mesmo método ao corpus real das cidades fecha o ciclo do
projeto até aqui: o mesmo pipeline (tokenizar → TDM → TF-IDF → cosseno)
que funciona em 8 frases artificiais funciona, sem alteração de lógica,
sobre texto real da Wikipédia. É também a confirmação prática de que a
limitação vista na aula anterior (rotas com IDF zero) é sobre a *falta de
contraste* no vocabulário, e não sobre o método em si — o corpus real das
cidades tem vocabulário rico o bastante para o cosseno discriminar bem
entre Santos, Cubatão e Guarujá.
