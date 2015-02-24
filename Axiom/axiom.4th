(
*******************************
* axiom - A meta-game engine. *
*                             *
* by                          *
*	Greg Schmidt          *
*                             *
* Copyright {c} 2008          *
*******************************
)

(
********************
* System constants *
********************
)
140 CONSTANT #Version		\ Axiom version number.
128 CONSTANT #Directions	\ Maximum number of directions.
128 CONSTANT #Moves		\ Maximum number of moves within a {moves ... moves} block.
128 CONSTANT #MaxPriorities	\ Maximum number of move priorities.
128 CONSTANT #Turns		\ Maximum number of turns.

( Search depth control )
3  CONSTANT #DepthLimit		\ Maximum number of plys searched.
10 CONSTANT #ForeverDepth	\ Depth when thinking time is set to "Forever".

( Score values )
-2140000000 CONSTANT #UnknownScore
-2130000000 CONSTANT #LossScore
          0 CONSTANT #DrawScore
 2130000000 CONSTANT #WinScore

( Search status enumeration )
0 CONSTANT #KeepSearching
1 CONSTANT #StopSoon
2 CONSTANT #StopNow

( Do not change these! )
32   CONSTANT #Players		\ Maximum number of players.
1024 CONSTANT #Pieces		\ Maximum number of piece types.
4    CONSTANT #PieceCells	\ Number of CELLs for each {piece} definition.
3    CONSTANT #TurnOrderCells	\ Number of CELLs for each {turn} in the turn-order.
1024 CONSTANT #Neutral		\ Bit indicating a neutral player.
2048 CONSTANT #PlayerBase	\ Base offset for player encoding.
0    CONSTANT #NoMoveType	\ Default move-type value.
1000 CONSTANT #NoPriority	\ Default move-priority value.
1    CONSTANT #movesCell	\ CELL offset to {moves} within piece.
2    CONSTANT #DropsCell	\ CELL offset to {drops} within piece.
3    CONSTANT #ValueCell	\ CELL offset to {value} within piece.
HEX
FFFF CONSTANT #PiecePlayer	\ Mask for isolating piece and player values.
03FF CONSTANT #PieceType	\ Mask for isolating piece Type.
FC00 CONSTANT #Player		\ Mask for isolating player value - includes number & neutral indication.
F800 CONSTANT #PlayerNumber	\ Mask for isolating player number.
DECIMAL
11   CONSTANT #PlayerShift	\ Number of bits player is left shifted.
0    CONSTANT #Empty		\ Contents of an empty position.

(
   Piece encoding:

     31  30  29  28    27  26  25  24    23  22  21  20    19  18  17  16
   +---+---+---+---+ +---+---+---+---+ +---+---+---+---+ +---+---+---+---+
hi | A | A | A | A | | A | A | A | A | | A | A | A | A | | A | A | A | A |
   +---+---+---+---+ +---+---+---+---+ +---+---+---+---+ +---+---+---+---+

     15  14  13  12    11  10  9   8     7   6   5   4     3   2   1   0
   +---+---+---+---+ +---+---+---+---+ +---+---+---+---+ +---+---+---+---+
lo | P | P | P | P | | P | N | T | T | | T | T | T | T | | T | T | T | T |
   +---+---+---+---+ +---+---+---+---+ +---+---+---+---+ +---+---+---+---+


   Key:
	P = player #
	N = neutral piece indicator
	T = piece type
	A = attribute
)

(
********************
* System variables *
********************
)

( Board positions )
VARIABLE $rows			\ Number of rows in the grid, 0 if no grid defined.
VARIABLE $columns		\ Number of columns in the grid, 0 if no grid defined.
VARIABLE $posCount		\ Total number of {positions} on the board.
VARIABLE $lastPosNFA		\ The NFA of the last defined position.
VARIABLE $positions		\ Total number of {grid} positions + {positions} on the board.
VARIABLE $boardSize		\ Total board size - includes {variable}'s.
VARIABLE $board			\ Address of the current active board.
VARIABLE $posNames		\ List of all position names.

( Directions )
VARIABLE $directions		\ List of all directions.
VARIABLE $directionCount	\ Number of directions.
VARIABLE $symmetries		\ List of symmetries.

