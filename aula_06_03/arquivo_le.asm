.data 
arquivo: .asciiz "C:\\Users\\1396264\\Documents\\GitHub\\LabAOCII\\aula_06_03\\arquivo_leitura.txt"  # nome do arquivo
buffer: .space 1024  # espaço para armazenar os dados lidos (1024 bytes)

.text
# $s0: descritor do arquivo aberto
# $s1: endere�o do buffer de dados do arquivo lido
#abre arquivo para leitura
	li   $v0, 13       # chamada de sistema para abrir arquivo
	la   $a0, arquivo      
	li   $a1, 0        # abrir para leitura
	li   $a2, 0
	syscall            # abre arquivo! (descritor do arquivo retornado em $v0)
	move $s0, $v0      # salva o descritor de arquivo 

# Lê o arquivo (até 1024 bytes)
	la   $a1, buffer   # endere�o do buffer para receber a leitura
	move $s1, $a1      # salva ponteiro para buffer em $s1

Loop:
	li   $v0, 14       # chamada de sistema para ler arquivo	
	li   $a2, 1024     # lê até 1024 bytes
	syscall            # executa leitura do arquivo!

	beq $v0, 0, fim_arquivo  # se não houver mais dados (EOF), termina

	# continua lendo, se houver mais dados
	j Loop

# Fecha o arquivo
fim_arquivo:
	li   $v0, 16       # chamada de sistema para fechar arquivo
	move $a0, $s0      # descritor do arquivo a ser fechado
	syscall            # fecha arquivo!

# Imprime conteúdo do buffer
	la   $t1, buffer   # ponteiro para o buffer
	add  $t0, $zero, $zero   # i = 0
L1: 
	lb   $s3, 0($t1)   # lê um byte do buffer
	beq  $s3, $zero, feito   # se for nulo, fim da string (EOF)
	jal  imprime_caracter_em_s3  # chama a função para imprimir o caractere
	addi $t1, $t1, 1     # move para o próximo byte no buffer
	j L1                  # repete o loop

feito: 
	li $v0, 10
	syscall 		# termina o programa

imprime_caracter_em_s3:
	li $v0, 11 	# imprime o valor em $s3
	move $a0, $s3
	syscall
	jr $ra
