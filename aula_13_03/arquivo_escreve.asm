.data
# Caminhos para os arquivos de origem e destino
arquivo_origem:    .asciiz "C:\\Users\\1396264\\Documents\\GitHub\\LabAOCII\\aula_06_03\\arquivo_leitura.txt"  
arquivo_destino:   .asciiz "C:\\Users\\1396264\\Documents\\GitHub\\LabAOCII\\aula_13_03\\arquivo_escreve.txt"

# Buffer para armazenar dados lidos do arquivo
buffer: .space 1024

fim_arquivo_origem: .asciiz "Fim do arquivo de origem\n"
fim_arquivo_destino: .asciiz "Fim do arquivo de destino\n"

.text
.globl main

main:
    # $s0: descritor do arquivo de origem
    # $s1: descritor do arquivo de destino
    # $s2: buffer de leitura
    # $s3: quantidade de bytes lidos

    # Abrir arquivo de origem para leitura
    li   $v0, 13        # Chamada de sistema para abrir arquivo
    la   $a0, arquivo_origem  # Caminho do arquivo de origem
    li   $a1, 0         # Abrir para leitura
    li   $a2, 0         # Flags adicionais
    syscall             # Chama o sistema
    move $s0, $v0       # Salva descritor do arquivo de origem

    # Verificar se o arquivo de origem foi aberto com sucesso
    bltz $s0, erro_abrir_origem # Se $s0 < 0, erro na abertura

    # Abrir arquivo de destino para escrita (se não existir, cria)
    li   $v0, 13        # Chamada de sistema para abrir arquivo
    la   $a0, arquivo_destino  # Caminho do arquivo de destino
    li   $a1, 1         # Abrir para escrita
    li   $a2, 0         # Flags adicionais
    syscall             # Chama o sistema
    move $s1, $v0       # Salva descritor do arquivo de destino

    # Verificar se o arquivo de destino foi aberto com sucesso
    bltz $s1, erro_abrir_destino # Se $s1 < 0, erro na abertura

    # Ler do arquivo de origem e escrever no arquivo de destino
Loop:
    # Leitura do arquivo de origem
    li   $v0, 14        # Chamada de sistema para ler arquivo
    la   $a0, buffer    # Endereço do buffer para armazenar a leitura
    li   $a1, 1024      # Quantidade de bytes a serem lidos
    syscall             # Chama o sistema
    move $s3, $v0       # Salva a quantidade de bytes lidos em $s3

    # Verifica se chegou ao final do arquivo
    beq  $s3, $zero, fim_arquivo  # Se não leu nada, finaliza

    # Escrever no arquivo de destino
    li   $v0, 15        # Chamada de sistema para escrever no arquivo
    move $a0, $s1       # Descritor do arquivo de destino
    la   $a1, buffer    # Endereço do buffer com dados lidos
    move $a2, $s3       # Quantidade de bytes a escrever
    syscall             # Chama o sistema para escrever

    j Loop              # Continua o loop

fim_arquivo:
    # Fechar arquivo de origem
    li   $v0, 16        # Chamada de sistema para fechar arquivo
    move $a0, $s0       # Descritor do arquivo de origem
    syscall             # Chama o sistema

    # Fechar arquivo de destino
    li   $v0, 16        # Chamada de sistema para fechar arquivo
    move $a0, $s1       # Descritor do arquivo de destino
    syscall             # Chama o sistema

    # Finalizar o programa
    li   $v0, 10        # Chamada de sistema para finalizar o programa
    syscall

erro_abrir_origem:
    # Caso erro na abertura do arquivo de origem
    li   $v0, 4         # Chamada de sistema para imprimir string
    la   $a0, fim_arquivo_origem
    syscall
    li   $v0, 10        # Finaliza o programa
    syscall

erro_abrir_destino:
    # Caso erro na abertura do arquivo de destino
    li   $v0, 4         # Chamada de sistema para imprimir string
    la   $a0, fim_arquivo_destino
    syscall
    li   $v0, 10        # Finaliza o programa
    syscall
