.data
fout: .asciiz "palavras.txt"
palavra: .asciiz

.text
#ABERTURA DE ARQUIVO
li $v0, 13
la $a0, fout
li $a1, 0
li $a2, 0
syscall
move $s6, $v0

#LEITURA DE PALAVRA
li $v0, 14
move $a0, $s6
la $a1, palavra
li $a2, 7
syscall

#FECHAMENTO DE ARQUIVO
li $v0, 16
move $a0, $s6
syscall

#TESTE PARA SABER SE A PALAVRA FOI REALMENTE LIDA
li $v0, 4
move $a0, $a1
syscall
