.data
    S1: .asciiz "Qualquer texto a ser analisado"
    encontrou: .asciiz "\nEncontrou o caracter "
    nao_encontrou: .asciiz "\nNao encontrou"
    vezes: .asciiz " vez(es)"
    digite: .asciiz "Digite um caracter: "
    resultado: .asciiz "\nString modificada: "

.text
main:
    la $a0, digite         # Carregar mensagem "Digite um caracter"
    li $v0, 4
    syscall
    
    li $v0, 12             # Leitura do caracter
    syscall
    
    move $a0, $v0          # O caractere digitado está em $v0, movendo para $a0
    la $a1, S1             # Carregar o endereço da string S1
    
    jal encontra_caracter  # Chamar o procedimento para procurar e substituir o caractere
    
    # Exibir a mensagem de que encontrou ou não o caracter
    beq $v0, $zero, nao
    
    la $a0, encontrou
    li $v0, 4
    syscall
    
    # Exibir o número de vezes encontrado
    move $a0, $v1          
    li $v0, 1
    syscall
    
    la $a0, vezes
    li $v0, 4
    syscall
    
    # Exibir a string modificada
    la $a0, resultado
    li $v0, 4
    syscall
    
    # Exibir a string S1 modificada
    la $a0, S1             
    li $v0, 4
    syscall
    
    j feito

nao:
    la $a0, nao_encontrou
    li $v0, 4
    syscall

feito:    
    li $v0, 10
    syscall  # Fim do programa

encontra_caracter:
    li $v0, 0              # Inicializa $v0 com 0 (não encontrou ainda)
    li $v1, 0              # Inicializa $v1 com 0 (contador de incidências)
    
    loop:
        lb $t0, 0($a1)     # Carrega o próximo caractere da string S1 em $t0        
        beq $t0, $zero, sai_loop  # Se for o final da string (caractere nulo), sai do loop       
        beq $t0, $a0, substitui  # Se o caractere é igual ao digitado, vai para substituição
        addi $a1, $a1, 1    # Avança para o próximo caractere da string
        
        j loop

    substitui:
        # Substituir o caractere encontrado por sua versão maiúscula
        li $t1, 97          # 'a' minusculo em ASCII
        li $t2, 122         # 'z' minusculo em ASCII
        
        #verifica se o valor ASCII está entre 'a' minusculo e 'z' minusculo
        blt $t0, $t1, nao_muda
        bgt $t0, $t2, nao_muda 
        
        # Converte para maiúsculo subtraindo 32 do valor ASCII
        li $t3, 32
        sub $t0, $t0, $t3
        sb $t0, 0($a1)      # Substitui o caractere na string S1
        
    nao_muda:
        addi $v1, $v1, 1     # Incrementa o contador de incidências
        li $v0, 1            # Marca que encontrou ao definir $v0 como 1
        j loop

    sai_loop:
        jr $ra               # Retorna ao chamador
