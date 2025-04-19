//push constant 17

@17

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 17

@17

D=A
@SP
A=M
M=D
@SP
M=M+1
// eq  ── Pop y, pop x, push -(x==y)
@SP
  // A=0
M=M-1
  // SP = SP-1 (now points to y)
A=M
  // A = y address
D=M
  // D = y
A=A-1
  // A = x address (SP‑1)
M=M-D
  // x = x‑y (result stored at SP‑1)
D=M
  // D = x‑y  (0 ⇢ equal)
@LOOP1
  // if D≠0 jump → false block
D;JNE
@SP
  // A=0
M=M-1
  // SP = SP-1 (back to result cell)
A=M
  // A = result address
M=-1
  // push TRUE  (‑1)
@END1
  // skip false block
0;JMP
(LOOP1)
@SP
  // A=0
M=M-1
  // SP‑‑ (back to result cell)
A=M
  // A = result address
M=0
  // push FALSE (0)
(END1)
@SP
  // A=0
M=M+1
  // SP = SP+1 (stack grows)
//push constant 17

@17

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 16

@16

D=A
@SP
A=M
M=D
@SP
M=M+1
// eq  ── Pop y, pop x, push -(x==y)
@SP
  // A=0
M=M-1
  // SP = SP-1 (now points to y)
A=M
  // A = y address
D=M
  // D = y
A=A-1
  // A = x address (SP‑1)
M=M-D
  // x = x‑y (result stored at SP‑1)
D=M
  // D = x‑y  (0 ⇢ equal)
@LOOP2
  // if D≠0 jump → false block
D;JNE
@SP
  // A=0
M=M-1
  // SP = SP-1 (back to result cell)
A=M
  // A = result address
M=-1
  // push TRUE  (‑1)
@END2
  // skip false block
0;JMP
(LOOP2)
@SP
  // A=0
M=M-1
  // SP‑‑ (back to result cell)
A=M
  // A = result address
M=0
  // push FALSE (0)
(END2)
@SP
  // A=0
M=M+1
  // SP = SP+1 (stack grows)
//push constant 16

@16

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 17

@17

D=A
@SP
A=M
M=D
@SP
M=M+1
// eq  ── Pop y, pop x, push -(x==y)
@SP
  // A=0
M=M-1
  // SP = SP-1 (now points to y)
A=M
  // A = y address
D=M
  // D = y
A=A-1
  // A = x address (SP‑1)
M=M-D
  // x = x‑y (result stored at SP‑1)
D=M
  // D = x‑y  (0 ⇢ equal)
@LOOP3
  // if D≠0 jump → false block
D;JNE
@SP
  // A=0
M=M-1
  // SP = SP-1 (back to result cell)
A=M
  // A = result address
M=-1
  // push TRUE  (‑1)
@END3
  // skip false block
0;JMP
(LOOP3)
@SP
  // A=0
M=M-1
  // SP‑‑ (back to result cell)
A=M
  // A = result address
M=0
  // push FALSE (0)
(END3)
@SP
  // A=0
M=M+1
  // SP = SP+1 (stack grows)
//push constant 892

@892

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 891

@891

D=A
@SP
A=M
M=D
@SP
M=M+1

Lt
@SP
  // A=0
M=M-1
  // SP--  (SP now points to y)
A=M
  // A=y address
D=M
  // D=y
A=A-1
  // A = x address (SP‑1)
M=M-D
  // M = x - y   (negative ⇢ x<y)
D=M
  // D = x - y
@LOOP4
  // jump if D≥0 (JGE)
D;JGE
@SP
  // A=0
M=M-1
  // SP--  (back to result cell)
A=M
  // A = result cell
M=-1
  // push TRUE  (-1)
@END4
  // skip FALSE block
0;JMP
(LOOP4)
@SP
  // A=0
M=M-1
  // SP--  (result cell)
A=M
  // A = result cell
M=0
  // push FALSE (0)
(END4)
@SP
  // A=0
M=M+1
  // SP++   (stack grows)
//push constant 891

@891

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 892

@892

D=A
@SP
A=M
M=D
@SP
M=M+1

Lt
@SP
  // A=0
M=M-1
  // SP--  (SP now points to y)
A=M
  // A=y address
D=M
  // D=y
A=A-1
  // A = x address (SP‑1)
M=M-D
  // M = x - y   (negative ⇢ x<y)
D=M
  // D = x - y
@LOOP5
  // jump if D≥0 (JGE)
D;JGE
@SP
  // A=0
M=M-1
  // SP--  (back to result cell)
A=M
  // A = result cell
M=-1
  // push TRUE  (-1)
@END5
  // skip FALSE block
0;JMP
(LOOP5)
@SP
  // A=0
