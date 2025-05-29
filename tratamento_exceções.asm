.text
.globl main

main:
    # Exceção 13 (TRAP_EXCEPTION)
    teqi $t0, 0         # Gera TRAP se $t0 == 0

    # Exceção 5 (ADDRESS_EXCEPTION_STORE)
    li $t1, 5
    sw $t1, 3($zero)    # Endereço desalinhado (não múltiplo de 4) => exceção de store

    # Encerramento normal, se não houver exceção
    li $v0, 10
    syscall


# Exception handler
.ktext 0x80000180

    move $k0, $v0       # Salva $v0
    move $k1, $a0       # Salva $a0

    mfc0 $a0, $13       # $a0 = registrador Cause
    srl  $a0, $a0, 2    # desloca para direita para alinhar os bits do código da exceção
    andi $a0, $a0, 0x1F # isola os bits [6:2] (5 bits do código da exceção)

    li $v0, 1           # Serviço de print de inteiro
    syscall             # imprime o código da exceção

    la $a0, msg
    li $v0, 4           # Serviço de print de string
    syscall             # imprime a mensagem

    move $v0, $k0       # Restaura $v0
    move $a0, $k1       # Restaura $a0

    mfc0 $k0, $14       # Endereço da instrução causadora
    addi $k0, $k0, 4    # Pula para próxima instrução
    mtc0 $k0, $14       # Armazena novo endereço em EPC
    eret                # Retorna da exceção

.kdata
msg:
    .asciiz " <- Código da exceção gerado\n"
