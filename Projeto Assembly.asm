.data
fout: .asciiz "palavras.txt"
palavra: .asciiz
linha: .asciiz "\n"

.text
#ABERTURA DE ARQUIVO
li $v0, 13
la $a0, fout
li $a1, 0
li $a2, 0
syscall
move $s6, $v0

#LEITURA DE PALAVRA
lb $t0, linha		#GUARDA VALOR DA QUEBRA DE LINHA
addi $t1, $zero, 0	#DESLOCA NA MEMORIA
loop:
  li $v0, 14
  move $a0, $s6
  la $a1, palavra
  beq $a2, $t0, sailoop
  lb $a2, fout($t1)
  addi $t1, $t1, 1
  syscall
  j loop
sailoop:

#FECHAMENTO DE ARQUIVO
li $v0, 16
move $a0, $s6
syscall

#TESTE PARA SABER SE A PALAVRA FOI REALMENTE LIDA
li $v0, 4
move $a0, $a1
syscall
