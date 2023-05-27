.data

	mensagem_entrada_menu: .asciiz "Selecione uma opcao:\n1 - Fahrenheit -> Celsius\n2 - Fibonacci\n3 - Enesimo par\n4 - Sair\n"

	mensagem_entrada_fahrenheit: .asciiz "Digite a temperatura em Fahrenheit: "
	mensagem_entrada_fibonacci: .asciiz "Digite o valor de N para calcular o enesimo termo da sequencia de Fibonacci: "
	mensagem_entrada_enesimo_par: .asciiz "Digite o valor de N para calcular o enesimo numero par: "

	adicionar_nova_linha: .asciiz "\n"
	mensagem_saida_resultado: .asciiz "Resultado: "
	mensagem_saida_sair_programa: .asciiz "Saindo do programa... até mais!\n"

.text

main:
    li $t0, 0   # Variável para armazenar a opção selecionada pelo usuário

menu:
    li $v0, 4   # Imprimi quebra de linha
    la $a0, adicionar_nova_linha
    syscall
    
    li $v0, 4   # Imprimi mensagem do menu de opções
    la $a0, mensagem_entrada_menu
    syscall

    li $v0, 5   # Lê a opcao que o usuario escolheu
    syscall
    move $t0, $v0

    # Executa a opção selecionada
    beq $t0, 1, opcao_fahrenheit
    beq $t0, 2, opcao_fibonacci
    beq $t0, 3, opcao_enesimo_par
    beq $t0, 4, opcao_sair_programa
    
    li $v0, 4   # Imprimi quebra de linha
    la $a0, adicionar_nova_linha
    syscall

opcao_fahrenheit:
    li $v0, 4           # Imprimi mensagem para a entrada da temperatura em Fahrenheit
    la $a0, mensagem_entrada_fahrenheit
    syscall

    li $v0, 5           # Lê o valor da temperatura em Fahrenheit que o usuário inseriu
    syscall
    move $t0, $v0       # Armazena a temperatura em $t0

    sub $t1, $t0, 32    # F - 32
    mul $t2, $t1, 5     # 9 * (F - 32)
    div $t2, $t2, 9     # (9 * (F - 32)) / 9

    addi $t2, $t2, 0    # Converte o resultado para inteiro

    # Imprimi a mensagem para o resultado
    li $v0, 4           
    la $a0, mensagem_saida_resultado
    syscall

    # Imprimi a temperatura em Celsius que esta armazenado no resgistrador $t2
    li $v0, 1          
    move $a0, $t2
    syscall
    
    # Imprimi quebra de linha
    li $v0, 4   
    la $a0, adicionar_nova_linha
    syscall
    
    j menu	# Desvia o fluxo de execução para o rótulo "menu"


opcao_fibonacci: 
    li $v0, 4		# Imprimi a mensagem para o usuário digitar o valor de N  
    la $a0, mensagem_entrada_fibonacci
    syscall
    
    li $v0, 5		# Lê o valor de N que o usuário inseriu
    syscall
    move $t0, $v0  	# Armazena o valor de N em $t0

    # Compara o conteúdo dos registradores $t0 e $t4 e esses valores forem iguais, 
    # o fluxo de execução do programa será desviado para o rótulo "exibir_zero"
    li $t4, 0			
    beq $t0, $t4, exibir_zero	
    
    # Compara o conteúdo dos registradores $t0 e $t4 e esses valores forem iguais, 
    # o fluxo de execução do programa será desviado para o rótulo "exibir_um"
    li $t4, 1
    beq $t0, $t4, exibir_um
    
    # Configuração inicial para a sequência de Fibonacci
    li $t1, 0  # F0
    li $t2, 1  # F1
    
    li $t3, 1  # Vai iniciar o contador com o valor 1 
    
    # Loop que vai calcular os termos da sequência até o enésimo termo
    loop:	
        addu $t4, $t1, $t2  # F = F0 + F1
        move $t1, $t2       # F0 = F1
        move $t2, $t4       # F1 = F
        
        addiu $t3, $t3, 1   # Acrescenta o contador de termos
        
        beq $t3, $t0, fim_loop  # Encerra o loop quando o contador chegar a N
    
        j loop  # Pula para a próxima iteração do loop
    
    fim_loop:
   	li $v0, 4	# Imprimi a ensagem para o resultado
    	la $a0, mensagem_saida_resultado
    	syscall
    
    	move $a0, $t2   # Coloca o valor do enésimo termo em $a0
    	li $v0, 1	# Imprimi o enesimo termo da sequencia de fibonacci 
    	syscall

    	j menu	# Desvia o fluxo de execução para o rótulo "menu"
    
    exibir_um: 
   	# Imprimi a mensagem para o resultado
        li $v0, 4	
        la $a0, mensagem_saida_resultado
        syscall	
    	
    	# Imprimi o valor 1
        li $v0, 1
    	li $a0, 1
        syscall
        
        j menu	# Desvia o fluxo de execução para o rótulo "menu"
        
    exibir_zero: 
    	# Imprimi a mensagem para o resultado
        li $v0, 4
        la $a0, mensagem_saida_resultado
        syscall
    
    	# Imprimi o valor 0
        li $v0, 1
    	li $a0, 0
        syscall
        
        j menu	# Desvia o fluxo de execução para o rótulo "menu"
    
opcao_enesimo_par:
    	# Imprimi a mensagem para a entrada de N para calcular o enesimo numero par
    	li $v0, 4
    	la $a0, mensagem_entrada_enesimo_par
    	syscall
    
    	# Ler o valor de N que o usuario inseriu
    	li $v0, 5
    	syscall
    	move $s0, $v0   # Salva o valor de N em $s0
    
    	# Calcula o enésimo número par
    	sll $s1, $s0, 1   # $s1 = n * 2
    
    	# Imprimi a mensagem para o resultado
   	li $v0, 4
    	la $a0, mensagem_saida_resultado
    	syscall
    
     	# Imprimi o enésimo número par que esta armazenado no registrador $s1
    	li $v0, 1
   	move $a0, $s1
    	syscall
    
   	j menu	# Desvia o fluxo de execução para o rótulo "menu"
          
opcao_sair_programa:
	# Imprimi a mensagem de sair do programa
	li $v0, 4
	la $a0, mensagem_saida_sair_programa
	syscall
