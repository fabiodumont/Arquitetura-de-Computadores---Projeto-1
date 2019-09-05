.data

	despesas:     	.space 480
	despesasFim: 	.word 0
	idCont: 		.word 0
	idContAux: .word 0
		
	msgInicio:  			.asciiz "\nCONTROLE DE DESPESAS\n"
	msgMenu: 				.asciiz "\nMenu:\n 1) Registrar despesa \n 2) Listar despesas \n 3) Excluir despesa\n 4) Exibir gasto mensal \n 5) Exibir por categoria \n 6) Exibir ranking de despesas \n 0) Sair \n Insira um valor de 0 a 6:\n"
	msgId:					.asciiz	"\nInsira o ID da despesa "
	msgId2:					.asciiz "\nID: "
	msgRegistroDespesa:		.asciiz "\nInsira a data da despesa:"
	msgDia: 	   			.asciiz "\nDigite o dia: "
	msgDia2:                .asciiz "Dia: "
	msgMes: 	   			.asciiz "\nDigite o mes(ex. abril = 4): "
	msgMes2:                .asciiz "Mes "
	msgAno: 	   			.asciiz "\nDigite o ano(Somente os dois ultimos numeros): "
	msgAno2:                .asciiz "Ano: "
	msgCategoria:			.asciiz	"\nInsira a categoria: "
	msgCategoria2:          .asciiz "Categoria: "
	msgValor:				.asciiz	"\nInsira o valor da despesa: "
	msgValor2:              .asciiz "Valor: "
	msgRegistroConcluido:	.asciiz	"\nRegistro realizado com sucesso!\n "
	msgExcluir:				.asciiz "\nInsira o ID que deseja excluir: "
	msgGastoMensal:			.asciiz "\nGasto Mensal:\n"
	msgExclusaoSucesso:		.asciiz "\nExclusao feita com Sucesso!"
	msgGastoPorCategoria:	.asciiz "\n Gasto por categoria:\n"
	msgRanking:				.asciiz "\n Ranking de despesas:\n"
	msgInvalida:            .asciiz "\n A Opcao escolhida nao existe\n"
	quebraLinha: 			.asciiz "\n"
	espaco:					.asciiz "  "
	msgSair:  				.asciiz "Pressione algum botao para sair"
	zerofloat:              .float 0.0
	Opcao1: 				.asciiz "\n Registro de despesas\n"
	Opcao2: 				.asciiz "\n Lista de despesas\n"
	Opcao4: 				.asciiz "\nExibir gasto mensal\n"
	msgSem_id:				.asciiz "\nO ID nao existe\n"
	
	
