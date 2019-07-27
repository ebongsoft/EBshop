* [SHA1 ¼ÓÃÜ]

*!*    SHA1 
*!*    Auteur : C.Chenavier 
*!*    Version : 1.00 - 15/11/2004 


FUNCTION SHA1( cMessage ) 

PRIVATE HO, H1, H2, H3, H4 
LOCAL nNbBlocs, nHigh, nLow 

H0 = 0x67452301 
H1 = 0xEFCDAB89 
H2 = 0x98BADCFE 
H3 = 0x10325476 
H4 = 0xC3D2E1F0 

M.nNbBlocs = LEN(M.cMessage) / 64 

M.nLen = LEN(M.cMessage) 
M.nReste = MOD(M.nLen, 64) 
IF M.nReste > 0 OR M.nLen = 0 
   M.nNbBlocs = M.nNbBlocs + 1 
   IF M.nReste > 55 
      M.cMessage = M.cMessage + CHR(2^7) + REPLICATE(CHR(0), (64 - M.nReste) + 55) 
      M.nNbBlocs = M.nNbBlocs + 1 
   ELSE 
      M.cMessage = M.cMessage + CHR(2^7) + REPLICATE(CHR(0), (55 - M.nReste)) 
   ENDIF 
   M.nHigh = (M.nLen*8) / 2^32 
   M.nLow = MOD(M.nLen*8, 2^32) 
   M.cMessage = M.cMessage + CHR(BITAND(BITRSHIFT(M.nHigh, 24), 0xFF)) ;    && 56 
                           + CHR(BITAND(BITRSHIFT(M.nHigh, 16), 0xFF)) ;    && 57 
                           + CHR(BITAND(BITRSHIFT(M.nHigh, 8), 0xFF))  ;    && 58 
                           + CHR(BITAND(M.nHigh, 0xFF)) ;                   && 59 
                           + CHR(BITAND(BITRSHIFT(M.nLow, 24), 0xFF)) ;     && 60 
                           + CHR(BITAND(BITRSHIFT(M.nLow, 16), 0xFF)) ;     && 61 
                           + CHR(BITAND(BITRSHIFT(M.nLow, 8), 0xFF))  ;     && 62 
                           + CHR(BITAND(M.nLow, 0xFF))                      && 63 
ENDIF 

LOCAL i 

FOR I = 1 TO M.nNbBlocs 
    DO SHA1_ProcessBloc WITH SUBSTR(M.cMessage, 1 + 64*(I-1), 64) 
ENDFOR 

RETURN SUBSTR(TRANSFORM(H0,"@0"),3) + ; 
       SUBSTR(TRANSFORM(H1,"@0"),3) + ; 
       SUBSTR(TRANSFORM(H2,"@0"),3) + ; 
       SUBSTR(TRANSFORM(H3,"@0"),3) + ; 
       SUBSTR(TRANSFORM(H4,"@0"),3) 


PROCEDURE SHA1_ProcessBloc 

LPARAMETERS cBloc 

LOCAL I, A, B, C, D, E, nTemp 
LOCAL ARRAY W(80) 

FOR I = 1 TO 16 
    W(I) = BITLSHIFT(ASC(SUBSTR(M.cBloc, (I-1) * 4 + 1, 1)), 24) + ; 
           BITLSHIFT(ASC(SUBSTR(M.cBloc, (I-1) * 4 + 2, 1)), 16) + ; 
           BITLSHIFT(ASC(SUBSTR(M.cBloc, (I-1) * 4 + 3, 1)), 8) + ; 
           ASC(SUBSTR(M.cBloc, (I-1) * 4 + 4, 1)) 
ENDFOR 

FOR I = 17 TO 80 
    W(i) = BitLRotate(1, BITXOR(W(i-3), W(i-8), W(i-14), W(i-16))) 
ENDFOR 

A = H0 
B = H1 
C = H2 
D = H3 
E = H4 

FOR I = 1 TO 20 
    M.nTemp = BitLRotate(5,A) + BITOR(BITAND(B,C), BITAND(BITNOT(B), D)) + ; 
              E + W(i) + 0x5A827999 
    E = D 
    D = C 
    C = BitLRotate(30,B) 
    B = A 
    A = M.nTemp 
ENDFOR 

FOR I = 21 TO 40 
    M.nTemp = BitLRotate(5,A) + BITXOR(B, C, D) + E + W(i) + 0x6ED9EBA1 
    E = D 
    D = C 
    C = BitLRotate(30,B) 
    B = A 
    A = M.nTemp 
ENDFOR 

FOR I = 41 TO 60 
    M.nTemp = BitLRotate(5,A) + BITOR(BITAND(B,C), BITAND(B,D), BITAND(C,D)) + ; 
              E + W(i) + 0x8F1BBCDC 
    E = D 
    D = C 
    C = BitLRotate(30,B) 
    B = A 
    A = M.nTemp 
ENDFOR 

FOR I = 61 TO 80 
    M.nTemp = BitLRotate(5,A) + BITXOR(B, C, D) + E + W(i) + 0xCA62C1D6 
    E = D 
    D = C 
    C = BitLRotate(30,B) 
    B = A 
    A = M.nTemp 
ENDFOR 

H0 = H0 + A 
H1 = H1 + B 
H2 = H2 + C 
H3 = H3 + D 
H4 = H4 + E 

RETURN 

FUNCTION BitLRotate( nBits, nWord ) 

RETURN BITLSHIFT(M.nWord, M.nBits) + BITRSHIFT(M.nWord, (32-(M.nBits)))