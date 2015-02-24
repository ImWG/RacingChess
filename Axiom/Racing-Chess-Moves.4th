VARIABLE $Top?
VARIABLE $Direction
VARIABLE $Direction2
VARIABLE $BeforeLine

: $Direction!  $Direction ! ;
: $Direction@  $Direction @ ;
: $Direction2!  $Direction2 ! ;
: $Direction2@  $Direction2 @ ;

\ judge if here is the top line
: Top? ( - bool )
	$Top? OFF

	rank38? IF
		$Top? ON
	ELSE
		rank38* IF
			rank37? IF
				$Top? ON
			ELSE
				rank37* IF
					rank36? IF
						$Top? ON
					ELSE
						rank36* IF
							rank35? IF
								$Top? ON
							ELSE
								rank35* IF
									rank34? IF
										$Top? ON
									ELSE
										rank34* IF
											rank33? IF
												$Top? ON
											ELSE
												rank33* IF
													rank32? IF
														$Top? ON
													ELSE
														rank32* IF
															rank31? IF
																$Top? ON
															ELSE	
	rank31* IF
		rank30? IF
			$Top? ON
		ELSE
			rank30* IF
				rank29? IF
					$Top? ON
				ELSE
					rank29* IF
						rank28? IF
							$Top? ON
						ELSE
							rank28* IF
								rank27? IF
									$Top? ON
								ELSE
									rank27* IF
										rank26? IF
											$Top? ON
										ELSE
											rank26* IF
												rank25? IF
													$Top? ON
												ELSE	
	rank25* IF
		rank24? IF
			$Top? ON
		ELSE
			rank24* IF
				rank23? IF
					$Top? ON
				ELSE
					rank23* IF
						rank22? IF
							$Top? ON
						ELSE
							rank22* IF
								rank21? IF
									$Top? ON
								ELSE
									rank21* IF
										rank20? IF
											$Top? ON
										ELSE
											rank20* IF
												rank19? IF
													$Top? ON
												ELSE	
	rank19* IF
		rank18? IF
			$Top? ON
		ELSE
			rank18* IF
				rank17? IF
					$Top? ON
				ELSE
					rank17* IF
						rank16? IF
							$Top? ON
						ELSE
							rank16* IF
								rank15? IF
									$Top? ON
								ELSE
									rank15* IF
										rank14? IF
											$Top? ON
										ELSE
											rank14* IF
												rank13? IF
													$Top? ON
												ELSE
	rank13* IF
		rank12? IF
			$Top? ON
		ELSE
			rank12* IF
				rank11? IF
					$Top? ON
				ELSE
					rank11* IF
						rank10? IF
							$Top? ON
						ELSE
							rank10* IF
								rank9? IF
									$Top? ON
								ELSE
									rank9* IF
										rank8? IF
											$Top? ON
										ELSE
											rank8* IF
												rank7? IF
													$Top? ON
												ELSE
	rank7* IF
		rank6? IF
			$Top? ON
		ELSE
			rank6* IF
				rank5? IF
					$Top? ON
				ELSE
					rank5* IF
						rank4? IF
							$Top? ON
						ELSE
							rank4* IF
								rank3? IF
									$Top? ON
								ELSE
									rank3* IF
										rank2? IF
											$Top? ON
										ELSE
											rank2* IF
												rank1? IF
													$Top? ON
												ENDIF
											ENDIF
										ENDIF
									ENDIF
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
												ENDIF
											ENDIF
										ENDIF
									ENDIF
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
												ENDIF
											ENDIF
										ENDIF
									ENDIF
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
												ENDIF
											ENDIF
										ENDIF
									ENDIF
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
												ENDIF
											ENDIF
										ENDIF
									ENDIF
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
															ENDIF
														ENDIF
													ENDIF
												ENDIF
											ENDIF
										ENDIF
									ENDIF
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF

		
	$Top? @
;


: Empty? ( - )
	empty? piece-type 9 >= OR
;

: on-board? ( - )
	here offboard <>
;

: canmove-start? ( - )
	on-board? Empty? AND
;
: canmove? ( - )
	canmove-start?
	enemy? piece-type 4 <= AND OR
;

: BeforeLine* ( - )
	beforeline? $BeforeLine !
;
: Finish ( - )
	9 \ Top1's Num
	NumOfFinished @ +
	DUP 17 > IF
		DROP 17
	ENDIF
	change-type
	capture
	
	\ create in rank list