.text
main:

	la $s0, despesas
	sw $s0, despesasFim
	
	lw $s1, despesasFim
	
	addi $t1, $zero, -1	# Seta t1 com -1 (ira indicar bloco livre para gravacao)
	setaVetor:
		sw $t1, despesas($t0)	# Grava -1 em todas as primeiras posicoes dos blocos
		addi $t0, $t0, 24	# incrementa indice
		bne $t0, 480, setaVetor
	#mensagens de introducao
	
	
	menu:
		li $v0, 4					# Codigo SysCall p/ escrever strings
		la $a0, msgInicio			# Parametro (string a ser escrita)
		syscall

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

		li $v0, 4
		la $a0, msgInvalida
		syscall
		
		j menu
		
		
		############### REGISTRAR ###############
		
		add $t1, $zero, $zero
		teste_registro:
		lw $t0, despesas($t1)
		beq $t0, -1, registrar
		addi $t0, $t0, 24
		j teste_registro
		
		registrar:
		li $v0, 4
		la $a0, Opcao1
		syscall

					## Cadastro ID ##
 
		li $v0, 4
		la $a0, msgId				# printa mensagem
		syscall				
		lw $s0, idCont				
		lw $s1, despesasFim			# pega o endere�o da ultima despesa
		sw $s0, 0($s1)				# escreve no endere�o que pegou
		li $v0, 1					# printa o ID da despesa que vai ser cadastrada
		add $a0, $zero, $s0
		syscall
		addi $s0, $s0, 1
		sw $s0, idCont				# Soma 1 no idCont
		lw $t0, idContAux
		addi $t0, $t0, 1
		sw $t0, idContAux			# Soma 1 no idContAux
		
		addi $s1, $s1, 1
		sw $s1, despesasFim			# anda 1 byte no vetor
		
					## Cadastro Dia ##
		
		li $v0, 4
		la $a0, msgDia
		syscall
		li $v0, 5		#  recebe um inteiro
		syscall		
		lw $s1, despesasFim  # pega o endere�o da posi��o certa
		sb $v0, 0($s1)       # guarda o dia digitado
		li $v0, 1
		add $a0, $zero, $v0
		syscall
		addi $s1, $s1, 1   # vai pr�xima posi��o
		sw $s1, despesasFim   # guarda o endere�o da nova posi��o
					
					## Cadastro Mes ##
					
		li $v0, 4
		la $a0, msgMes
		syscall
		li $v0, 5		# recebe inteiro
		syscall
		lw $s1, despesasFim  # pega o endere�o da posi��o certa
		sb $v0, 0($s1)       # guarda o mes na posi��o certa
		addi $s1, $s1, 1     # vai pra pr�xima posi��o
		sw $s1, despesasFim
		
					## Cadastro Ano ##
					
		li $v0, 4		# printa mensagem
		la $a0, msgAno	
		syscall
		li $v0, 5		# recebe inteiro
		syscall
		lw $s1, despesasFim		# pega o endere�o da posi��o
		sb $v0, 0($s1)			# guarda o ano na posi��o
		add $s1, $s1, 1			# vai pra pr�xima posi��o
		sw $s1, despesasFim
		
					## Cadastro Nome ##
					
		li $v0, 4
		la $a0, msgCategoria
		syscall
		li $a1, 15	     # tamanho m�ximo da string a ser digitada
		li $v0, 8  		 # recebe uma string
		lw $s1, despesasFim  # pega o endere�o certo para cadastrar
		add $a0, $s1, $zero
		syscall
		addi $s1, $s1, 16     # anda 16 bytes
		sw $s1, despesasFim  # guarda o endere�o novo
		
					## Cadastro Valor ##
					
		li $v0, 4
		la $a0, msgValor
		syscall
		li $v0, 6		# recebe um float
		syscall
		lw $s1, despesasFim  # pega o endere�o para cadastrar
		s.s $f0, 0($s1)
		addi $s1, $s1, 4   # vai pra pr�xima posi��o do vetor
		sw $s1, despesasFim  # guarda o endere�o da �ltima despesa
		
		li $v0, 4
		la $a0, msgRegistroConcluido
		syscall
		
		
		j menu
		
		############### LISTAR DESPESAS ###############
		add $t1, $zero, $zero
		teste_despesas:
		lw $t0, despesas($t1)
		slti $t1, $t0, 0
		bne $t1, 0, listar_despesas
		addi $t0, $t0, 23
		j teste_despesas
		
		listar_despesas:
		li $v0, 4
		la $a0, Opcao2
		syscall
		addi $t7, $zero, 365	# dias por ano
		addi $t6, $zero, 30		# dias por mes
		
		# LOOP
		lw $s6, idContAux  # coloca a quantidade de despesas em s6
		add $s6, $s6, -1
		add $t4, $zero, $zero     # contador j do loop (at� chegar em idCont)
		add $t5, $zero, $zero 	  # contador i do loop (at� chegar em idCont)
		la $a1, despesas    # pega o endere�o da primeira despesa
		lw $s0, despesasFim # pega o endere�o da �ltima despesa
		ListarInicioFor2:
		bne $s6, $t5, ListarInicioFor1  # (se s6 =! t5, pula pra ListaFor1) 
		j ListarFim
		ListarInicioFor1:
		bne $s6, $t4, ListarFor1  # (se s5 =! t4, pula para ListaFor1)
		add $t4, $zero, $zero	# contador j do loop (at� chegar em idCont)
		addi $t5, $t5, 1      # soma 1 no contador i
		la $a1, despesas    # coloca o endere�o da primeira despesa em a1
		j ListarInicioFor2
		ListarFor1:
		jal converteDias
		add $s5, $zero, $v0
		addi $a1, $a1, 24
		jal converteDias
		add $s4, $zero, $v0
		addi $t4, $t4, 1
		slt $s3, $s5, $s4				# se s4 < s5 --> s3 = 1
		beq $s3, $zero, ListarTroca
		j ListarInicioFor1
		ListarTroca:
		
		addi $a1, $a1, -24
		
		# PILHA
		# guarda na pilha para poder pegar depois
		addi $sp, $sp, -4    # libera espa�o
		lw $t0, 0($a1)
		sw $t0, 0($sp)
		addi $sp, $sp, -4
		lw $t0, 4($a1)
		sw $t0, 0($sp)
		addi $sp, $sp, -4
		lw $t0, 8($a1)
		sw $t0, 0($sp)
		addi $sp, $sp, -4
		lw $t0, 12($a1)
		sw $t0, 0($sp)
		addi $sp, $sp, -4
		lw $t0, 16($a1)
		sw $t0, 0($sp)
		addi $sp, $sp, -4
		l.s $f0, 20($a1)
		s.s $f0, 0($sp)
		
		# substitui v[i+1] por v[i]
		addi $a1, $a1, 24
		lw $t0, 0($a1)
		sw $t0, -24($a1)
		lw $t0, 4($a1)
		sw $t0, -20($a1)
		lw $t0, 8($a1)
		sw $t0, -16($a1)
		lw $t0, 12($a1)
		sw $t0, -12($a1)
		lw $t0, 16($a1)
		sw $t0, -8($a1)
		
		l.s $f0, 20($a1)
		s.s $f0, -4($a1)
		
		# i+1 = pilha
		l.s $f0, 0($sp)
		s.s $f0, 20($a1)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		sw $t0, 16($a1)
		addi $sp, $sp, 4
		
		lw $t0, 0($sp)
		sw $t0, 12($a1)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		sw $t0, 8($a1)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		sw $t0, 4($a1)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		sw $t0, 0($a1)
		addi $sp, $sp, 4
		j ListarInicioFor1
		
		ListarFim:
		lw $s1, despesasFim
		la $s0, despesas
		
		CompararListar:
		bne $s1, $s0, printarListar
		j FimListar
		printarListar:
		li $v0, 4
		la $a0, msgId2
		syscall
		lb $a0, 0($s0)
		li $v0, 1
		syscall
		jal quebrarLinha
		li $v0, 4
		la $a0, msgDia2
		syscall
		lb $a0, 1($s0)
		li $v0, 1
		syscall
		jal espacoProcedimento
		li $v0, 4
		la $a0, msgMes2
		syscall
		lb $a0, 2($s0)
		li $v0, 1
		syscall
		jal espacoProcedimento
		li $v0, 4
		la $a0, msgAno2
		syscall
		lb $a0, 3($s0)
		addi $a0, $a0, 2000
		li $v0, 1
		syscall
		jal quebrarLinha
		addi $s0, $s0, 4
		li $v0, 4
		la $a0, msgCategoria2
		syscall
		addi $a0, $s0, 0
		li $v0, 4
		syscall
		addi $s0, $s0, 16
		li $v0, 4
		la $a0, msgValor2
		syscall
		l.s $f12, 0($s0)
		li $v0, 2
		syscall
		addi $s0, $s0, 4
		jal quebrarLinha
		jal quebrarLinha
		j CompararListar
		FimListar:
		
		li $v0, 4
		la $a0, msgSair
		syscall
		li $v0, 12
		syscall
		
		jal quebrarLinha
		jal quebrarLinha
		
		j menu
		
		############### EXCLUIR DESPESAS ###############
		excluir_despesas:
		li $v0, 4
		la $a0, msgExcluir
		syscall
		li $v0, 5		# recebe inteiro
		syscall
		add $t2, $v0, $zero
		addi $t3, $zero, 480
		
		procurar_id:
		lb $t1, despesas($t0)
		beq $t1, $t2, excluir
		addi $t0, $t0, 24
		beq $t0, $t3, nao_existe_id
		j procurar_id
		
		excluir:
		beq $t0, -1 nao_existe_id
		addi $t1, $zero, -1
		sb $t1, despesas($t0)
		j exclusao_sucesso
		
		#soma:
		#addi $t0, $t0, 23
		#bne $t0, 479, soma
		#
		#subtracao:
		#lw $t1, despesas($t0)
		#bne $t1, -1, shift
		#subi $t0, $t0, 23
		#j subtracao
		#	
		#
		#shift:
		#add $t5, $zero, $zero
		#addi $t5, $t5, -1
		#addi $sp, $zero, -4
		#subi $t0, $t0, 4
		#lw $t1, despesas($t0)
		#sw $t1, 0($sp)
		#sw $t5, 19($t0)
		#addi $sp, $zero, -16
		#subi $t0, $t0, 19
		#lw $t1, despesas($t0)
		#sw $t1, 0($sp)
		#sw $t5, 4($t0)
		#addi $sp, $zero, -1
		#subi $t0, $t0, 1
		#lw $t1, despesas($t0)
		#sw $t1, 0($sp)
		#sw $t5, 3($t0)
		#addi $sp, $zero, -1
		#subi $t0, $t0, 1
		#lw $t1, despesas($t0)
		#sw $t1, 0($sp)
		#sw $t5, 2($t0)
		#addi $sp, $zero, -1
		#subi $t0, $t0, 1
		#lw $t1, despesas($t0)
		#sw $t1, 0($sp)
		#sw $t5, 1($t0)
		#addi $sp, $zero, -1
		#subi $t0, $t0, 1
		#lw $t1, despesas($t0)
		#sw $t1, 0($sp)
		#sw $t5, 0($t0)
		#subi $t0, $t0, 23
		#
		#subtracao1:
		#lw $t1, despesas($t0)
		#beq $t1, -1, substituicao
		#subi $t0, $t0, 23
		#j subtracao1
		#
		#substituicao:
		#lw $t1, 0($sp)
		#sw $t1, despesas($t0)
		#addi $t0, $t0, 1
		#lw $t1, 1($sp)
		#sw $t1, despesas($t0)
		#addi $t0, $t0, 1
		#lw $t1, 2($sp)
		#sw $t1, despesas($t0)
		#addi $t0, $t0, 1
		#lw $t1, 3($sp)
		#sw $t1, despesas($t0)
		#addi $t0, $t0, 1
		#lw $t1, 4($sp)
		#sw $t1, despesas($t0)
		#addi $t0, $t0, 19
		#lw $t1, 19($sp)
		#sw $t1, despesas($t0)
		#
		#addi $sp, $sp, 24
				
	
		
		nao_existe_id:
		li $v0, 4
		la $a0, msgSem_id
		syscall
		
		j excluir_despesas
		
		exclusao_sucesso:
		li $v0, 4
		la $a0, msgExclusaoSucesso
		syscall
		
		j menu
		
		
		
		############### EXIBIR GASTO MENSAL ###############
		exibir_gasto_mensal:
		li $v0, 4
		la $a0, Opcao4
		syscall
		
		li $s3, 1
		
		EncrementaMesLoop:
		addi $s7, $zero, 13
		bne $s7, $s3, menu4ContinuaSomar
		j menu4Printar
		
		menu4ContinuaSomar:
		l.s $f10, zerofloat
		l.s $f14, zerofloat
		add.s $f1, $f10, $f14
		la $s0, despesas
		lw $s2, despesasFim
		
		menu4SomaMes:
		bne $s0, $s2, menu4Continua
		j menu4SaiFor1
		
		menu4Continua:
		lb $s1, 2($s0)
		beq $s1, $s3, menu4VerificaMes
		j mesDiferente
		
		menu4VerificaMes:
		l.s $f12, 20($s0)
		add.s $f1, $f12, $f1
		
		mesDiferente:
		addi $s0, $s0, 24
		j menu4SomaMes
		
		menu4SaiFor1:
		li $v0, 4
		la $a0, msgMes2
		syscall
		li $v0, 1
		addi $a0, $s3, 0
		syscall
		
		jal espacoProcedimento
		jal espacoProcedimento
		
		li $v0, 4
		la $a0, msgGastoMensal
		syscall
		li $v0, 2
		l.s $f2, zerofloat
		add.s $f12, $f1, $f2
		syscall
		
		jal quebrarLinha
		
		addi $s3, $s3, 1
		j EncrementaMesLoop
		
		menu4Printar:
		jal quebrarLinha
		li $v0, 4
		la $a0, msgSair
		syscall
		li $v0, 12
		syscall
		
		jal quebrarLinha
		jal quebrarLinha
		
		j menu
		
		
		############### EXIBIR GASTO CATEGORIA ###############
		exibir_gasto_por_categoria:
		exibir_ranking_de_despesas:
	

quebrarLinha:
li $v0, 4
la $a0, quebraLinha
syscall
jr $ra

espacoProcedimento:
li $v0, 4
la $a0, espaco
syscall
jr $ra


converteDias:
lb $t0, 3($a1) # carrega o ano em t0
mul $t2, $t7, $t0  # multiplica o ano por 365 (t2 = ano * 365)
lb $t0, 2($a1) # carrega o mes em t0
mul $t3, $t6, $t0  # multiplica o mes por 30 (t3 = mes * 30)
add $t0, $t2, $t3  # t0(dias) = t2(anos em dias) + t3 (messes em dias)
lb $t1, 1($a1) #carrega o dia em t1
add $t0, $t1, $t0
add $v0, $zero $t0
jr $ra
	
exit:
		li $v0, 10
		syscall

