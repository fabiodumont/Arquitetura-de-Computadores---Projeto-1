.data

	despesas:     	.space 480
	despesasFim: .word 0
	idContador: .word 0
	idContadorAux: .word 0
		
	msgInicio:  				.asciiz "\nCONTROLE DE DESPESAS\n"
	msgMenu: 				.asciiz "\nMenu:\n 1) Registrar despesa \n 2) Listar despesas \n 3) Excluir despesa\n 4) Exibir gasto mensal \n 5) Exibir por categoria \n 6) Exibir ranking de despesas \n 0) Sair \n Insira um valor de 0 a 6:\n"
	msgId:					.asciiz	"\nInsira o ID da despesa "
	msgId2:					.asciiz "\nID: "
	msgRegistroDespesa:			.asciiz "\nInsira a data da despesa:"
	msgDia: 	   			.asciiz "\nDigite o dia: "
	msgDia2:                .asciiz "Dia: "
	msgMes: 	   			.asciiz "\nDigite o mes(ex. abril = 4): "
	msgMes2:                .asciiz "Mes "
	msgAno: 	   			.asciiz "\nDigite o ano(Somente os dois ultimos numeros): "
	msgAno2:                .asciiz "Ano: "
	msgCategoria:				.asciiz	"\nInsira a categoria: "
	msgCategoria2:          .asciiz "Categoria: "
	msgValor:				.asciiz	"\nInsira o valor da despesa: "
	msgValor2:              .asciiz "Valor: "
	msgRegistroConcluido:			.asciiz	"\nRegistro realizado com sucesso!\n "
	msgExcluir:				.asciiz "\nInsira o ID que deseja excluir: "
	msgGastoMensal:			.asciiz "\nGasto Mensal:\n"
	msgExclusaoSucesso:			.asciiz "\nExclusao feita com Sucesso!"
	msgGastoPorCategoria:			.asciiz "\n Gasto por categoria:\n"
	msgRanking:				.asciiz "\n Ranking de despesas:\n"
	msgInvalida:            .asciiz "\n A Opcao escolhida nao existe\n"
	quebraLinha: 			.asciiz "\n"
	espaco:					.asciiz "  "
	msgSair:  					.asciiz "Pressione algum botao para sair"
	zerofloat:              .float 0.0
	NaoExisteId:            .asciiz "ID nao encontrado\n"
	Opcao1: .asciiz "\n Registro de despesas\n"
	Opcao2: .asciiz "\n Lista de despesas\n"
	Opcao3: .asciiz "\nExcluir despesas"
	Opcao4: .asciiz "\nExibir gasto mensal\n"
	Opcao5: .asciiz "\nExibir gasto por categoria\n"
	Opcao6: .asciiz "\nExibit ranking de despesas\n"
	
