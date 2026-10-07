# Consolidado: PI III, Aula 5,5, Parte D: 2026-10-06
*guia versão 1 · tutora: Claude · sessão 2 de 2*
**Equipe:** Victor, Flávia e Felipe · sessão conduzida na conta do Victor

## 1. O que foi passado
- M10: do `qrels.csv` ao vetor `rel`; `read.csv` e `setNames`; o limiar de binarização; não julgado vale grau 0 (*pooling*)
- M11: as cinco métricas, BM25 e cosseno, numa consulta (q02); `is.na` no nDCG graduado
- M12: todas as consultas de desenvolvimento, tabela-resumo, MAP e MRR dos dois sistemas, e o vencedor com ressalva

## 2. Como foi o aprendizado: opinião da tutora
Minha leitura: a equipe trabalha bem quando a decisão é dela e a conta vem em seguida. Não sei quantas pessoas responderam nesta sessão, então registro tudo como resposta da equipe. O limiar (grau $\geq 2$) foi escolhido antes de calcular qualquer métrica, com uma justificativa própria: o grau 1 "toca o assunto mas não responde". Os parágrafos não julgados foram tratados como grau 0 sem reclamar, e a equipe separou as consultas em desenvolvimento e teste, deixando o teste lacrado. O vencedor foi declarado pela equipe, com ressalva: o BM25 ficou na frente em uma consulta, empatou nas outras seis, e isso não basta para dizer que os sistemas diferem. A equipe corrigiu a minha leitura em dois pontos: a consulta em que os sistemas se separam é a q02, e não a q05, e o termo $1/\log_2(i+1)$ é um fator que multiplica o ganho, e não um desconto, por isso passou a se chamar fator de desconto. Pediu também que o notebook ficasse como arquivo final, para quem chega ao fim, sem notas de andamento, e que cada célula nova tivesse texto explicando para que serve. A equipe preferiu conferir tudo no Colab antes de gravar, e só fechou o commit depois, para não registrar versões intermediárias. O que foi entregue em vez de construído: a reimplementação do BM25 com $k_1$ e $b$ como argumentos, usada para ligar e desligar a saturação e a normalização de tamanho, e o texto da conclusão, organizado por mim a partir do que a equipe já tinha decidido.

## 3. Observações para a frente
- **Revisar antes da Aula 06:** por que seis de sete consultas empatam (os relevantes caem nas mesmas posições, e as consultas são fáceis), e o que um empate diz e não diz sobre os sistemas.
- **Para a próxima tutora:** a equipe decide o limiar e o vencedor, e quer isso respeitado. Termos técnicos devem ser explicados antes de usados. Texto escrito pela tutora sem travessão (vírgula no lugar). Registrar sempre como equipe. Não gravar versões intermediárias no repositório.
- **Perguntas guardadas:** a diferença entre os sistemas é mais do que acaso? Exige teste estatístico sobre os APs por consulta, Aula 16.
- **Produzido:**
  - Limiar: grau $\geq 2$, igual para os dois sistemas e todas as consultas, com o motivo acima.
  - Tabela-resumo das 7 consultas de desenvolvimento: BM25 na frente em 1 (q02), em AP, RR, nDCG binário e nDCG graduado; empate nas outras 6; cosseno em nenhuma; empate no P@3 nas 7.
  - Médias (cosseno / BM25): MAP $0{,}573$ / $0{,}597$; MRR $0{,}567$ / $0{,}591$; nDCG binário (ranking inteiro) $0{,}673$ / $0{,}692$; nDCG graduado (ranking inteiro) $0{,}672$ / $0{,}687$; P@3 $0{,}333$ nos dois.
  - Explicação da q02: o relevante fica em 2º no BM25 e em 3º no cosseno; à frente dele no cosseno está um parágrafo longo que repete "praias" e não traz "santos"; o teste que liga e desliga a saturação e a normalização de tamanho confirma, e a normalização é a que mais protege o relevante.
  - Ressalva escrita: a vantagem vem de uma consulta só, e o empate mostra que a medida não separa os sistemas, e não que eles são equivalentes.
  - Notebook `12b-metricas-estudo.ipynb` final, com as consultas de teste (q01, q04, q08) lacradas.
