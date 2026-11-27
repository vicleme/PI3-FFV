# Consolidado — PI III — Aula 08 — Tema 8 (posição e título) — 2026-11-26
*guia do tema 8 versão 1 · tutora: Gemini · motor08*
**Aluno / grupo:** Felipe

## 1. O que foi passado
- M1 — bônus de início: `d1` 2, `d2` 2, `d8` 1
- M2 — $\text{BM25} + \beta \cdot \text{ini}$: AP $0{,}833 \to 0{,}583$
- M3 — BM25F (repetir o começo); título igual na página
- M4 — corpus do grupo: não feito

## 2. Como foi o aprendizado — opinião da tutora
O aluno acompanhou os conceitos passo a passo com clareza, realizando corretamente as contagens manuais do bônus de início ($\text{ini}$) e compreendendo como o fator de escala $\beta$ altera o ranking no estágio 2 e por que derruba as métricas nos 8 documentos do curso. Teve boa intuição sobre a redundância gerada pelo título compartilhado entre parágrafos da mesma página, restando apenas fixar que esse empate preserva a ordenação original do estágio 1 dentro do bloco promovido. Dominou também a disciplina metodológica de selecionar hiperparâmetros exclusivamente no conjunto de desenvolvimento (`dev`), mantendo o `teste` apenas para relato final.

**Teste final:** acertou M1, M2 e M4; a revisar M3.

## 3. Observações para a frente
- **Revisar:** efeito de empate no reordenamento por título (os parágrafos da página sobem em bloco e mantêm entre si a ordem do estágio 1).
- **Perguntas guardadas:** nenhuma.
- **Produzido:** `inicio`, `titulo`; experimento no corpus do grupo pendente de execução no Colab.