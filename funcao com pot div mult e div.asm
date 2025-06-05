.data
    digite_x: .asciiz "Digite x: "
    digite_z: .asciiz "Digite z: "
    digite_t: .asciiz "Digite t: "
    digite_y: .asciiz "Digite y: "
    erro_div_zero: .asciiz "Erro: z não pode ser zero!\n"
    resultado_msg: .asciiz "Resultado da função f = (x^y)/z - t: "
    valor_x: .asciiz "x = "
    valor_y: .asciiz "y = "
    valor_z: .asciiz "z = "
    valor_t: .asciiz "t = "

.text
main:
    # Lê x
    la $a0, digite_x
    li $v0, 4
    syscall
    li $v0, 6
    syscall
    mov.s $f1, $f0   # $f1 = x

    # Lê z
    la $a0, digite_z
    li $v0, 4
    syscall
    li $v0, 6
    syscall
    mov.s $f2, $f0   # $f2 = z

    # Verifica se z == 0
    mtc1 $zero, $f10
    c.eq.s $f2, $f10
    bc1t erro_zero

    # Lê t
    la $a0, digite_t
    li $v0, 4
    syscall
    li $v0, 6
    syscall
    mov.s $f3, $f0   # $f3 = t

    # Lê y (inteiro)
    la $a0, digite_y
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t0, $v0    # $t0 = y
    
    
    la $a0, valor_y
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    
    li $a0, '\n'
    li $v0, 11
    syscall

    # Calcula x^y
    li $t1, 1
    mtc1 $t1, $f4
    cvt.s.w $f4, $f4     # $f4 = 1.0 (base para acumular x^y)

    blez $t0, fim_potencia # y <= 0, então x^0 = 1

potencia_loop:
    mul.s $f4, $f4, $f1   # $f4 *= x
    addi $t0, $t0, -1
    bgtz $t0, potencia_loop

fim_potencia:
    # Calcula f = (x^y)/z - t
    div.s $f5, $f4, $f2   # $f5 = (x^y)/z
    sub.s $f6, $f5, $f3   # $f6 = f

    # Imprime valores
    la $a0, valor_x
    li $v0, 4
    syscall
    mov.s $f12, $f1
    li $v0, 2
    syscall

    li $a0, '\n'
    li $v0, 11
    syscall

    la $a0, valor_z
    li $v0, 4
    syscall
    mov.s $f12, $f2
    li $v0, 2
    syscall
    
    li $a0, '\n'
    li $v0, 11
    syscall

    la $a0, valor_t
    li $v0, 4
    syscall
    mov.s $f12, $f3
    li $v0, 2
    syscall
    
    li $a0, '\n'
    li $v0, 11
    syscall

    # Imprime resultado
    la $a0, resultado_msg
    li $v0, 4
    syscall
    mov.s $f12, $f6
    li $v0, 2
    syscall

    # Fim
    li $v0, 10
    syscall

erro_zero:
    la $a0, erro_div_zero
    li $v0, 4
    syscall
    li $v0, 10
    syscall
