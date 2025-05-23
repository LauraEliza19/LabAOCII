.data
prompt:  .asciiz "Digite o primeiro octeto do endereço IPv4 (0-255):\n"
classA:  .asciiz "Classe A\n"
classB:  .asciiz "Classe B\n"
classC:  .asciiz "Classe C\n"
error:   .asciiz "Valor fora do intervalo válido (0-255)!\n"

.text 
main:
    li $v0, 4 #print string
    la $a0, prompt
    syscall

    # Lê o valor do primeiro octeto
    li $v0, 5          #ler inteiro     
    syscall
    move $t0, $v0             

    # Verifica se o valor está no intervalo válido (0-255)
    blt $t0, 0, error_range
    bgt $t0, 255, error_range

    blt $t0, 128, class_a

    blt $t0, 192, class_b

    blt $t0, 256, class_c

    j error_range

class_a:
    # "Classe A"
    li $v0, 4
    la $a0, classA
    syscall
    j end_program

class_b:
    # "Classe B"
    li $v0, 4
    la $a0, classB
    syscall
    j end_program

class_c:
    # "Classe C"
    li $v0, 4
    la $a0, classC
    syscall
    j end_program

error_range:
    li $v0, 4
    la $a0, error
    syscall

end_program:
    li $v0, 10
    syscall
