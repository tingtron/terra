(* Change to LoRes mode *) 

#A
GBASL   EQU $26
GBASH   EQU $27
Mask    EQU $2E
Color   EQU $30

LowScr  EQU $C054
HiScr   EQU $C055

AuxCol  DB  0
#

procedure DoLoRes;
begin
#a
 STX _T
 STA $C00D ;80COLON
 LDA $C05E ;SetAn3 (enable double-wide)
 LDA $C056 ;LoRes (HiRes OFF)
 JSR $FB40 ;SetGr (LoRes) 
 LDA HiScr
 JSR $F836 ;ClrTop or $F832 ClrScr
 LDA LowScr 
 LDX _T
#
end;

procedure DoLoRes2;
begin
#a
 STX _T
 LDA $C050 ;TxtClr (disp. graphics)
 BIT $C053 ;MixSet (Full Screen)
 BIT $C052 ;MixClr (Full Screen)
 LDA $C054 ;LowScr
 LDA $C056 ;LoRes (HiRes OFF)
 STA $C001 ;Set80Vid 80-col storage
 STA $C00D ;80COLON
 LDA $C05E ;SetAn3 (enable double-wide)
; JSR $FB40 ;SetGr (LoRes) 
 LDA HiScr
 JSR $F836 ;ClrTop or $F832 ClrScr
; LDA $18   ;top=bottom=line 24
; JSR $FB4B ;SetWnd
 LDA LowScr 
 JSR $F836 ;ClrTop or $F832 ClrScr
 LDX _T
#
end;

PROCEDURE TextMode;
BEGIN
#A
 STX _T
 JSR $FB39 ;SetTxt
 JSR $FC58 ;Home
 LDX _T
#
END;

PROCEDURE Color(C: INTEGER);
BEGIN
#A
 LDY #5
 LDA (_SP),Y
 JSR $F864 ;SetCol
 LDA Color
 PHA       ;Shift right
 LSR
 PLA
 ROR
 STA AuxCol 
#
END;

PROCEDURE Plot(X, Y: INTEGER);
BEGIN
#A
 STX _T
 LDY #5
 LDA (_SP),Y
 TAX
 LDY #7
 LDA (_SP),Y
 TAY
 TXA
 JSR DPLOT
 LDX _T
#
END;

#A
DPLOT    LSR
         PHP
         JSR   $F847 ;GBASCALC
         PLP
         LDA   #$F
         BCC   SETMASK
         ADC   #$E0
SETMASK  STA   Mask
DPLOT1   TYA
         PHA
         LSR
         TAY
         BCS   DPMAIN

         PHP
         SEI
         LDA   HISCR

         LDA   (GBASL),Y
         EOR   AuxCol
         AND   Mask
         EOR   (GBASL),Y
         STA   (GBASL),Y
         LDA   LOWSCR
         PLP
         PLA
         TAY
         RTS
DPMAIN   JSR   $F80E ;PLOT1
         PLA
         TAY
         RTS
#

FUNCTION KeyPressed: BOOLEAN;
VAR
 R: BOOLEAN;
BEGIN
#A
 LDA $C000
 AND #$80
 ASL
 ROL
 LDY #5
 STA (_SP),Y
#
 KeyPressed := R
END;

PROCEDURE WaitKey;
BEGIN
#A
 LDA $C000
 BPL *-3
 STA $C010
#
END;

