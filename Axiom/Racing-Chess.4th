$passTurnForced ON

{players
	{player}	Red		{random}
	{player}	Blue	{random}
players}

{turn-order
	{turn}	Red		{of-type} drop-move
	{turn}	Blue	{of-type} drop-move
	{turn}	Red		{of-type} drop-move
	{turn}	Blue	{of-type} drop-move
	{turn}	Red		{of-type} drop-move
	{turn}	Blue	{of-type} drop-move
	{turn}	Red		{of-type} drop-move
	{turn}	Blue	{of-type} drop-move
	{repeat}
	{turn}	Red		{of-type} normal-move
	{turn}	Blue	{of-type} normal-move
turn-order}

\ determine total number of pieces racing
8 CONSTANT #NumOfPieces

\ determine score of every rank
CREATE #TopScores
	10 , 8 , 6 , 5 , 4 , 3 , 2 , 1 , 0


LOAD Racing-Chess-Board.4th

\ because pieces are not defined now
1 CONSTANT @oRook
2 CONSTANT @oKnight
3 CONSTANT @oBishop
4 CONSTANT @oQueen
5 CONSTANT @Rook
6 CONSTANT @Knight
7 CONSTANT @Bishop
8 CONSTANT @Queen

LOAD Racing-Chess-Moves.4th

{pieces
	{piece}	oRook	{moves} oRook-moves		{drops} oRook-drops
	{piece}	oKnight {moves} oKnight-moves	{drops} oKnight-drops
	{piece}	oBishop {moves} oBishop-moves	{drops} oBishop-drops
	{piece}	oQueen	{moves} oQueen-moves	{drops} oQueen-drops
	{piece}	Rook	{moves} Rook-moves
	{piece}	Knight	{moves} Knight-moves
	{piece}	Bishop	{moves} Bishop-moves
	{piece}	Queen	{moves} Queen-moves
	{piece} Top1
	{piece} Top2
	{piece} Top3
	{piece} Top4
	{piece} Top5
	{piece} Top6
	{piece} Top7
	{piece} Top8
	{piece} Top9
pieces}


: OnNewGame
	0 NumOfFinished !
	0 ScoreRed !
	0 ScoreBlue !
	
	1 RedRook !
	2 RedKnight !
	2 RedBishop !
	1 RedQueen !
	
	1 BlueRook !
	2 BlueKnight !
	2 BlueBishop !
	1 BlueQueen !
;

: OnIsGameOver
	NumOfFinished @ #NumOfPieces >= IF
		^" Red: " ScoreRed @ ^number LF ^char
		^" Blue: " ScoreBlue @ ^number LF ^char
		ScoreRed @ ScoreBlue @ = IF
			#DrawScore
		ELSE
			current-player Red = ScoreRed @ ScoreBlue @ < XOR IF
				#WinScore
			ELSE
				#LossScore
			ENDIF
		ENDIF
	ELSE
		#UnknownScore
	ENDIF
;