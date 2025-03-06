.data
    S1: .asciiz "Teste para busca de caracteres"
    encontrou: .asciiz "\nEncontrou o caracter "
    nao_encontrou: .asciiz "\nNao encontrou"
    vezes: .asciiz " vez(es)"
    digite: .asciiz "Digite um caracter: "

# lembrar que caracteres ocupam apenas 1 byte na mem�ria

.text
main:
    
    la $a0, digite 
    li $v0, 4 	 
    syscall
    
    li $v0, 12
    syscall
    
    move $a0, $v0 #imprimir na tela tem sempre que estar no a0, por isso como a contagem está no v0, precisa mover para o a0
    la $a1, S1  
    
    jal encontra_caracter
    
    # se $v0=0 indica que n�o encontrou o caracter
    # se $v0=1 indica que encontrou o caracter
    beq $v0, $zero, nao  # testa se n�o encontrou
    
    la $a0, encontrou 
    li $v0, 4 	 
    syscall
    
    # $v1 contem o n�mero de incid�ncias
    move $a0, $v1
    li $v0, 1 	 
    syscall
    
    la $a0, vezes 
    li $v0, 4 	 
    syscall
   
    j feito
nao: 
    la $a0, nao_encontrou 
    li $v0, 4 	 
    syscall
feito:    
    li $v0, 10
    syscall # feito!

# procedimento "encontra_caracter"
# Argumentos
# 1) $a0 conter� o caracter a ser procurado na string
# 2) $a1: endere�o base de S1 
#Retornos
# 1) $v0 ser� 0 se n�o encontrar o caracter, e 1 se encontrar
# 2) $v1 contabiliza o n�mero de incid�ncias do caracter procurado

encontra_caracter: 
      	 # Inicializar os registradores
    li $v0, 0              # Inicializa $v0 com 0 (não encontrou ainda)
    li $v1, 0              # Inicializa $v1 com 0 (contador de incidências)
    
    loop:
        lb $t0, 0($a1)     # Carrega o próximo caractere da string S1 em $t0
        addi $a1, $a1, 1     # Avança para o próximo caractere da string
        beq $t0, $zero, sai_loop  # Se for o final da string (caractere nulo), sai do loop       
        beq $t0, $a0, contabiliza # Verifica se o caractere de S1 é igual ao caractere procurado
        
        j loop
    
    contabiliza:
    	addi $v1, $v1, 1    # Incrementa o contador de incidências
     li $v0, 1            # Marca que encontrou ao definir $v0 como 1
    j loop

    sai_loop:
        jr $ra               # Retorna ao chamador


.end main
