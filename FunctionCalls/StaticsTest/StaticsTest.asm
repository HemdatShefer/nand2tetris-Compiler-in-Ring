//Bootstrap code
@256
D=A
@SP
M=D
//call Sys.init 0
@RETURN_ADDRESS.Sys.init.1
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
@0
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Sys.init
0;JMP
(RETURN_ADDRESS.Sys.init.1)
//function Class1.set 0

(Class1.set)
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
//pop static 0

@SP
M=M-1
A=M
D=M
@.0

M=D
//push argument 1

@1

D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//pop static 1

@SP
M=M-1
A=M
D=M
@.1

M=D
//push constant 0

@0

D=A
@SP
A=M
M=D
@SP
M=M+1
//return
@LCL
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M+1
@SP
M=D
@R13
AM=M-1
D=M
@THAT
M=D
@R13
AM=M-1
D=M
@THIS
M=D
@R13
AM=M-1
D=M
@ARG
M=D
@R13
AM=M-1
D=M
@LCL
M=D
@R14
A=M
0;JMP
//function Class1.get 0

(Class1.get)
//push static 0

@0

D=M
@SP
A=M
M=D
@SP
M=M+1
//push static 1

@1

D=M
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
//return
@LCL
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M+1
@SP
M=D
@R13
AM=M-1
D=M
@THAT
M=D
@R13
AM=M-1
D=M
@THIS
M=D
@R13
AM=M-1
D=M
@ARG
M=D
@R13
AM=M-1
D=M
@LCL
M=D
@R14
A=M
0;JMP
//function Class2.set 0

(Class2.set)
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
//pop static 0

@SP
M=M-1
A=M
D=M
@.0

M=D
//push argument 1

@1

D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//pop static 1

@SP
M=M-1
A=M
D=M
@.1

M=D
//push constant 0

@0

D=A
@SP
A=M
M=D
@SP
M=M+1
//return
@LCL
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M+1
@SP
M=D
@R13
AM=M-1
D=M
@THAT
M=D
@R13
AM=M-1
D=M
@THIS
M=D
@R13
AM=M-1
D=M
@ARG
M=D
@R13
AM=M-1
D=M
@LCL
M=D
@R14
A=M
0;JMP
//function Class2.get 0

(Class2.get)
//push static 0

@0

D=M
@SP
A=M
M=D
@SP
M=M+1
//push static 1

@1

D=M
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
//return
@LCL
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M+1
@SP
M=D
@R13
AM=M-1
D=M
@THAT
M=D
@R13
AM=M-1
D=M
@THIS
M=D
@R13
AM=M-1
D=M
@ARG
M=D
@R13
AM=M-1
D=M
@LCL
M=D
@R14
A=M
0;JMP
//function Sys.init 0

(Sys.init)
//push constant 6

@6

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 8

@8

D=A
@SP
A=M
M=D
@SP
M=M+1
//call Class1.set 2

@RETURN_ADDRESS.Class1.set.2
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
@2

D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Class1.set
0;JMP
(RETURN_ADDRESS.Class1.set.2)
//pop temp 0
@0
D=A
@5
D=D+A
@13
M=D
@SP
M=M-1
A=M
D=M
@13
A=M
M=D
//push constant 23

@23

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 15

@15

D=A
@SP
A=M
M=D
@SP
M=M+1
//call Class2.set 2

@RETURN_ADDRESS.Class2.set.3
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
@2

D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Class2.set
0;JMP
(RETURN_ADDRESS.Class2.set.3)
//pop temp 0
@0
D=A
@5
D=D+A
@13
M=D
@SP
M=M-1
A=M
D=M
@13
A=M
M=D
//call Class1.get 0

@RETURN_ADDRESS.Class1.get.4
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
@0

D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Class1.get
0;JMP
(RETURN_ADDRESS.Class1.get.4)
//call Class2.get 0

@RETURN_ADDRESS.Class2.get.5
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
@0

D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@Class2.get
0;JMP
(RETURN_ADDRESS.Class2.get.5)
//label WHILE
(WHILE)
//goto WHILE
@WHILE
0;JMP
