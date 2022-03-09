.data
COLORS: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
PRE_KEY: 0,0,0,0
KEY: 0,0,0,0
BREAK_LINE: .string "\n"

.text
MAIN:
li a7 5
ecall
li s0 5
add s0 s0 a0 # N -> difficult

li t4 0
li s1 0x10 # color
la t0 COLORS
GEN_COLOR:
	sw s1, 0(t0) # store color in color list
	addi s1 s1 2 # next color
	addi t0 t0 4 # next word in color array
	addi t4 t4 1 # increment main counter
	blt t4 s0 GEN_COLOR

la t0 PRE_KEY
li t4 4 # max counter
li t3 0 # counter
li a7 42  
mv a1 s0
GEN_PRE_KEY:
	ecall
	la t2 PRE_KEY 
	li t5 0 #subcounter
	
	CHECK_UNICITY:
		lw s2 0(t2) # carregar prox prekey em s2
		beq a0 s2 GEN_PRE_KEY # if a0 in PRE_KEYS: gen new index
		addi t5 t5 1
		addi t2 t2 4
		blt t5 s0 CHECK_UNICITY # if a0 not in PRE_KEYS: store index in PRE_KEY
	sw a0 0(t0)
	addi t0 t0 4
	addi t3 t3 1
	blt t3 t4 GEN_PRE_KEY
	
la t0 KEY
la t1 PRE_KEY
li t3 0 # main conter
li t5 4 # subcounter max
GEN_KEY:
	la t2 COLORS
	li t4 0 #subcounter
	lw s2 0(t1) # carregar prox prekey em s2
	# find next color with pre_key and add to key -> KEY.append(COLOR[PRE_KEY])
	COLOR_TO_KEY:
		beq t4 s2 STORE_KEY
		addi t4 t4 1
		blt t4 s0 COLOR_TO_KEY
	_STORE:
	addi t3 t3 1
	addi t1 t1 4
	blt t3 t5 GEN_KEY
	j END_GEN_KEY

STORE_KEY:
	slli t4 t4 2 # index * 4
	add t2 t2 t4
	lw t2 0(t2) # load COLOR[INDEX]
	sw t2 0(t0) # append to KEY
	li a7 1
	mv a0 t2
	ecall
	li a7 4
	la a0 BREAK_LINE
	ecall
	addi t0 t0 4
	j _STORE

END_GEN_KEY:
	
	li a7,10
	ecall