(	xa1 NumOfFinished @ CELLS +
	DUP DUP
	xa1 >= SWAP xb4 <= AND IF
		create-at
	ELSE
		DROP
	ENDIF
)	
	current-player Red = IF
		COMPILE ScoreRed+
	ELSE
		COMPILE ScoreBlue+
	ENDIF
	COMPILE NumOfFinished++
;

: move! ( - )
	canmove? IF
		from here move
		$BeforeLine @ IF
			afterline? IF
				Finish
			ELSE
				#NumOfPieces NumOfFinished @ - 1 = IF
					COMPILE NumOfFinished++
				ENDIF
			ENDIF
		ENDIF
		add-move
	ENDIF
;
: move-start! ( started-piece-type - )
	canmove-start? IF
		from here move
		rank37? rank38? OR NOT IF
			change-type
		ELSE
			DROP
		ENDIF
		add-move
	ENDIF
;

\ move ONE step FORWARD, the only move required for the most fore pieces
: Advance ( - )
	field1? IF
		East
	ELSE
		field2? IF
			North
		ELSE
			field3? IF
				West
			ELSE
				South
			ENDIF
		ENDIF
	ENDIF
	move!
;

( - )
: move-start-rook!    @Rook 	move-start! ;
: move-start-bishop!  @Bishop 	move-start! ;
: move-start-knight!  @Knight 	move-start! ;
: move-start-queen!   @Queen 	move-start! ;

: oRook-step
	$Direction@ EXECUTE move-start-rook!
	Empty? IF
		$Direction@ EXECUTE move-start-rook!
		Empty? IF
			$Direction@ EXECUTE move-start-rook!
		ENDIF
	ENDIF
;