( Pieces )
VARIABLE $pieces		\ List of pieces (piece types).
VARIABLE $pieceCount		\ Number of pieces.
VARIABLE $zobrist		\ Zobrist hash tables.

( Players )
VARIABLE $playerCount		\ The number of players.
VARIABLE $players		\ List of players.
VARIABLE $playerName		\ Current player name.
VARIABLE $playerOffset		\ Current player's offset into list of players.
VARIABLE $engines		\ Search engines for each player.
VARIABLE $playerToMoveHash	\ For including the player to move in the hash key.

( Turns )
VARIABLE $turnOrder		\ List of turn definitions.
VARIABLE $turnOffset		\ Current offset into turn order list.
VARIABLE $turnLimit		\ The index just past the last legal turn.
VARIABLE $ofType		\ Player only makes moves of this type.
VARIABLE $forPlayer		\ Player makes moves for this player.
VARIABLE $turnNumber		\ The current turn number (0 = new game).

( Search )
VARIABLE $movesList		\ List of legal moves during a search.
VARIABLE $timeCheckFrequency	\ Check time for termination after this many evals.
100 $timeCheckFrequency !
VARIABLE $depthLimit		\ Depth limit according to Zillions (read-only).
VARIABLE $searchTime		\ Search time limit in milliseconds.
VARIABLE $variety		\ Variety level (1-10).
VARIABLE $lastMoveType		\ The move type of the most recently applied move.
VARIABLE $ply			\ Current ply during search.
VARIABLE $rootMoveCount		\ The number of root level moves during the search.
VARIABLE $rootMoveIndex		\ The index of the root level move currently being searched.
VARIABLE $searchStatus		\ Controls the search.
TIMER    $searchTimer		\ Internal search timer.

( Move priorities )
VARIABLE $move-priorities	\ List of move priorities.

