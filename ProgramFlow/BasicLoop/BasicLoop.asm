//push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop local 0
@0
D=A
@LCL
D=D+M
@13
M=D
@SP
M=M-1
A=M
D=M
@13
A=M
M=D
//label LOOP_START
(LOOP_START)
//push argument 0
@0
D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//push local 0

@0

D=A
@LCL
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
//pop local 0	
@0	
D=A
@LCL
D=D+M
@13
M=D
@SP
M=M-1
A=M
D=M
@13
A=M
M=D
//push argument 0

@0

D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//push constant 1

@1

D=A
@SP
A=M
M=D
@SP
M=M+1
//sub
@SP
A=M-1
D=M
A=A-1
M=M-D
@SP
M=M-1
//pop argument 0
@0
D=A
@ARG
D=D+M
@13
M=D
@SP
M=M-1
A=M
D=M
@13
A=M
M=D
//push argument 0

@0

D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//if-goto LOOP_START
@SP
AM=M-1
D=M
@LOOP_START
D;JNE
//push local 0

@0

D=A
@LCL
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
