.data
    msg_paridade: .asciiz "Bit de paridade (para paridade PAR): "

.text
    main:
        # Carrega a palavra de 32 bits no registrador $s0
        li $s0, 0x0000001f    # 00001110

        li $t0, 0             # Contador de bits 1
        li $t1, 32            
        
    calc_paridade:
        beqz $t1, done         

        # XOR o bit menos significativo de $s0 com o contador de bits 1
        andi $t2, $s0, 1      # Pega o bit menos significativo de $s0
        xor  $t0, $t0, $t2    # Realiza XOR com o contador de bits 1

        srl  $s0, $s0, 1      # Desloca a palavra para a direita (descarta o bit analisado)
        subi $t1, $t1, 1      # Decrementa o contador de bits restantes
        j calc_paridade

    done:
        andi $t3, $t0, 1      # Se $t0 for ímpar (1), então t3 = 1, caso contrário t3 = 0

        # Imprime a mensagem
        li $v0, 4
        la $a0, msg_paridade
        syscall

        # Imprime o valor do bit de paridade
        li $v0, 1
        move $a0, $t3
        syscall

        # Finaliza o programa
        li $v0, 10
        syscall
