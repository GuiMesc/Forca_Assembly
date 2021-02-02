.data
fout: .asciiz "palavras.txt"
linha: .asciiz "\n"
palavra: .asciiz

.text
#GERAR NUMERO ALEATORIO ENTRA AS 10 PALAVRAS
li $v0, 42
addi $a0, $a0, 1
addi $a1, $a1, 10
syscall
add $t1, $zero, $a0	#GUARDA VALOR ALEATORIO GERADO EM $T1

#ABERTURA DE ARQUIVO
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
beq $t4, $t1, saiwhile
la $a1, palavra		#CARREGA O ENDEREÇO NOVAMENTE PARA SOBRESCREVER A PALAVRA QUANDO FOR PARA OUTRA LINHA
 whilePalavra:
   li $v0, 14
   move $a0, $s6
   addi $a2, $zero, 1
   syscall
   lb $t3, 0($a1)		#LE CARACTERE A CARACTERE E GUARDA EM $T3, INCREMENTANDO O ENDEREÇO DA PALAVRA
   beq $t3, $t2, whileLinha	#QUANDO ENCONTRA A QUEBRA DE LINHA, VAI PARA "WHILELINHA" E AVANÇA PARA A PROXIMA
   addi $a1, $a1, 1
   j whilePalavra
saiwhile:
  
#FECHAMENTO DE ARQUIVO
li $v0, 16
move $a0, $s6
syscall

#IMPRIMIR STRING LIDA PARA TESTE
li $v0, 4
la $a1, palavra
move $a0, $a1
syscall