.text
main:

	la $s0, despesas
	sw $s0, despesasFim
	
	lw $s1, despesasFim
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
		registrar:
		li $v0, 4
		la $a0, Opcao1
		syscall

					## Cadastro ID ##
 
		li $v0, 4
		la $a0, msgId				# printa mensagem
		syscall				
		lw $s0, idContador				
		lw $s1, despesasFim			# pega o endereço da ultima despesa
		sw $s0, 0($s1)				# escreve no endereço que pegou
		li $v0, 1					# printa o ID da despesa que vai ser cadastrada
		add $a0, $zero, $s0
		syscall
		addi $s0, $s0, 1
		sw $s0, idContador				# Soma 1 no idContador
		lw $t0, idContadorAux
		addi $t0, $t0, 1
		sw $t0, idContadorAux			# Soma 1 no idContadorAux
		
		addi $s1, $s1, 1
		sw $s1, despesasFim			# anda 1 byte no vetor
		
					## Cadastro Dia ##
		
		li $v0, 4
		la $a0, msgDia
		syscall
		li $v0, 5		#  recebe um inteiro
		syscall		
		lw $s1, despesasFim  # pega o endereço da posição certa
		sb $v0, 0($s1)       # guarda o dia digitado
		li $v0, 1
		add $a0, $zero, $v0
		syscall
		addi $s1, $s1, 1   # vai próxima posição
		sw $s1, despesasFim   # guarda o endereço da nova posição
					
					## Cadastro Mes ##
					
		li $v0, 4
		la $a0, msgMes
		syscall
		li $v0, 5		# recebe inteiro
		syscall
		lw $s1, despesasFim  # pega o endereço da posição certa
		sb $v0, 0($s1)       # guarda o mes na posição certa
		addi $s1, $s1, 1     # vai pra próxima posição
		sw $s1, despesasFim
		
					## Cadastro Ano ##
					
		li $v0, 4		# printa mensagem
		la $a0, msgAno	
		syscall
		li $v0, 5		# recebe inteiro
		syscall
		lw $s1, despesasFim		# pega o endereço da posição
		sb $v0, 0($s1)			# guarda o ano na posição
		add $s1, $s1, 1			# vai pra próxima posição
		sw $s1, despesasFim
		
					## Cadastro Nome ##
					
		li $v0, 4
		la $a0, msgCategoria
		syscall
		li $a1, 15	     # tamanho máximo da string a ser digitada
		li $v0, 8  		 # recebe uma string
		lw $s1, despesasFim  # pega o endereço certo para cadastrar
		add $a0, $s1, $zero
		syscall
		addi $s1, $s1, 16     # anda 16 bytes
		sw $s1, despesasFim  # guarda o endereço novo
		
					## Cadastro Valor ##
					
		li $v0, 4
		la $a0, msgValor
		syscall
		li $v0, 6		# recebe um float
		syscall
		lw $s1, despesasFim  # pega o endereço para cadastrar
		s.s $f0, 0($s1)
		addi $s1, $s1, 4   # vai pra próxima posição do vetor
		sw $s1, despesasFim  # guarda o endereço da última despesa
		
		j menu
		
		############### LISTAR DESPESAS ###############
		listar_despesas:
		li $v0, 4
		la $a0, Opcao2
		syscall
		addi $t7, $zero, 365	# dias por ano
		addi $t6, $zero, 30		# dias por mes
		
		# LOOP
		lw $s6, idContadorAux  # coloca a quantidade de despesas em s6
		add $s6, $s6, -1
		add $t4, $zero, $zero     # contador j do loop (até chegar em idContador)
		add $t5, $zero, $zero 	  # contador i do loop (até chegar em idContador)
		la $a1, despesas    # pega o endereço da primeira despesa
		lw $s0, despesasFim # pega o endereço da última despesa
		ListarInicioFor2:
		bne $s6, $t5, ListarInicioFor1  # (se s6 =! t5, pula pra ListaFor1) 
		j ListarFim
		ListarInicioFor1:
		bne $s6, $t4, ListarFor1  # (se s5 =! t4, pula para ListaFor1)
		add $t4, $zero, $zero	# contador j do loop (até chegar em idContador)
		addi $t5, $t5, 1      # soma 1 no contador i
		la $a1, despesas    # coloca o endereço da primeira despesa em a1
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
		addi $sp, $sp, -4    # libera espaço
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
		la $a0, msgId2
		syscall
		
		li $v0, 4
		la $a0, Opcao3
		syscall
		
		li $v0, 5
		syscall
		
		la $s0, despesas
		lw $s1, despesasFim
		
		ExcluirInicioFor:
		bne $s0, $s1, ExcluirInicioLoop
		
		li $v0, 4
		la $a0, NaoExisteId
		syscall
		
		j ExcluirFim
		
		ExcluirInicioLoop:
		lb $t0, 0($s0)
		beq $t0, $v0, idEncontrado
		addi $s0, $s0, 24
		j ExcluirInicioFor
		
		idEncontrado:
		addi $s1, $s1, -24
		sw $s1, despesasFim
		
		lw $t1, idContadorAux
		addi $t1, $t1, -1
		sw $t1, idContadorAux
		
		lw $s4, 0($s1)
		sw $s4, 0($s0)
		
		lw $s4, 4($s1)
		sw $s4, 4($s0)
		
		lw $s4, 8($s1)
		sw $s4, 8($s0)
		
		lw $s4, 12($s1)
		sw $s4, 12($s0)
		
		lw $s4, 16($s1)
		sw $s4, 16($s0)
		
		l.s $f1, 20($s1)
		s.s $f1, 20($s0)
		
		ExcluirFim:
		li $v0, 4
		la $a0, msgSair
		syscall
		li $v0, 12
		syscall
		jal quebrarLinha
		
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
		
		
		
		
		############### EXIBIR GASTO POR CATEGORIA ###############
		exibir_gasto_por_categoria:
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		############### EXIBIR RANKING DE DESPESAS ###############
		exibir_ranking_de_despesas:
		
		li $v0, 4
		la $a0, Opcao6
		syscall
		
		la $s0, despesas
		lw $s1, despesasFim
		addi $s2, $sp, 0
		
		#empilhar o endereco das categorias de cada despesa
		empilharEnderecosMenu6:
		bne $s0, $s1, empilharCategorias
		j terminouDeEmpilhar
		empilharCategorias:
		
		addi $t1, $s0, 20	# pega o endereco do valor
		addi $t0, $s0, 4	# pega o endereco do primeimro caracter da string
		addi $sp, $sp, -8   # libera espaco na pilha
		l.s $f2, 0($t1)
		s.s $f2, 0($sp)
		sw $t0, 4($sp)
		addi $s0, $s0, 24
		
		j empilharEnderecosMenu6
		terminouDeEmpilhar:
		
		add $s4, $zero, $s2
		add $a3, $zero, $s2
		addi $s4, $s4, -8
		
		jal tirarIguaisPilha
		addi $s4, $a3, -8
		addi $s5, $a3, -8
		add  $s6, $zero, $sp
		
		ordenandoFor1:
		bne $s5, $sp, ordenandoPilha
		j acabouOrdenar
		ordenandoPilha:
		bne $s4, $s6, ordenarMenu6
		addi $s4, $a3, -8
		addi $s6, $s6, 8
		addi $s5, $s5, -8
		j ordenandoFor1
		ordenarMenu6:
		l.s $f1, 0($s4)
		l.s $f2, -8($s4)
		
		c.le.s 0 $f2, $f1  # se f2 for maior ou igual a f1
		bc1t 0 trocaMenu6
		j naoTrocaMenu6
		trocaMenu6:
		
		l.s $f1, 0($s4)
		l.s $f2, -8($s4)
		s.s $f2, 0($s4)
		s.s $f1, -8($s4)
		
		lw $s1, 4($s4)
		lw $s2, -4($s4)
		sw $s2, 4($s4)
		sw $s1, -4($s4)
		
		naoTrocaMenu6:
		addi $s4, $s4, -8
		j ordenandoPilha
		ordenandoFor2:
		
		acabouOrdenar:
		jal imprimirPilha
		
		jal quebrarLinha
		
		li $v0, 4
		la $a0, msgSair
		syscall
		li $v0, 12
		syscall
		
		jal quebrarLinha
		
		j menu
		
		
	
		
		
	###############################################

