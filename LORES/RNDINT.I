procedure Seed(s: integer);
begin
#a
 ldy #5
 lda (_sp),y
 bne seed1
 lda $4e   ; $4e BASIC KBD random
seed1 sta rnd 
 iny
 lda (_sp),y
 sta rnd+1
#
end;

procedure SeedTime;
begin
#a
 jsr _mli
 db $82 ;get time
 dw 0
 lda $BF92
 sta rnd
 lda $BF93
 and #$7F
 sta rnd+1
#
end;
#a
rnd dw $1234
#

function Rnd: integer;
begin
 Rnd := 0;
#a
 ldy #17 ;Wozniak lcg
rnd1 lda rnd+1
 asl
 clc
 adc #$40
 asl
 rol rnd
 rol rnd+1
 dey
 bne rnd1
 ldy #5 ;return new value
 lda rnd
 sta (_sp),y
 iny
 lda rnd+1
 sta (_sp),y
#
end;

function RndVal(min, max: integer): integer;
begin
 RndVal := (abs(Rnd) mod (max - min + 1)) + min;
end;
 