M=M-1
  // SP--  (result cell)
A=M
  // A = result cell
M=0
  // push FALSE (0)
(END5)
@SP
  // A=0
M=M+1
  // SP++   (stack grows)
//push constant 891

@891

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 891

@891

D=A
@SP
A=M
M=D
@SP
M=M+1

Lt
@SP
  // A=0
M=M-1
  // SP--  (SP now points to y)
A=M
  // A=y address
D=M
  // D=y
A=A-1
  // A = x address (SP‑1)
M=M-D
  // M = x - y   (negative ⇢ x<y)
D=M
  // D = x - y
@LOOP6
  // jump if D≥0 (JGE)
D;JGE
@SP
  // A=0
M=M-1
  // SP--  (back to result cell)
A=M
  // A = result cell
M=-1
  // push TRUE  (-1)
@END6
  // skip FALSE block
0;JMP
(LOOP6)
@SP
  // A=0
M=M-1
  // SP--  (result cell)
A=M
  // A = result cell
M=0
  // push FALSE (0)
(END6)
@SP
  // A=0
M=M+1
  // SP++   (stack grows)
//push constant 32767

@32767

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 32766

@32766

D=A
@SP
A=M
M=D
@SP
M=M+1
// gt  ── Pop y, pop x, push -(x>y)
@SP
  // A=0
M=M-1
  // SP--  (SP now points to y)
A=M
  // A=y address
D=M
  // D=y
A=A-1
  // A = x address (SP‑1)
M=M-D
  // M = x - y   (positive ⇢ x>y)
D=M
  // D = x - y
@LOOP7
  // jump if D≤0 (JLE)
D;JLE
@SP
  // A=0
M=M-1
  // SP--  (back to result cell)
A=M
  // A = result cell
M=-1
  // push TRUE (-1)
@END7
  // skip FALSE block
0;JMP
(LOOP7)
@SP
  // A=0
M=M-1
  // SP--  (result cell)
A=M
  // A = result cell
M=0
  // push FALSE (0)
(END7)
@SP
  // A=0
M=M+1
  // SP++
//push constant 32766

@32766

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 32767

@32767

D=A
@SP
A=M
M=D
@SP
M=M+1
// gt  ── Pop y, pop x, push -(x>y)
@SP
  // A=0
M=M-1
  // SP--  (SP now points to y)
A=M
  // A=y address
D=M
  // D=y
A=A-1
  // A = x address (SP‑1)
M=M-D
  // M = x - y   (positive ⇢ x>y)
D=M
  // D = x - y
@LOOP8
  // jump if D≤0 (JLE)
D;JLE
@SP
  // A=0
M=M-1
  // SP--  (back to result cell)
A=M
  // A = result cell
M=-1
  // push TRUE (-1)
@END8
  // skip FALSE block
0;JMP
(LOOP8)
@SP
  // A=0
M=M-1
  // SP--  (result cell)
A=M
  // A = result cell
M=0
  // push FALSE (0)
(END8)
@SP
  // A=0
M=M+1
  // SP++
//push constant 32766

@32766

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 32766

@32766

D=A
@SP
A=M
M=D
@SP
M=M+1
// gt  ── Pop y, pop x, push -(x>y)
@SP
  // A=0
M=M-1
  // SP--  (SP now points to y)
A=M
  // A=y address
D=M
  // D=y
A=A-1
  // A = x address (SP‑1)
M=M-D
  // M = x - y   (positive ⇢ x>y)
D=M
  // D = x - y
@LOOP9
  // jump if D≤0 (JLE)
D;JLE
@SP
  // A=0
M=M-1
  // SP--  (back to result cell)
A=M
  // A = result cell
M=-1
  // push TRUE (-1)
@END9
  // skip FALSE block
0;JMP
(LOOP9)
@SP
  // A=0
M=M-1
  // SP--  (result cell)
A=M
  // A = result cell
M=0
  // push FALSE (0)
(END9)
@SP
  // A=0
M=M+1
  // SP++
//push constant 57

@57

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 31

@31

D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant 53

@53

D=A
@SP
A=M
M=D
@SP
M=M+1
//add
@SP
M=M-1
A=M
D=M
A=A-1
M=M+D
//push constant 112

@112

D=A
@SP
A=M
M=D
@SP
M=M+1
//sub
@SP
M=M-1
A=M
D=M
A=A-1
M=M-D
//neg
@SP
A=M-1
M=-M
//and
@SP
M=M-1
A=M
D=M
A=A-1
M=M&D
//push constant 82

@82

D=A
@SP
A=M
M=D
@SP
M=M+1
//or
@SP
M=M-1
A=M
D=M
A=A-1
M=M|D
//not
@SP
A=M-1
M=!M
