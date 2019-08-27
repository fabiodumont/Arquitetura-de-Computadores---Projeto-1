.data

	despesas:     				.space 360
	
		
	msgInicio:  				.asciiz "\nCONTROLE DE DESPESAS\n"
	msgMenu: 				.asciiz "\nMenu:\n 1) Registrar despesa \n 2) Listar despesas \n 3) Excluir despesa\n 4) Exibir gasto mensal \n 5) Exibir por categoria \n 6) Exibir ranking de despesas \n 0) Sair \n Insira um valor de 0 a 6:\n"
	msgId:					.asciiz	"\nInsira o ID da despesa "
	msgRegistroDespesa:			.asciiz "\nInsira a data da despesa:"
	msgDia: 	   			.asciiz "\nDigite o dia: "
	msgMes: 	   			.asciiz "\nDigite o mes(ex. abril = 4): "
	msgAno: 	   			.asciiz "\nDigite o ano(ex. 2019 = 2019): "
	msgCategoria:				.asciiz	"\nInsira a categoria: "
	msgValor:				.asciiz	"\nInsira o valor da despesa: "
	msgRegistroConcluido:			.asciiz	"\nRegistro realizado com sucesso!\n "
	msgExcluir:				.asciiz "\nInsira o ID que deseja excluir: "
	msgGastoMensal:			.asciiz "\nGasto Mensal:\n"
	msgExclusaoSucesso:			.asciiz "\nExclusao feita com Sucesso!"
	msgGastoPorCategoria:			.asciiz "\n Gasto por categoria:\n"
	msgRanking:				.asciiz "\n Ranking de despesas:\n"
	
.text
main:
	#mensagens de introducao
		li $v0, 4					# Codigo SysCall p/ escrever strings
		la $a0, msgInicio			# Parametro (string a ser escrita)
		syscall

        add $t0, $zero, $zero
        addi $t1, $zero, -1
        zerar:

        sw $t1, despesas($t0)
        addi $t0, $t0, 36	
        bne $t0, 360, zerar      
		
menu:

		addi $t0, $zero, 0 # Zera o indice

		li $v0, 4
		la $a0, msgMenu
		syscall

		li $v0, 5 					# Codigo SysCall p/ ler inteiros
		syscall 					# Inteiro lido vai ficar em $v0


		beq $v0, 0, exit
		beq $v0, 1, registrar
		beq $v0, 2, listar_despesas 
		beq $v0, 3, excluir_despesas
		beq $v0, 4, exibir_gasto_mensal
		beq $v0, 5, exibir_gasto_por_categoria
		beq $v0, 6, exibir_ranking_de_despesas

		j menu
		
		
		registrar:
		add $t0, $zero, $zero
		cadastro:

					# Cadastro ID

		li $v0, 4
		la $a0, msgId
		syscall
		li $v0, 5
		syscall
		
		add $t1, $v0, $zero
		
          	sw $t1, despesas($t0)
          	
          	lw $t3, despesas($t0)
		li $v0, 1
		add $a0, $zero, $t3
		syscall

               				# Cadastro Dia
                
                li $v0, 4
                la $a0, msgDia
                syscall
                li $v0, 5
                syscall
                
                addi $t0, $zero, 4
                
		add $t1, $v0, $zero
		sw $t1, despesas($t0)
		
		
		lw $t3, despesas($t0)
		li $v0, 1
		add $a0, $zero, $t3
		syscall
					# Cadastro Mes
		li $v0, 4
		la $a0, msgMes
		syscall
		li $v0, 5
		syscall
		
		addi $t0, $zero, 4
		
		add $t1, $v0, $zero
		sw $t1, despesas($t0)
		
		lw $t3, despesas($t0)
		li $v0, 1
		add $a0, $zero, $t3
		syscall
					# Cadastro Ano
		li $v0, 4
		la $a0, msgAno
		syscall
		li $v0, 5
		syscall
		
		add $t0, $zero, 4
		
		add $t1, $v0, $zero
		sw $t1, despesas($t0)
		
		lw $t3, despesas($t0)
		li $v0, 1
		add $a0, $zero, $t3
		syscall
		
					# Cadastro Categoria
		
		li $v0, 4
		la $a0, msgCategoria
		syscall
		
		li $v0, 8		# Codigo de leitura de string
		la $a0, despesas($t0)	#
		li $a1, 16		#
		syscall	

		listar_despesas:
		excluir_despesas:
		exibir_gasto_mensal:
		exibir_gasto_por_categoria:
		exibir_ranking_de_despesas:
		
exit:
		li $v0, 10
		syscall





