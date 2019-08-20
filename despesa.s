.data

	cadastro:     				.space 360
	
		
	msgInicio:  				.asciiz "\nCONTROLE DE DESPESAS\n"
	msgMenu: 				.asciiz "\nMenu:\n 1) Registrar despesa \n 2) Listar despesas \n 3) Excluir despesa\n 4) Exibir gasto mensal \n 5) Exibir por categoria \n 6) Exibir ranking de despesas \n 0) Sair \n Insira um valor de 0 a 6:\n"
	msgId:					.asciiz	"\nInsira o ID da despesa "
	msgRegistroDespesa:			.asciiz "\nInsira a data da despesa:"
	msgDia: 	   			.asciiz "\nDigite o dia: "
	msgMes: 	   			.asciiz "Digite o mes(ex. abril = 4): "
	msgAno: 	   			.asciiz "Digite o ano(ex. 2019 = 2019): "
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
		listar_despesas:
		excluir_despesas:
		exibir_gasto_mensal:
		exibir_gasto_por_categoria:
		exibir_ranking_de_despesas:
		
exit:
		li $v0, 10
		syscall