( Move Generation support - valid only during move generation. )
VARIABLE $from			\ The starting board position for this move (constant across multiple add's).
VARIABLE $pos			\ The current board position for this move.
VARIABLE $piece			\ Piece and owning player of the piece - not necessarily whose turn it is.
VARIABLE $player		\ Current player according to the turnOrder.
VARIABLE $partial		\ True if the most recently executed move is a partial move.
VARIABLE $passed		\ True if a "Pass" move was generated during move generation.
$passed OFF
VARIABLE $context		\ Used during move generation to keep track of piece type & owner changes.
0 CONSTANT #NoContext		\ Indicates no context information is available.
1 CONSTANT #ImplicitPosition	\ Indicates an implicit position has been assumed.
2 CONSTANT #ChangedType		\ Indicates previous command was a "change-type".
4 CONSTANT #ChangedOwner	\ Indicates previous command was a "change-owner".
8 CONSTANT #Moved		\ Indicates previous command was a "move".
VARIABLE $changedTo		\ Last piece type for "change-type" or last owner for "change-owner".
VARIABLE $lastPos		\ The last position that was modified.

( Internal )
VARIABLE $nextPiece		\ For assigning pieces types when compiling pieces.
VARIABLE $currDirection		\ For compiling directions and links.
VARIABLE $moveType		\ For assigning move types when compiling moves.
VARIABLE $repeatOffset		\ Offset into {turn-order} where {repeat} occurs.
VARIABLE $priority		\ For assigning move priorities when compiling move priorities.

( Board setup )
VARIABLE $boardSetup		\ List of board setup edits.

( Axiom Directives )
VARIABLE $gameLog		\ If TRUE, axiom output statements will be directed to <game>.log
$gameLog OFF
VARIABLE $flipGrid		\ If FALSE (default), the top left corner of the grid is labeled 'a1' (as in Chess notation).
$flipGrid OFF			\ If TRUE, the grid is 'flipped' and the top left corner of the grid is labeled 'a1'.
VARIABLE $passTurnForced	\ A player may pass if and only if he has no moves.
$passTurnForced OFF
VARIABLE $shareMovesList	\ Share the moves list between the engine and OnIsGameOver/OnEvaluate.
$shareMovesList ON
VARIABLE $combinePartial	\ If TRUE, the engine won't evaluate an incomplete partial move sequence.
$combinePartial ON
VARIABLE $useAxiomEngine	\ Set to FALSE if not using the axiom search engine.
$useAxiomEngine ON
VARIABLE $gameResultBug		\ Set to TRUE if the game exhibits the incorrect game result when scrolling through
$gameResultBug ON		\   the moves list window.  Most games appear to exhibit this bug.

: $addr, ( addr value -- addr' )
	OVER ! CELLSIZE +
;

( General Utility )
: $CellCount ( startAddr endAddr -- cellCount )
	CELLSIZE - SWAP - CELLSIZE /
;

: $CommaCells ( val size -- )
	0 DO DUP , LOOP DROP
;

: $MakeConstant ( value nameAddr -- )
	HEADER , DOES> @
;

( String insertion )
: (^") R ^string R> DUP "SIZE + >R ;
: ^"
	34 WORD PAD
	STATE @
	IF
		COMPILE (^")
		HERE "MOVE
		HERE "SIZE ALLOT
	ELSE
		TYPE
	ENDIF
; IMMEDIATE

: $PositionToIndex ( columnChar row# -- index )
	$flipGrid @
	IF
		1-
	ELSE
		$rows @ SWAP -
	ENDIF
	$columns @ * SWAP ASCII a - +
;

: $IndexToPosition ( index -- columnChar row# )
	$columns @ /MOD
	$flipGrid @
	IF
		1+
	ELSE
		$rows @ SWAP -
	ENDIF
	SWAP ASCII a + SWAP
;

: $RowColumnToIndex ( row column -- index )
	SWAP $columns @ * +
;

: $LegalRow? ( row -- ? )
	DUP -1 > SWAP $rows @ < AND
;

: $LegalColumn? ( column -- ? )
	DUP -1 > SWAP $columns @ < AND
;

: $LegalPos? ( posIndex -- )
	DUP 0< NOT
	SWAP $positions @ <
	AND
;

( e.g. 10 0 North $Link )
: $Link ( from to dirAddr -- )
	>R SWAP CELLS R> + !
;

: $DoDirection
	$pos @ CELLS + @ DUP 0< ( *native* )
	IF
		DROP FALSE
	ELSE
		$pos ! ( update current position )
		TRUE
	ENDIF
;

: $BuildDirection
	HERE $currDirection ! -1 $positions @ $CommaCells
;


: $CreateDirection
	<BUILDS
		$BuildDirection
	DOES>
		$DoDirection
;

: $CreateDirectionFromString ( directionName -- )
	HEADER
		$BuildDirection
	DOES>
		$DoDirection
;

: $MakeLinks ( rowOffset columnOffset -- )
	$rows @ 0
	DO
          $columns @ 0
	  DO
	    ( J is Row, I is Column )
	    OVER J + $LegalRow?
	    IF 
		DUP I + $LegalColumn?
		IF
			OVER J + OVER I + $RowColumnToIndex
        		J I $RowColumnToIndex
			SWAP
			$currDirection @
			$Link
	        ENDIF
	    ENDIF
          LOOP
        LOOP
	2DROP
;

(
**************
* Directions *
**************
)

: {directions
	( board must be defined. )
	$board @ 0= ABORT" Error: board is not defined."

	0 $directionCount !
	HERE DUP
	$directions !
	#Directions CELLS ALLOT
;

: {direction} ( rowOffset columnOffset -- )
	$CreateDirection
	$MakeLinks
	LATEST NFA>CFA $addr,
	$directionCount ++
;

( e.g. {link} Next a1 a2 )
: {link} ( -- )
	-FIND
	DUP
	IF
		NFA>PFA $currDirection !
	ELSE
		DROP PAD $CreateDirectionFromString
		LATEST NFA>CFA $addr,
		$directionCount ++
	ENDIF
	' EXECUTE
	' EXECUTE
	$currDirection @
	$Link
;

( e.g. {unlink} North a1 )
: {unlink} ( -- )
	-1
	' CFA>PFA
	' EXECUTE CELLS +
	!
;

: directions}
	DROP
;

(
**********
* Search *
**********
)

( Move list support words. )

: $FirstMove ( -- firstMove ) $movesList @ 2 CELLS + @ ;
: $NextMove ( thisMove -- nextMove ) @ ;

: .moveString ( moveAddr -- moveStringAddr ) CELLSIZE + ;
: .moveType ( moveAddr -- moveTypeAddr ) [ 2 CELLS ] LITERAL + ;
: .moveCFA ( moveAddr -- moveCFA ) [ 4 CELLS ] LITERAL + ;

(
  - Simple search engines -

  Note: ZoG calls DLL_GenerateMoves prior to calling DLL_Search
        so the move list need not be regenerated by these.
)

: $FirstMoveEngine
	$FirstMove
	.moveString @			( pointer to move string )
	DUP CurrentMove! BestMove!			
	1 Nodes! 0 Score! 0 Depth!
	$Yield
;

: $RandomMoveEngine
	$FirstMove
	0				( produce random move index )
	$movesList @ CELLSIZE + @	( move-count )
	RAND-WITHIN 1-			( index ranges from 0 to n-1 )

	BEGIN
	DUP 0>
	WHILE
		SWAP @ SWAP		( next move )
		$Yield
		1-
	REPEAT
	DROP

	.moveString @			( pointer to move string )

	DUP CurrentMove! BestMove!
	1 Nodes! 0 Score! 0 Depth!
;

( Search engine invocation event )
: OnSearch
	$engines @ $playerOffset @ + @ EXECUTE \ Invoke the search engine defined for this player.
;

(
***********
* players *
***********

{players
	{player}	First
	{player}	Second
	{neutral}	Neutral
players}

Zillions doesn't allow plug-ins to define the players, so the
players here must match the zrf.
)

: {players
	HERE ['] $NegamaxMove #Players $CommaCells $engines !
	HERE #Players CELLS ALLOT
	DUP $players !
	1
;

: $EncodePlayer ( index -- playerNumber )
	#PlayerBase *
;

: $DefinePlayer ( addr index playerNumber -- addr' index' )
	CONSTANT 1+
	SWAP LATEST NFA>CFA $addr, SWAP
(	DUP >R
	CONSTANT 1+
	SWAP R> $addr, SWAP )
;

: {player}
	DUP $EncodePlayer $DefinePlayer
;

: {neutral}
	DUP $EncodePlayer #Neutral OR $DefinePlayer
;

: $CompileEngine ( index' engineCFA -- index' )
	OVER 1- 1- CELLS $engines @ + !
;

: {search-engine}
	' $CompileEngine
;

: {random}
	['] $RandomMoveEngine $CompileEngine
;

: {first}
	['] $FirstMoveEngine $CompileEngine
;

: players}
	1- DUP $playerCount !
	0= ABORT" Error: No players are defined."
	DROP
;

: $PlayerToIndex ( player -- 1BasedIndex )
	#PlayerNumber AND #PlayerBase /
;

: $PlayerToCellOffset ( player -- cellOffset )
	$PlayerToIndex 1- CELLS
;


(
**************
* turn-order *
**************
e.g.
{turn-order
	{turn}		First
	{repeat}
	{turn}		Second
	{turn}		First	{for-player} Second	{of-type} Capturemoves
turn-order}

Notes:
Zillions doesn't allow plug-ins to define the turn order, so the
turn order here must be equivalent to the zrf.
)

: {turn-order
	0 $repeatOffset !
	HERE DUP $turnOrder !
	#Turns CELLS ALLOT
;

: {turn}
	' DUP
	>R $addr,
	R> $addr, ( {for-player} )
	0  $addr, ( {of-type} )
;

: {for-player}
	' OVER 2 CELLS - !
;

: $DefineMoveType
	-FIND DUP
	IF
		NFA>CFA EXECUTE
	ELSE
		DROP
		$moveType ++
		$moveType @ DUP
		PAD $MakeConstant
	ENDIF
;

: {of-type}
	$DefineMoveType OVER CELLSIZE - !
;

: {repeat}
	DUP $turnOrder @ - $repeatOffset !
;


: turn-order}
	$turnOrder @ - $turnLimit !
;


: $SetPlayer ( playerCFA -- )
	DUP
	CFA>NFA @ $playerName !
	EXECUTE

 	DUP $player !
	$PlayerToCellOffset $playerOffset !
;

: $SetTurn ( turnOffset -- )
	DUP $turnOffset ! $turnOrder @ + DUP
	@ $SetPlayer

	( {for-player} )
	CELLSIZE + DUP @ EXECUTE $forPlayer !

	( {of-type} )
	CELLSIZE + @ $ofType !
;

: turn-offset ( -- turnOffset ) $turnOffset @ ;

: next-turn-offset ( turnOffset -- nextTurnOffset )
	#TurnOrderCells CELLS +
	DUP
	$turnLimit @ =
	IF
		DROP $repeatOffset @
	ENDIF
	$partial OFF ( $partial really only refers to 'our' last move. )
;

: turn-offset-to-player ( turnOffset -- player )
	$turnOrder @ + @ EXECUTE
;

: next-player ( -- nextPlayer )
	turn-offset next-turn-offset turn-offset-to-player
;

: OnNextTurn ( -- )
	$player @ \ Current player

	$turnOffset @ next-turn-offset
	$SetTurn

	$EngineSetTurn
;

(
**************
* Symmetries *
**************
e.g.
{symmetries
	Player {symmetry} North South
symmetries}
)

VARIABLE $direction1CFA
VARIABLE $direction2CFA

VARIABLE $direction1Index
VARIABLE $direction2Index

: {symmetries
	HERE $symmetries !

	( Generate list of directions for all players )
	( e.g. 3 players, 4 directions -> NNN SSS EEE WWW )
	( NNN = Player1North,Player2North,Player3North )
	$directionCount @ 0
	DO
		$playerCount @ 0
		DO
			$directions @ J CELLS + @ ,
		LOOP
	LOOP
;

: $DirectionCFAToIndex ( cfa -- offset )
	0 SWAP
	$directionCount @ CELLS $directions @ +
	$directions @
	DO
		DUP
		I @ =
		IF
			I $directions @ - CELLSIZE /
			>R SWAP DROP R> SWAP
			( EXIT )
		ENDIF
	CELLSIZE +LOOP
	DROP
;

: $Exchange ( addr1 addr2 -- )
	OVER @
	OVER @
	>R
	SWAP !
	R>
	SWAP !
;

: $DoIndirectDirection ( pfa -- )	( *native* )
	@ $playerOffset @ + @ ( DUP CFA>NFA @ TYPE ) EXECUTE
;

: $RedefineDirection ( baseDirectionAddr cfa -- )
	CFA>NFA @ HEADER ,
	DOES> $DoIndirectDirection
;

(
  Returns the base address of symmetries for a given direction
  This address is further indexed by player offset to yield
  the correct direction word.
)
: $symmetryBase ( directionIndex -- addr )
	$playerCount @ CELLS * $symmetries @ +
;

: {symmetry}
	' DUP $direction1CFA ! $DirectionCFAToIndex $direction1Index !
	' DUP $direction2CFA ! $DirectionCFAToIndex $direction2Index !

	( 1 - Exchange the position of both words in the symmetry list )
	$PlayerToCellOffset

	$direction1Index @ $symmetryBase ( add player offset ) OVER + SWAP
	$direction2Index @ $symmetryBase ( add player offset ) +

	$Exchange

	( 2 - Redefine both words to use the symmetry list )
	$direction1Index @ $symmetryBase $direction1CFA @ $RedefineDirection
	$direction2Index @ $symmetryBase $direction2CFA @ $RedefineDirection
;

: symmetries}
;

(
*********
* moves *
*********
e.g.
{moves	PawnMoves
	{move} PawnAdvance
	{move} PawnCapture
moves}

Notes:
All moves must be defined by the plug-in.  Therefore the
zrf should not define any moves or drops.

There is no distinction here between the Zillions notion of
"moves" vs. "drops" in the above move definition.  The
distinction is made when assigning the moves to the
piece types.
)

: {moves
	CREATE HERE 0 ,
	0 ( count )
	HERE
	#Moves CELLS ALLOT
;

: {move}
	' $addr, ( move )
	0 $addr, ( move-type )
	SWAP 1+ SWAP ( count ++ )
;

: {move-type}
	$DefineMoveType
	OVER CELLSIZE - !
;

: moves}
	DROP
	DUP 0= ABORT" Error: No moves defined."
	SWAP !
;

(
*******************
* move priorities *
*******************
e.g.
{move-priorities
	{move-priority} Capturing
	{move-priority} Noncapturing
move-priorities}
)

: {move-priorities
	HERE DUP $move-priorities !
	#NoPriority #MaxPriorities $CommaCells
;

: {move-priority}
	DUP $DefineMoveType CELLS +
	$priority @ SWAP !
	$priority ++
;

: move-priorities}
	DROP
;


(
**********
* pieces *
**********
e.g.
{pieces
	{piece}		Pawn	{moves} PawnMoves	10 {value}
	{piece}		Fence	{drops} FenceDrops	 1 {value}
pieces}

Notes:
Zillions doesn't allow plug-ins to define the pieces, so the
piece definitions here must match the zrf.  However, the
moves for the pieces are defined by the plug-in.

The only difference between {drops} and {moves} is that
{drops} is evaluated for all board positions whereas
{moves} is evaluated only for friendly pieces of the
given type.
)


: {pieces
	0 $pieceCount !
	1 $nextPiece !
	HERE DUP $pieces !
	#Pieces #PieceCells * CELLS ALLOT
;

: {piece}
	$pieceCount ++
	$nextPiece @ CONSTANT $nextPiece ++
	LATEST NFA>CFA $addr,
	0 $addr, ( {moves} )
	0 $addr, ( {drops} )
	1 $addr, ( {value} )
;

: {moves}
	' OVER 3 CELLS - !
;

: {drops}
	' OVER 2 CELLS - !
;

: {value}
	OVER CELLSIZE - !
;

(
 A Zobrist table is created for each piece x player x position combination.
)
: $GeneratePiecePositionHash ( -- )
	HERE $zobrist !

	$pieceCount @ $playerCount @ *
	0
	DO
		$positions @
		0
		DO
			HERE $Rand64!
			2 CELLS ALLOT
		LOOP
	LOOP
;

: $GeneratePlayerToMoveHash ( -- )
	HERE $playerToMoveHash !
	$playerCount @
	0
	DO
		HERE $Rand64!
		2 CELLS ALLOT
	LOOP
;

: $GenerateZobristTables ( -- )
	$zobrist @ 0= ( Don't regenerate when more than one {pieces ... pieces} block occurs. )
	IF
		$GeneratePiecePositionHash
		$GeneratePlayerToMoveHash
	ENDIF
;

: pieces}
	DROP
	$pieceCount @ 0= ABORT" Error: No pieces defined."
	$useAxiomEngine @
	IF
		$GenerateZobristTables
	ENDIF
;

: $PieceToIndex ( piece -- 0BasedIndex )
	#PieceType AND 1-
;

: $PieceToCellOffset ( piece -- cellOffset )
	$PieceToIndex CELLS
;


: piece-value ( piece -- value )
	$PieceToIndex #PieceCells * $pieces @ + [ #PieceCells 1- CELLS ] LITERAL + @
;


(
*********
* board *
*********

The board definition must be equivalent to the Zillions board definition
with respect to position names.  You should specify the initial placement
of the pieces within the .zrf file.  These will automatically be reflected
in the axiom board as long as the proper setup moves are implemented.
)

-1 CONSTANT ??
VARIABLE $anonymous
' ?? CFA>NFA @ $anonymous !

( $anonymous $positions @ $CommaCells )

: {board
	0 $rows !
	0 $columns !
	0 $positions !
	0 $posCount !
	0 $board !
	0 $posNames !

	( Reset non-board related variables - refactor??? )
	0 $moveType !
	1 $priority !
	0 $move-priorities !
	0 $boardSetup !
;

: $CheckBoard ( -- )
	$posNames @ ABORT" Error: Cannot redefine board size."
;

: $UpdateSize ( -- )
	$positions @ CELLS $boardSize !
;

: {grid} ( #rows #cols -- )
	$CheckBoard
	2DUP *
	$positions !
	$columns !
	$rows !
	0 $posCount !
	$UpdateSize
;

: {variable} ( -- )
	<BUILDS
		$boardSize @ DUP ,
		CELLSIZE + $boardSize !
	DOES>
		@ $board @ + \ *native*
;

: {array} ( n -- )
	<BUILDS
		$boardSize @ DUP ,
		SWAP CELLS + $boardSize !
	DOES>
		@ $board @ + SWAP CELLS + \ *native*
;

: {carray} ( n -- )
	<BUILDS
		$boardSize @ DUP ,
		SWAP + $boardSize !
	DOES>
		@ $board @ + + \ *native*
;

( column = a-z, row = 0...N )
: $GenerateGridNames ( -- )
	$rows @ 0
	DO
		$columns @ 0
		DO
			J $columns @ * I + DUP

			OVER $IndexToPosition SWAP HERE C!
			(NUMBER)
			PAD HERE 1+ "MOVE
			HERE PAD "MOVE

			PAD $MakeConstant
			CELLS $posNames @ +
			LATEST @ SWAP !
		LOOP
	LOOP
;

: $DefinePosNames ( -- )
	\ Initialize all grid names with an anonymous name
	HERE
	$anonymous @ $positions @ $CommaCells
	$posNames !

	\ If a grid is defined, generate the grid names
	$rows @
	IF
		$GenerateGridNames
	ENDIF

	\ Generate the position names from the position constants.
	$posCount @ \ Are {position}'s defined?
	IF
		$posNames @ $positions @ CELLS + \ position name addr (posNameAddr)
		$lastPosNFA @ \ Points to the NFA of the last {position} constant.
		$posCount @ 0
		DO
			SWAP CELLSIZE -		\ PosNFA PosNameAddr
			OVER @			\ PosNFA posNameAddr NameAddr
			OVER !			\ PosNFA posNameAddr
			SWAP NFA>LFA @		\ posNameAddr' PosNFA'
		LOOP
		2DROP
	ENDIF
;

( e.g. {position} abc )
: {position} ( -- )
	$positions @ CONSTANT
	LATEST $lastPosNFA !
	$positions ++
	$posCount ++
	$UpdateSize
;

: board}
	$DefinePosNames
	0 , ( end of board linked list )
	HERE $boardSize @ ALLOT	$board !
;

: $CloneBoard ( -- )
	$board @
	DUP , ( link to previous board )
	HERE DUP $board !
	$boardSize @ DUP ALLOT
	CMOVE
;

: $DeallocateBoard ( -- )
	$board @ CELLSIZE - DUP DP ! @ $board ! ( *native* )
;

(
***************
* board setup *
***************
e.g.
{board-setup
	{setup} White stone b2
	{setup} White stone h8
	{setup} Black stone h2
	{setup} Black stone b8
board-setup}

The board is an optional section that is only required if the axiom script
is to be used with alternate, non-Zillions, clients.  The purpose of this
section is to inform clients of the board setup.
)

: {board-setup
	HERE DUP $boardSetup !
	0 , ( count )
;

: {setup}
	' CFA>NFA @ ,
	' CFA>NFA @ ,
	' CFA>NFA @ ,
;

: board-setup}
	HERE OVER - 3 CELLS / SWAP !
;

( Axiom user words )

: from ( -- pos )
	$from @
;

: home ( pos -- )
	$from !
;

: here ( -- pos )
	$pos @
;

: to ( pos -- )
	$pos !
;

: back ( -- )
	$from @ $pos ! ( from to )
;

: last ( -- pos )
	$lastPos @
;

: current-piece ( -- piece )
	$piece @
;

: current-piece-type ( -- pieceType )
	$piece @ #PieceType AND
;

: piece ( -- piece )
	here board[] @
;

: piece-at ( pos -- piece )
	board[] @
;

: piece-type ( -- pieceType )
	piece #PieceType AND
;

: piece-type-at ( pos -- pieceType )
	board[] @ #PieceType AND
;

: not-piece-type? ( pieceType -- ? )
	piece #PieceType AND <>
;

: not-piece-type-at? ( pos pieceType -- ? )
	SWAP board[] @ #PieceType AND <>
;

: current-player ( -- currentPlayer )
	$player @
;

: for-player ( -- forPlayer )
	$forPlayer @
;

: player ( -- player )
	here board[] @ #PlayerNumber AND
;

: player-at ( pos -- player )
	board[] @ #PlayerNumber AND
;

: empty? ( -- ? )
	here piece-at 0=
;

: empty-at? ( pos -- ? )
	piece-at 0=
;

: not-empty? ( -- ? )
	here piece-at 0<>
;

: not-empty-at? ( pos -- ? )
	piece-at 0<>
;

: friend? ( -- ? )
	player current-player OnFriends?
;

: enemy? ( -- ? )
	friend? NOT not-empty? AND
;

: friend-at? ( pos -- ? )
	player-at current-player OnFriends?
;

: enemy-at? ( pos -- ? )
	DUP friend-at? NOT SWAP not-empty-at? AND
;

: friend-of? ( pos player -- ? )
	SWAP player-at OnFriends?
;

: enemy-of? ( pos player -- ? )
	OVER SWAP friend-of? NOT SWAP not-empty-at? AND
;

: neutral-piece? ( -- ? )
	here board[] @ #Neutral AND 0<>
;

: neutral-piece-at? ( pos -- ? )
	board[] @ #Neutral AND 0<>
;

: verify ( ? -- )
	NOT IF $Exit ENDIF
;

: move-count ( -- count )
	$movesList @ CELLSIZE + @ ( # of moves generated )
;

: turn-number ( -- number )
	$turnNumber @
;

( Stalemate if the current player has no moves.  Used within OnEvaluate. )
: stalemate? ( -- ? )
	move-count 0=
;

( Partial moves )

: $DoPartial ( -- )
	$partial ON
;

: partial ( -- )
	COMPILE $DoPartial
	^" partial" 0 ^number
;

: $DoPartialMoveType ( move-type -- )
	$ofType !
	$partial ON
;

: partial-move-type ( move-type -- )
	DUP
	COMPILE-LITERAL
	COMPILE $DoPartialMoveType
	^" partial" ^number
;

( Pass moves. )

: $Pass ^" Pass" add-move $passed ON ;

: Pass $passed @ NOT IF $Pass ENDIF ;

: PassNoPartial $passed @ $partial @ OR NOT IF $Pass ENDIF ;

( These words are invoked to apply a board edit )

: $RemovePiece ( position -- )
	$useAxiomEngine @
	IF
		$RemovePieceZ
	ELSE
		$RemovePieceU
	ENDIF
;
	
: $AddPiece ( piece position -- )
	$useAxiomEngine @
	IF
		$AddPieceZ
	ELSE
		$AddPieceU
	ENDIF
;

\ Board edit events.

: OnEditRemove ( position -- )
	$RemovePiece
;

: OnEditAdd ( player pieceType position -- )
	>R OR R>
	DUP not-empty-at?
	IF
		DUP $RemovePiece
	ENDIF
	$AddPiece
;

( Support for piece reserves )

VARIABLE _amount-in-reserve
( Removes 1 piece from the reserve )
: remove-from-reserve, _amount-in-reserve @ EXECUTE -- ;

( Used within a move to remove a piece from the reserve )
: remove-from-reserve
	COMPILE remove-from-reserve, ;

( Debugging support. )

( Output the current move list. )
: $OutputMoves ( -- )
	$FirstMove
	BEGIN
		DUP
	WHILE
		ASCII [ EMIT
		DUP CELLSIZE + @ TYPE
		ASCII ] EMIT CR
		$NextMove
	REPEAT
	DROP
;

(
****************
* Ring buffer. *
****************
{most of this has been moved to axiom.dll}
)

: ringbuffer-dump CR BEGIN ringbuffer-remove-item . ringbuffer-empty? UNTIL ; 

(
*************************
* Axiom internal events *
*************************
)

: $NewGame ( -- )
	$board @ $boardSize @ ERASE
	0 $SetTurn
	$partial OFF
;

(
*************************************************
* Axiom events - default implementations below. *
* Game developers can override these.           *
*************************************************
)

: OnNewGame ( -- )
;

: OnGenerateMoves ( -- )
;

: OnIsTerminal? ( -- ? )
	TRUE
;

: OnRetractMove ( -- )
	$DeallocateBoard
;

( 
  OnIsGameOver is always called from the perspective of the
  player who is about to make the next move.  axiom ensures
  that the current $movesList is correct for that player.
)

( The default implementation checks for stalemate. )
: OnIsGameOver ( -- gameResult )
	#UnknownScore
	stalemate?
	IF
		DROP #DrawScore
	ENDIF
;

( Called when Zillions tells axiom to make a move. )
: OnMakeAMove
;

( Called to evaluate the game state. )
( The default implementation simply returns a constant. )
: OnEvaluate ( -- score )
	0
;

: OnIsTerminal? TRUE ;

(
**********************************
* Axiom END - User game follows. *
**********************************
)

( The user's game is loaded here.  When selecting a new game, everthing beyond this point is deleted. )
: axiomFence ;