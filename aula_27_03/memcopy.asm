    .data
origem: 
    .asciiz "Texto para copiar"

    .text
main:     
    # Imprime a string origem
    la $a0, origem           # Carrega o endereço de origem
    li $v0, 4                # Syscall para imprimir string
    syscall          

    # Imprime '/'
    li $a0, 47               # Carrega o código ASCII de '/'
    li $v0, 11               # Syscall para imprimir caractere
    syscall          

    # Chama o procedimento MEMCOPY
    la $a0, origem           # Carrega o endereço da string origem em $a0
    jal MEMCOPY              # Chama MEMCOPY, resultado estará em $v0 (endereço de destino)

    # Imprime o conteúdo da área destino
    move $a0, $v0            # Move o endereço de destino para $a0
    li $v0, 4                # Syscall para imprimir string
    syscall          

    # Finaliza o programa
    li $v0, 10               # Syscall para terminar o programa
    syscall

# Procedimento de cópia de conteúdo de memória
# Parâmetro de entrada: $a0 contém o endereço dos dados de origem
# Retorno: $v0 contém o endereço dos dados de destino
MEMCOPY:
    # Aloca memória dinamicamente para copiar os dados (usando syscall 9)
    # Para alocar memória, passamos o número de bytes que queremos alocar (número de caracteres da string + 1 para o terminador '\0')
    move $a1, $a0            # Move o endereço de origem para $a1 (vamos usá-lo para calcular o tamanho)
    li $t0, 0                # Inicializa o contador de bytes copiados

    # Contar o tamanho da string
count_loop:
    lb $t1, 0($a1)           # Carrega o byte da string origem
    beqz $t1, count_done     # Se for o terminador nulo, terminamos
    addi $t0, $t0, 1         # Incrementa o contador de bytes
    addi $a1, $a1, 1         # Move para o próximo byte
    j count_loop             # Repete o loop

count_done:
    addi $t0, $t0, 1         # Adiciona 1 para o terminador '\0'

    # Chama a syscall 9 para alocar memória dinamicamente
    li $v0, 9                # Alocação de memória
    move $a0, $t0            # Tamanho necessário (em bytes) para $a0
    syscall                  # Chama a syscall

    # O endereço alocado está em $v0 (já armazenado pelo syscall)
    move $t2, $v0            # Move o endereço de destino para $t2

    # Copiar os dados de origem para o destino
    la $a1, origem           # Carrega o endereço de origem em $a1
    move $a3, $t2            # Carrega o endereço de destino em $a3

copy_loop:
    lb $t1, 0($a1)           # Carrega um byte de origem
    sb $t1, 0($a3)           # Armazena o byte no destino
    beqz $t1, copy_done      # Se o byte for nulo ('\0'), terminamos
    addi $a1, $a1, 1         # Avança para o próximo byte de origem
    addi $a3, $a3, 1         # Avança para o próximo byte de destino
    j copy_loop              # Repete o loop

copy_done:
    jr $ra                   # Retorna para o chamador