quebrarLinha:
li $v0, 4
la $a0, quebraLinha
syscall
jr $ra

###############################################

espacoProcedimento:
li $v0, 4
la $a0, espaco
syscall
jr $ra

###############################################

# converte ano e mes para dias para poder ordenar

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


###############################################

# tirar categorias repetidas da pilha

tirarIguaisPilha:
arrumaPilha:
sltu $t0, $sp, $s4
bne $t0, $zero, tirarIguaisDaPilha

j terminouDeTirarIguais
tirarIguaisDaPilha:

addi $s5, $s4, -8
for1TirarIguais:
sltu $t0, $s5, $sp
beq $t0, $zero, continuaExecutando
addi $s4, $s4, -8

j arrumaPilha
continuaExecutando:

lw $a0, 4($s4)
lw $a1, 4($s5)
add $s6, $zero, $ra
jal compararStrings
add $ra, $zero, $s6
addi $t0, $zero, 2
beq $t0, $v0, tirarCategoriasIguais
j categoriasDiferentes
tirarCategoriasIguais:
l.s $f0, 0($s4)
l.s $f1, 0($s5)
add.s $f2, $f1, $f0
s.s $f2, 0($s4)
l.s $f0, 0($sp)
s.s $f0, 0($s5)
lw $s0, 4($sp)
sw $s0, 4($s5)
addi $sp, $sp, 8
j for1TirarIguais
categoriasDiferentes:
addi $s5, $s5, -8
j for1TirarIguais
terminouDeTirarIguais:

jr $ra

###############################################

imprimirPilha:
printarPilha:
bne $a3, $sp, printPilha
j jaPrintouPilha
printPilha:

li $v0, 4
la $a0, msgCategoria2
syscall

li $v0, 4
lw $s1, 4($sp)
addi $a0, $s1, 0
syscall

li $v0, 4
la $a0, msgValor2
syscall

addi $v0, $zero, 2
l.s $f12, 0($sp)
syscall

jal quebrarLinha
jal quebrarLinha

addi $sp, $sp, 8
j printarPilha
jaPrintouPilha:
jr $ra


###############################################

compararStrings:
addi $s7, $zero, -1
addi $t5, $zero, 10
# se a primeira string recebida for > a segunda, return 0
# caso contrário, return 1
# iguais, return 2
# endereços: palavra1 em a0 e palavra2 em a1
# numero retornado em v0
addi $t0, $zero, 0
compararStringsFor1:
lw $s1, 0($a0)
lb $s2, 0($a1)
addi $a0, $a0, 1
addi $a1, $a1, 1
beq $s1, $t5, compararSegunda
beq $s2, $t5, compararPrimeira
beq $s1, $s2, compararStringsFor1
slt $s7, $s1, $s2
j fimCompararStrings
compararSegunda:
beq $s2, $t5, stringsIguais
addi $s7, $zero, 0
j fimCompararStrings
stringsIguais:
addi $s7, $zero, 2
j fimCompararStrings
compararPrimeira:
beq $s1, $t5, stringsIguais
addi $s7, $zero, 1
j fimCompararStrings


fimCompararStrings:

add $v0, $zero, $s7
jr $ra


	
exit:
		li $v0, 10
		syscall

