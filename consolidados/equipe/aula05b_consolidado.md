# Consolidado — PI III — Aula 5,5 — 2026-10-05
*guia versão 1 · tutora: Claude · sessão 1 de 2*
**Equipe:** Victor, Flávia e Felipe · sessão conduzida na conta do Victor

## 1. O que foi passado
- M1 — `rel`: gabarito na ordem do ranking
- M2 — precisão e recall; a tabela de contingência ignora a ordem
- M3 — o @$k$ como corte
- M4 — P@$k$ e R@$k$; dente de serra; `cumsum`
- M5 — AP passo a passo; a pegadinha do divisor; MAP
- M6 — MRR: só o primeiro
- M7 — nDCG: por que $\log_2(i+1)$; binário à mão = 0,920
- M8 — nDCG graduado = 0,951; as cinco lado a lado
- M9 — qual métrica; três armadilhas

## 2. Como foi o aprendizado — opinião da tutora
Minha leitura: a equipe aprende melhor com passos pequenos e contas feitas parcela a parcela. Não sei quantas pessoas responderam nesta sessão, que correu na conta do Victor, então registro tudo como resposta da equipe. Quem respondeu montou o `rel` à mão logo no começo e fez o DCG, o IDCG e a divisão do nDCG, binário e graduado, batendo com o R nas duas versões. Os tropeços foram de atenção e foram achados quando se voltou à expressão: o tamanho do vetor `rel` (sete números em vez de oito), o denominador da precisão (usou 8 em vez de $k$), o $i+1$ dentro do log (usou 5 e 10 em vez de 6 e 11) e um numerador errado numa parcela. Na primeira tentativa do `g`, veio o vetor já ordenado por grau, em vez de seguir a ordem do ranking. Ao comparar as cinco métricas, o nDCG graduado foi apontado como o maior, quando o maior era o MRR, e a diferença entre binário e graduado foi explicada como regra geral. Para o AP, o método estava certo e o divisor $R$ só ficou claro depois de uma segunda explicação, com um exemplo de 10 relevantes. A equipe pede explicação quando um termo é novo ("de onde saiu o ganho e o desconto?") e avisa quando uma resposta minha não ajuda, e isso melhorou a sessão. O volume da conversa pesou, e pediu-se uma cola de consulta, entregue em um documento à parte. Na primeira pergunta do teste a resposta veio idêntica à cola; a partir da segunda, com as próprias palavras. O que foi entregue em vez de construído: só a ideia do ranking ideal do nDCG, que a equipe já tinha proposto sem saber o nome.

**Teste final:** a equipe acertou M1, M2, M4, M6, M7 e M8; a revisar M3, M5 e M9.
- M3 — faltou o porquê do corte: o sistema devolve uma lista ordenada, e não um conjunto.
- M5 — só acertou depois de reexplicação; faltou que o relevante não recuperado entra valendo zero e que o AP embute o recall.
- M9 — acertou as duas armadilhas; o erro comum (tratar um número como se não tivesse variância) só veio depois de reexplicação.

## 3. Observações para a frente
- **Revisar antes da Aula 06:** M3 (por que o @$k$ existe), M5 (divisor $R$ e o zero do não recuperado) e M9 (variância). São três "porquês", e não contas.
- **Para a próxima tutora:** a equipe alterna entre responder isolada, compartilhando depois, e responder junta em sala, num só computador e numa só conta. Registrar sempre como equipe. Ritmo de passos pequenos, uma conta por mensagem. Conferir sempre o tamanho dos vetores, o denominador da precisão e o $i+1$ do log. Responde bem quando o exemplo vem do projeto do grupo. Há uma cola de consulta em documento à parte.
- **Perguntas guardadas:** como saber se MAP $0{,}84$ é melhor que $0{,}83$ — Aula 16.
- **Produzido:** as cinco métricas conferidas à mão no ranking do BM25 (P@3, AP, MRR, nDCG binário e nDCG graduado). Rankings alternativos explorados: `d1 d2 d3 d4 d5 d6 d7 d8` e `d3 d2 d1 d4 d8 d6 d5 d7`. Gabarito alternativo: `d1` com grau 2, o que leva o nDCG graduado a $0{,}984$.
- **Parte D (gabarito próprio):** não feita ainda; começa logo em seguida.