//function Sys.init 0

(Sys.init)
//push constant 4

@4

D=A
@SP
A=M
M=D
@SP
M=M+1
//call Main.fibonacci 1
@RETURN_ADDRESS.Main.fibonacci.1
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
D=M
@5
D=D-A
@1
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Main.fibonacci
0;JMP
(RETURN_ADDRESS.Main.fibonacci.1)
//label WHILE

(WHILE
)
//goto WHILE
@WHILE
0;JMP
