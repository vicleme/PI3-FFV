# 01-intro-r.R
# Aula: Introdução ao R (2026-08-07)
# Exercícios de treino: vetores, funções, apply, factor/table, regex.
# Ver Consolidado/01-introducao-ao-r.md para a interpretação de cada bloco.

## Bloco 1: vetores e funções básicas ------------------------------------
v <- c(10, 20, 30, 40)
v
sum(v)

notas <- c(ana = 8, bruno = 6, carla = 9)
notas["bruno"]

frase <- "recuperacao de informacao"
toupper(frase)
strsplit(frase, " ")
unlist(strsplit(frase, " "))

dobro <- function(x) {
  x * 2
}
dobro(7)

## Bloco 2: listas e apply -------------------------------------------------
palavras1 <- list(a = c("x", "y", "z"), b = c("p", "q"))
lapply(palavras1, length)
sapply(palavras1, length)

## Bloco 3: factor/table e matrizes ----------------------------------------
tokens <- c("de", "casa", "de", "rua")
table(tokens)

vocab <- c("casa", "de", "rua", "praia")
table(factor(tokens, levels = vocab))

m <- matrix(1:4, nrow = 2)
rownames(m) <- c("lin1", "lin2")
colnames(m) <- c("c1", "c2")
m

peso <- c(2, 3)
m * peso

c("casa", "aviao") %in% vocab

## Bloco 4: regex ------------------------------------------------------------
palavras2 <- c("casa", "cachorro", "praia", "cidade")
grep("^ca", palavras2, value = TRUE)
grepl("a$", palavras2)
sub("a", "@", "banana")
gsub("a", "@", "banana")

## Alterando e antecipando o resultado (reciclagem de vetores) -------------
pesonovo <- c(2, 3, 4)
m * pesonovo # aviso: comprimentos incompatíveis, reciclagem interrompida no meio de um ciclo

mnovo <- matrix(1:6, nrow = 2)
rownames(mnovo) <- c("lin1", "lin2")
colnames(mnovo) <- c("c1", "c2", "c3")
mnovo

mnovo * peso        # cada valor de peso multiplica uma linha inteira
mnovo * pesonovo     # reciclagem: pesonovo vira [2,3,4,2,3,4]

## Para casa — perguntas para investigar ------------------------------------
lapply(palavras1, length)               # sapply <-> lapply: vetor/matriz vs. lista
table(factor(tokens, levels = vocab))   # com factor: mostra termos com contagem 0
table(tokens)                            # sem factor: só os termos que aparecem

m <- matrix(1:4, nrow = 2)
rownames(m) <- c("lin1", "lin2")
colnames(m) <- c("c1", "c2")
peso3 <- c(2, 3, 5)
m * peso3   # 4 não é múltiplo de 3: reciclagem incompleta, R emite warning

## 5 missões: limpeza de manchetes com regex --------------------------------
manchetes <- c(
  "Porto de Santos bate recorde em julho - A Tribuna",
  "cubatao registra melhora na qualidade do ar - A Tribuna",
  "Guaruja tera nova linha de onibus em 2026 - A Tribuna",
  "Sao Vicente inaugura escola no Parque Bitaru - A Tribuna",
  "Santos e Guaruja discutem travessia de balsa - A Tribuna"
)

frases_limpas <- sub(" - A Tribuna$", "", manchetes)
frases_limpas

gsub("\\s{2,}", " ", frases_limpas)

grep("[0-9]{4}", frases_limpas, value = TRUE)

grep("Guaruja|Cubatao", frases_limpas, ignore.case = TRUE, value = TRUE)

grepl("Santos", frases_limpas) # pegadinha: uma das ocorrências é "Porto de Santos", não a cidade
