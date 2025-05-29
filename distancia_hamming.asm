.data
	DNA: .asciiz "GAGCCTACTAACGGGAT"
	entrada_usuario: .asciiz "\nDigite a sequencia de DNA\n"
	msg_erro_tam: .asciiz "\nAs sequencias tem tamanho diferente"
	msg_erro_char: .asciiz "\nSequencia com caracteres invalidos"
	msg_resultado: .asciiz "\nDistancia de Hamming: \n"
	entrada_user: .space 100
.text
.main
	 li $v0, 4
      la $a0, entrada_usuario
      syscall
      
      li $v0, 8
      la $a0, entrada_user
      li $a1, 100
      syscall
      
      la $s0, DNA
      la $s1, entrada_user
      li $t2, 0
      
      la $t0, entrada_user
      
      comparar_loop:
      	lb $t3, 0($s0)
		lb $t4, 0($s1)
		
		beq $t3, 0, fim_compara
		beq $t4, 0, erro_tam
		
		li $t5, 'A'
		li $t6, 'C'
		li $t7, 'G'
		li $t8, 'T'
		
		bne $t4, $t5, checkC
		j check_diferenca
		
	checkC:
		bne $t4, $t6, checkG
		j check_diferenca
	checkG:
		bne $t4, $t7, checkT	
		j check_diferenca	
	checkT:
		bne $t4, $t8, erro_caracter
		
	check_diferenca:
		bne $t3, $t4, incrementar
		j proximo
	incrementar:
		addi $t2, $t2, 1
	proximo:
		addi $s0, $s0, 1
		addi $s1, $s1, 1
		j comparar_loop
	fim_compara:
		#lb $t4, 0($s1)
		#bne $t4, 0, erro_tam
		
	li $v0, 4
	la $a0, msg_resultado
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 10
	
	erro_tam:
		li $v0, 4
		la $a0, msg_erro_tam
		syscall
	
		li $v0, 10
		syscall
		
	erro_caracter:
		li $v0, 4
		la $a0, msg_erro_char
		syscall
	
		li $v0, 10
		syscall
.end main