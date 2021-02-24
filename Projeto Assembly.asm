.data
fout: .asciiz "palavras.txt"
linha: .asciiz "\n"
apresentacao: .asciiz "\t\t\-----JOGO DA FORCA-----\n\n"
pontuacao: .asciiz "SCORE: "
pede.letra: .asciiz "\n\n\nINFORME UMA LETRA: "
mensagem1: .asciiz "PARABÉNS!! VOCÊ GANHOU"
mensagem2: .asciiz "QUE PENA... TENTE OUTRA VEZ"
mensagem3: .asciiz "UTILIZADAS: "
mensagem4: .asciiz "A PALAVRA ERA: "
tabulacao: .asciiz "\t\t\t  "
traco: .asciiz "-"
espaco: .asciiz " "
vetorAUX: .space 50
usadas: .space 50
palavra: .space 50
letra: .space 1
mensagemAUX: .asciiz
mensagemAUX2: .asciiz

.text

#=========================================ESCOLHER PALAVRA ALEATORIA DO ARQUIVO==========================================================

#GERAR NUMERO ALEATORIO ENTRA AS 50 PALAVRAS
li $v0, 42
addi $a0, $a0, 1
addi $a1, $a1, 50
syscall
# se for igual a 0, soma +1 para evitar loop infinito
beq $a0, $zero, else
add $t1, $zero, $a0	#GUARDA VALOR ALEATORIO GERADO EM $T1
j arquivo
else:
addi $a0, $a0, 1
add $t1, $zero, $a0

#ABERTURA DE ARQUIVO
arquivo:
li $v0, 13
la $a0, fout
li $a1, 0
li $a2, 0
syscall
move $s6, $v0

#LEITURA DA PALAVRA
lb $t2, linha	#GUARDA O CARACTERE LINHA EM $T2
la $a1, palavra
j whilePalavra
whileLinha:
addi $t4, $t4, 1	#CONTADOR PARA RODAR A MESMA QUANTIDADE DE VEZES DO NUMERO ALEATORIO GERADO
sb $zero, 0($a1)
beq $t4, $t1, saiwhile
li $t5, 0
la $a1, palavra		#CARREGA O ENDEREÇO NOVAMENTE PARA SOBRESCREVER A PALAVRA QUANDO FOR PARA OUTRA LINHA
 whilePalavra:
   li $v0, 14
   move $a0, $s6
   addi $a2, $zero, 1
   syscall
   lb $t3, 0($a1)		#LE CARACTERE A CARACTERE E GUARDA EM $T3, INCREMENTANDO O ENDEREÇO DA PALAVRA
   addi $t5, $t5, 1		#VARIAVEL PARA CONTAR A QTD DE LETRAS NA PALAVRA, UTIL PARA COLOCAR NO TAMANHO DO VETOR
   beq $t3, $t2, whileLinha	#QUANDO ENCONTRA A QUEBRA DE LINHA, VAI PARA "WHILELINHA" E AVANÇA PARA A PROXIMA
   addi $a1, $a1, 1
   j whilePalavra
saiwhile:
sub $t5, $t5, 2
  
#FECHAMENTO DE ARQUIVO
li $v0, 16
move $a0, $s6
syscall

la $s0, palavra		#GUARDAR ENDEREÇO DA PALAVRA EM OUTRO REG., PORQUE $A0 SERA SOBRESCRITO POSTERIORMENTE
#===========================================================================================================================

#================================================JOGO DA FORCA==============================================================
#imprime titulo
li $v0, 4
la $a0, apresentacao
syscall

#formatacao
li $v0, 4
la $a0, tabulacao
syscall

#escondendo palavra escolhida
la $t6, vetorAUX
loop:
beq $s3, $t5, imprimeVetor
la $s1, traco
lb $s2,($s1)
sb $s2,($t6)
add $t6, $t6, 1
add $s3, $s3, 1
j loop

imprimeVetor:
li $v0, 4
la $a0, vetorAUX
syscall

move $t2, $s0	#libera $s0 e guarda endereço de palavra em $t2
la $t3, vetorAUX
li $s0, 6	#quantidade de vidas
li $s1, 1	#flag para as vidas
li $s4, 0	#contador
lb $s2,($t2)
lb $s3,($t3)
la $s5, traco
lb $s6, ($s5)
la $s7, usadas

pedeLetra:
li $v0, 4
la $a0, pede.letra
syscall

#syscall para ler um único caractere
li $v0, 8
la $a0, letra
syscall

lb $t8, ($a0)	#carrega o byte da letra lida
sb $t8, ($s7)	#guarda o byte no vetor de letras usadas
li $s1, 1
li $s4, 0
la $t3, vetorAUX

verificaçao:
bne $t8, $s2, proxima	#compara o byte lido com o byte da palavra escolhida, em sua atual posição de memória

certa:
li $s1, 0
sb $t8, ($t3)		#guarda a letra lida no VetorAUX
add $t2, $t2, 1
add $t3, $t3, 1
lb $s2,($t2)		#linha 138-141: incrementa os endereços dos vetores e carrega o byte da atual posição pós-incremento
lb $s3,($t3)
add $s4, $s4, 1
beq $s4, $t5, letras
j verificaçao

proxima:
add $t2, $t2, 1
add $t3, $t3, 1
lb $s2,($t2)
lb $s3,($t3)
add $s4, $s4, 1
beq $s4, $t5, letras
j verificaçao

letras:
li $s4, 0
li $t9, 0
la $t2, palavra
la $t3, vetorAUX
lb $s2,($t2)
lb $s3,($t3)

#utilizadas:
#blt $t7, 64, Verifica_Fim	#tentativa falha de tratamento de erro com numeros e caracteres especiais
#add $t9, $t9, 1
#add $s7, $s7, 1
#lb $t7, ($s7)

Verifica_Fim:
beq $s3, $s6, score	#compara o traço com o byte atual do vetorAUX
beq $s4, $t5, fim1
add $t3, $t3, 1
lb $s3,($t3)
add $s4, $s4, 1
j Verifica_Fim

score:
bne $s1, 0, derrota

scoreAUX:

Imprime_repete:
li $v0, 4
la $a0, linha
syscall

li $v0, 4
la $a0, tabulacao
syscall

li $v0, 4
la $a0, vetorAUX
syscall

li $v0, 4
la $a0, linha
syscall

li $v0, 4
la $a0, mensagem3
syscall

li $v0, 4
la $a0, usadas
syscall

li $v0, 4
la $a0, linha
syscall

li $v0, 4
la $a0, pontuacao
syscall

li $v0, 1
move $a0, $s0
syscall

add $s7, $s7, 1
j pedeLetra

derrota:
beq $s0, 0, fim2
sub $s0, $s0, 1
j scoreAUX

fim1:
li $v0, 4
la $a0, linha
syscall

li $v0, 4
la $a0, linha
syscall

li $v0, 59
la $a0, mensagem1
la $a1, mensagemAUX
syscall

li $v0, 10
syscall

fim2:
li $v0, 4
la $a0, linha
syscall

li $v0, 4
la $a0, linha
syscall

li $v0, 59
la $a0, mensagem2
la $a1, mensagemAUX2
syscall

#imprime palavra errada, em caso de derrota
#formatacao
li $v0, 4
la $a0, tabulacao
syscall

li $v0, 4
la $a0, mensagem4
syscall

li $v0, 4
la $a0, palavra
syscall

li $v0, 10
syscall
