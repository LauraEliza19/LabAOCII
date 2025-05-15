.data
	variavel_float1: .float 0
	variavel_float2: .float 0
	
	digite1: .asciiz "Digite o primeiro numero float: "
	digite2: .asciiz "Digite o segundo numero float: "
	
.text
main:
	la $a0, digite1
	li $v0, 4
	syscall
	
	li $v0, 6 #le float do teclado
	syscall
	
	la $t0, variavel_float1
	s.s $f0, 0($t0)
	mov.s $f1, $f0
	jal println_float
	
	la $a0, digite2
	li $v0, 4
	syscall
	
	li $v0, 6 #le float do teclado
	syscall
	
	la $t0, variavel_float2
	s.s $f0, 0($t0)
	mov.s $f2, $f0
	jal println_float
	
	add.s $f0, $f1, $f2
	jal println_float
	
	sub.s $f0, $f1, $f2
	jal println_float
	
	mul.s $f0, $f1, $f2
	jal println_float
	
	div.s $f0, $f1, $f2
	jal println_float
	
	abs.s $f0, $f1
	jal println_float
	
	neg.s $f0, $f1
	jal println_float
	
feito:
	li $v0, 10
	syscall
	
println_float:
	mov.s $f12, $f0
	li $v0, 2
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	jr $ra
	
println_int:
	move $a0, $t0
	li $v0, 1
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	jr $ra
	
.end main