: oRook-move
	['] North $Direction!
	oRook-step back
	['] South $Direction! 
	oRook-step back
	\ ['] West $Direction! 
	\ oRook-step back
	['] East $Direction! 
	oRook-step
;

: Rook-step
	$Direction@ EXECUTE move!
	Empty? IF
		$Direction@ EXECUTE move!
		Empty? IF
			$Direction@ EXECUTE move!
		ENDIF
	ENDIF
;
: Rook-move
	BeforeLine*
	Top? IF
		Advance
	ELSE
		field4? NOT IF
			['] North $Direction!
			Rook-step back
		ENDIF
		field2? NOT IF
			['] South $Direction! 
			Rook-step back
		ENDIF
		field1? NOT IF
			['] West $Direction! 
			Rook-step back
		ENDIF
		field3? NOT IF
			['] East $Direction! 
			Rook-step
		ENDIF
	ENDIF
;

: oBishop-step
	$Direction@ EXECUTE $Direction2@ EXECUTE move-start-bishop!
	Empty? IF
		$Direction@ EXECUTE $Direction2@ EXECUTE move-start-bishop!
		Empty? IF
			$Direction@ EXECUTE $Direction2@ EXECUTE move-start-bishop!
			Empty? IF
				$Direction@ EXECUTE $Direction2@ EXECUTE move-start-bishop!
			ENDIF
		ENDIF
	ENDIF
;
: oBishop-move
	['] East $Direction!
	['] North $Direction2!
	oBishop-step back
	['] South $Direction2!
	oBishop-step back
	
	['] North $Direction!
	['] East $Direction2!
	oBishop-step back
	['] South $Direction!
	oBishop-step
;

: Bishop-step
	$Direction@ EXECUTE $Direction2@ EXECUTE move!
	Empty? IF
		$Direction@ EXECUTE $Direction2@ EXECUTE move!
		Empty? IF
			$Direction@ EXECUTE $Direction2@ EXECUTE move!
			Empty? IF
				$Direction@ EXECUTE $Direction2@ EXECUTE move!
			ENDIF
		ENDIF
	ENDIF
;
: Bishop-move
	BeforeLine*
	Top? IF
		Advance
	ELSE
	
		['] East $Direction!
		field3? field4? OR NOT IF \ NE
			['] North $Direction2!
			Bishop-step back
		ENDIF
		field2? field3? OR NOT IF \ SE
			['] South $Direction2!
			Bishop-step back
		ENDIF
		
		['] North $Direction!
		field3? field4? OR NOT IF \ NE
			['] East $Direction2!
			Bishop-step back
		ENDIF
		field1? field4? OR NOT IF \ NW
			['] West $Direction2!
			Bishop-step back
		ENDIF
		
		['] West $Direction!
		field1? field4? OR NOT IF \ NW
			['] North $Direction2!
			Bishop-step back
		ENDIF
		field1? field2? OR NOT IF \ SW
			['] South $Direction2!
			Bishop-step back
		ENDIF
		
		['] South $Direction!
		field2? field3? OR NOT IF \ SE
			['] East $Direction2!
			Bishop-step back
		ENDIF
		field1? field2? OR NOT IF \ SW
			['] West $Direction2!
			Bishop-step
		ENDIF
		
	ENDIF
;

: oKnight-step
	$Direction@ EXECUTE 
	$Direction@ EXECUTE 
	$Direction2@ EXECUTE 
		move-start-knight!
	back
	$Direction2@ EXECUTE 
	$Direction@ EXECUTE 
	$Direction@ EXECUTE 
		move-start-knight!
;
: oKnight-move
	['] North $Direction!
	\ NNE
	['] East $Direction2!
	oKnight-step back
	
	['] South $Direction!
	\ SSE
	oKnight-step back
		
	['] East $Direction!
	\ NEE
	['] North $Direction2!
	oKnight-step back
	
	\ SEE
	['] South $Direction2!
	oKnight-step back
;

: Knight-step
	$Direction@ EXECUTE 
	$Direction@ EXECUTE 
	$Direction2@ EXECUTE 
		move!
	back
	$Direction2@ EXECUTE 
	$Direction@ EXECUTE 
	$Direction@ EXECUTE
		move!	
;
: Knight-move
	BeforeLine*
	Top? IF
		Advance
	ELSE
		['] North $Direction!
		field3? field4? OR NOT IF \ NNE
			['] East $Direction2!
			Knight-step back
		ENDIF
		field1? field4? OR NOT IF \ NNW
			['] West $Direction2!
			Knight-step back
		ENDIF
		
		['] South $Direction!
		field1? field2? OR NOT IF \ SSW
			['] West $Direction2!
			Knight-step back
		ENDIF
		field2? field3? OR NOT IF \ SSE
			['] East $Direction2!
			Knight-step back
		ENDIF
		
		['] East $Direction!
		field3? field4? OR NOT IF \ NEE
			['] North $Direction2!
			Knight-step back
		ENDIF
		field2? field3? OR NOT IF \ SEE
			['] South $Direction2!
			Knight-step back
		ENDIF
		
		['] West $Direction!
		field1? field2? OR NOT IF \ SWW
			['] South $Direction2!
			Knight-step back
		ENDIF
		field1? field4? OR NOT IF \ NWW
			['] North $Direction2!
			Knight-step back
		ENDIF
		
	ENDIF
;

: oQueen-step
	$Direction@ EXECUTE move-start-queen!
	Empty? IF
		$Direction@ EXECUTE move-start-queen!
	ENDIF
	back
	$Direction@ EXECUTE $Direction2@ EXECUTE move-start-queen!
	Empty? IF
		$Direction@ EXECUTE $Direction2@ EXECUTE move-start-queen!
	ENDIF
;
: oQueen-move
	['] East $Direction!
	\ NE
	['] North $Direction2!
	oQueen-step back
	\ SE
	['] South $Direction2!
	oQueen-step back
	
	['] East $Direction2!
	\ NE
	['] North $Direction!
	oQueen-step back
	\ SE
	['] South $Direction!
	oQueen-step back
;

: Queen-step
	$Direction@ EXECUTE move!
	Empty? IF
		$Direction@ EXECUTE move!
	ENDIF
	back
	$Direction@ EXECUTE $Direction2@ EXECUTE move!
	Empty? IF
		$Direction@ EXECUTE $Direction2@ EXECUTE move!
	ENDIF
;
: Queen-move
	BeforeLine*
	Top? IF
		Advance
	ELSE
	
		['] East $Direction!
		field3? field4? OR NOT IF \ NE
			['] North $Direction2!
			Queen-step back
		ENDIF
		field2? field3? OR NOT IF \ SE
			['] South $Direction2!
			Queen-step back
		ENDIF
		
		['] North $Direction!
		field3? field4? OR NOT IF \ NE
			['] East $Direction2!
			Queen-step back
		ENDIF
		field1? field4? OR NOT IF \ NW
			['] West $Direction2!
			Queen-step back
		ENDIF
		
		['] West $Direction!
		field1? field4? OR NOT IF \ NW
			['] North $Direction2!
			Queen-step back
		ENDIF
		field1? field2? OR NOT IF \ SW
			['] South $Direction2!
			Queen-step back
		ENDIF
		
		['] South $Direction!
		field2? field3? OR NOT IF \ SE
			['] East $Direction2!
			Queen-step back
		ENDIF
		field1? field2? OR NOT IF \ SW
			['] West $Direction2!
			Queen-step
		ENDIF
		
	ENDIF
;

\ check if there is the certain kind of pieces residue
( - )
: CheckRedRook
	RedRook @ 0= IF
		FALSE
	ELSE
		COMPILE RedRook--
		TRUE
	ENDIF
;
: CheckRedKnight
	RedKnight @ 0= IF
		FALSE
	ELSE
		COMPILE RedKnight--
		TRUE
	ENDIF
;
: CheckRedBishop
	RedBishop @ 0= IF
		FALSE
	ELSE
		COMPILE RedBishop--
		TRUE
	ENDIF
;
: CheckRedQueen
	RedQueen @ 0= IF
		FALSE
	ELSE
		COMPILE RedQueen--
		TRUE
	ENDIF
;

: CheckBlueRook
	BlueRook @ 0= IF
		FALSE
	ELSE
		COMPILE BlueRook--
		TRUE
	ENDIF
;
: CheckBlueKnight
	BlueKnight @ 0= IF
		FALSE
	ELSE
		COMPILE BlueKnight--
		TRUE
	ENDIF
;
: CheckBlueBishop
	BlueBishop @ 0= IF
		FALSE
	ELSE
		COMPILE BlueBishop--
		TRUE
	ENDIF
;
: CheckBlueQueen
	BlueQueen @ 0= IF
		FALSE
	ELSE
		COMPILE BlueQueen--
		TRUE
	ENDIF
;

: CheckRook
	current-player Red = IF
		CheckRedRook
	ELSE
		CheckBlueRook
	ENDIF
;
: CheckKnight
	current-player Red = IF
		CheckRedKnight
	ELSE
		CheckBlueKnight
	ENDIF
;
: CheckBishop
	current-player Red = IF
		CheckRedBishop
	ELSE
		CheckBlueBishop
	ENDIF
;
: CheckQueen
	current-player Red = IF
		CheckRedQueen
	ELSE
		CheckBlueQueen
	ENDIF
;

: drop! ( - )
	in-drop-zone? IF
		empty? IF
			drop add-move
		ENDIF
	ENDIF
;

: DropRook
	CheckRook IF
		drop!
	ENDIF
;
: DropKnight
	CheckKnight IF
		drop!
	ENDIF
;
: DropBishop
	CheckBishop IF
		drop!
	ENDIF
;
: DropQueen
	CheckQueen IF
		drop!
	ENDIF
;

: Convert-step ( piece bool - )
	IF
		create-piece-type
		add-move
	ELSE
		DROP
	ENDIF
;

: Convert-move
	@Rook CheckRook Convert-step
	@Knight CheckKnight Convert-step
	@Bishop CheckBishop Convert-step
	@Queen CheckQueen Convert-step
;
: oConv-move
	@oRook CheckRook Convert-step
	@oKnight CheckKnight Convert-step
	@oBishop CheckBishop Convert-step
	@oQueen CheckQueen Convert-step
;




{moves oRook-moves
	{move} oRook-move	{move-type} normal-move
	{move} oConv-move	{move-type} normal-move
moves}
{moves Rook-moves
	{move} Rook-move	{move-type} normal-move
	{move} Convert-move	{move-type} normal-move
moves}
{moves oBishop-moves
	{move} oBishop-move	{move-type} normal-move
	{move} oConv-move	{move-type} normal-move
moves}
{moves Bishop-moves
	{move} Bishop-move	{move-type} normal-move
	{move} Convert-move	{move-type} normal-move
moves}
{moves oKnight-moves
	{move} oKnight-move	{move-type} normal-move
	{move} oConv-move	{move-type} normal-move
moves}
{moves Knight-moves
	{move} Knight-move	{move-type} normal-move
	{move} Convert-move	{move-type} normal-move
moves}
{moves oQueen-moves
	{move} oQueen-move	{move-type} normal-move
	{move} oConv-move	{move-type} normal-move
moves}
{moves Queen-moves
	{move} Queen-move	{move-type} normal-move
	{move} Convert-move	{move-type} normal-move
moves}

{moves oRook-drops
	{move} DropRook		{move-type} drop-move
moves}
{moves oBishop-drops
	{move} DropBishop	{move-type} drop-move
moves}
{moves oKnight-drops
	{move} DropKnight	{move-type} drop-move
moves}
{moves oQueen-drops
	{move} DropQueen	{move-type} drop-move
moves}