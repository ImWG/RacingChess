{board
	11 16 {grid}
	
	{variable} ScoreRed
	{variable} ScoreBlue
	{variable} NumOfFinished
	
	{variable} RedRook
	{variable} RedKnight
	{variable} RedBishop
	{variable} RedQueen
	
	{variable} BlueRook
	{variable} BlueKnight
	{variable} BlueBishop
	{variable} BlueQueen
	
	{position} offboard
	
	{position} xa1
	{position} xa2
	{position} xa3
	{position} xa4
	{position} xb1
	{position} xb2
	{position} xb3
	{position} xb4
board}

{directions
	 1  0 {direction} North
	-1  0 {direction} South
	 0  1 {direction} East
	 0 -1 {direction} West
	
	{link} North a3 offboard    {link} South a9 offboard
	{link} North b2 offboard    {link} South b10 offboard
	{link} North c1 offboard    {link} South c11 offboard
	{link} North d1 offboard    {link} South d11 offboard
	{link} North e1 offboard    {link} South e11 offboard
	{link} North f1 offboard    {link} South f11 offboard
	{link} North g1 offboard    {link} South g11 offboard
	{link} North h1 offboard    {link} South h11 offboard
	{link} North i1 offboard    {link} South i11 offboard
	{link} North j1 offboard    {link} South j11 offboard
	{link} North k1 offboard    {link} South k11 offboard
	{link} North l1 offboard    {link} South l11 offboard
	{link} North m1 offboard    {link} South m11 offboard
	{link} North n1 offboard    {link} South n11 offboard
	{link} North o2 offboard    {link} South o10 offboard
	{link} North p3 offboard    {link} South p9 offboard
	
	{link} North e8 offboard    {link} South e4 offboard
	{link} North f8 offboard    {link} South f4 offboard
	{link} North g8 offboard    {link} South g4 offboard
	{link} North h8 offboard    {link} South h4 offboard
	{link} North i8 offboard    {link} South i4 offboard
	{link} North j8 offboard    {link} South j4 offboard
	{link} North k8 offboard    {link} South k4 offboard
	{link} North l8 offboard    {link} South l4 offboard
	
	{link} West c1 offboard    {link} East n1 offboard
	{link} West b2 offboard    {link} East o2 offboard
	{link} West a3 offboard    {link} East p3 offboard
	{link} West a4 offboard    {link} East p4 offboard
	{link} West a5 offboard    {link} East p5 offboard
	{link} West a6 offboard    {link} East p6 offboard
	{link} West a7 offboard    {link} East p7 offboard
	{link} West a8 offboard    {link} East p8 offboard
	{link} West a9 offboard    {link} East p9 offboard
	{link} West b10 offboard    {link} East o10 offboard
	{link} West c11 offboard    {link} East n11 offboard
	
	{link} East d5 offboard    {link} West m5 offboard
	{link} East d6 offboard    {link} West m6 offboard
	{link} East d7 offboard    {link} West m7 offboard
	
directions}

: rank? ( p1 p2 p3 p4 - bool )
	here = SWAP
	here = OR SWAP
	here = OR SWAP
	here = OR
;

: rank1?	i8 i9 i10 i11 rank? ;
: rank2?	j8 j9 j10 j11 rank? ;
: rank3?	k8 k9 k10 k11 rank? ;
: rank4?	l8 l9 l10 l11 rank? ;

: rank5?	m11 n11 o11 p11 rank? ;
: rank6?	m10 n10 o10 p10 rank? ;
: rank7?	m9 n9 o9 p9 rank? ;
: rank8?	m8 n8 o8 p8 rank? ;
: rank9?	m7 n7 o7 p7 rank? ;
: rank10?	m6 n6 o6 p6 rank? ;
: rank11?	m5 n5 o5 p5 rank? ;

: rank12?	p1 p2 p3 p4 rank? ;
: rank13?	o1 o2 o3 o4 rank? ;
: rank14?	n1 n2 n3 n4 rank? ;
: rank15?	m1 m2 m3 m4 rank? ;
: rank16?	l1 l2 l3 l4 rank? ;
: rank17?	k1 k2 k3 k4 rank? ;
: rank18?	j1 j2 j3 j4 rank? ;
: rank19?	i1 i2 i3 i4 rank? ;
: rank20?	h1 h2 h3 h4 rank? ;
: rank21?	g1 g2 g3 g4 rank? ;
: rank22?	f1 f2 f3 f4 rank? ;
: rank23?	e1 e2 e3 e4 rank? ;

: rank24?	a1 b1 c1 d1 rank? ;
: rank25?	a2 b2 c2 d2 rank? ;
: rank26?	a3 b3 c3 d3 rank? ;
: rank27?	a4 b4 c4 d4 rank? ;
: rank28?	a5 b5 c5 d5 rank? ;
: rank29?	a6 b6 c6 d6 rank? ;
: rank30?	a7 b7 c7 d7 rank? ;

: rank31?	a8 a9 a10 a11 rank? ;
: rank32?	b8 b9 b10 b11 rank? ;
: rank33?	c8 c9 c10 c11 rank? ;
: rank34?	d8 d9 d10 d11 rank? ;
: rank35?	e8 e9 e10 e11 rank? ;
: rank36?	f8 f9 f10 f11 rank? ;
: rank37?	g8 g9 g10 g11 rank? ;
: rank38?	h8 h9 h10 h11 rank? ;

: in-drop-zone?
	rank37? rank38? OR
;

: beforeline?
	rank35? rank36? OR rank37? OR rank38? OR
;
: afterline?
	rank1?  rank2?  OR rank3?  OR rank4?  OR
;

: field1?
	rank1?     rank2?  OR rank3?  OR rank4?  OR
	rank31? OR rank32? OR rank33? OR rank34? OR
	rank35? OR rank36? OR rank37? OR rank38? OR
;
: field2?
	rank5?    rank6?  OR rank7?  OR rank8? OR
	rank9? OR rank10? OR rank11? OR
;
: field3?
	rank12?    rank13? OR rank14? OR rank15? OR
	rank16? OR rank17? OR rank18? OR rank19? OR
	rank20? OR rank21? OR rank22? OR rank23? OR
;
: field4?
	rank24?    rank25? OR rank26? OR rank27? OR
	rank28? OR rank29? OR rank30? OR
;

: nofartherpiece?
	piece-type-at DUP 4 <= SWAP 9 >= OR
;

: rank* ( p1 p2 p3 p4 - bool )
	nofartherpiece? SWAP		( p2 bool p3 p4 )
	nofartherpiece? AND SWAP	( bool p2 p3 p4 )
	nofartherpiece? AND SWAP
	nofartherpiece? AND
;

: rank1*	i8 i9 i10 i11 rank* ;
: rank2*	j8 j9 j10 j11 rank* ;
: rank3*	k8 k9 k10 k11 rank* ;
: rank4*	l8 l9 l10 l11 rank* ;

: rank5*	m11 n11 o11 p11 rank* ;
: rank6*	m10 n10 o10 p10 rank* ;
: rank7*	m9 n9 o9 p9 rank* ;
: rank8*	m8 n8 o8 p8 rank* ;
: rank9*	m7 n7 o7 p7 rank* ;
: rank10*	m6 n6 o6 p6 rank* ;
: rank11*	m5 n5 o5 p5 rank* ;

: rank12*	p1 p2 p3 p4 rank* ;
: rank13*	o1 o2 o3 o4 rank* ;
: rank14*	n1 n2 n3 n4 rank* ;
: rank15*	m1 m2 m3 m4 rank* ;
: rank16*	l1 l2 l3 l4 rank* ;
: rank17*	k1 k2 k3 k4 rank* ;
: rank18*	j1 j2 j3 j4 rank* ;
: rank19*	i1 i2 i3 i4 rank* ;
: rank20*	h1 h2 h3 h4 rank* ;
: rank21*	g1 g2 g3 g4 rank* ;
: rank22*	f1 f2 f3 f4 rank* ;
: rank23*	e1 e2 e3 e4 rank* ;

: rank24*	a1 b1 c1 d1 rank* ;
: rank25*	a2 b2 c2 d2 rank* ;
: rank26*	a3 b3 c3 d3 rank* ;
: rank27*	a4 b4 c4 d4 rank* ;
: rank28*	a5 b5 c5 d5 rank* ;
: rank29*	a6 b6 c6 d6 rank* ;
: rank30*	a7 b7 c7 d7 rank* ;

: rank31*	a8 a9 a10 a11 rank* ;
: rank32*	b8 b9 b10 b11 rank* ;
: rank33*	c8 c9 c10 c11 rank* ;
: rank34*	d8 d9 d10 d11 rank* ;
: rank35*	e8 e9 e10 e11 rank* ;
: rank36*	f8 f9 f10 f11 rank* ;
: rank37*	g8 g9 g10 g11 rank* ;
: rank38*	h8 h9 h10 h11 rank* ;


: NumOfFinished++
	NumOfFinished ++
;

: ScoreGet
	#TopScores NumOfFinished @ CELLS + @
;

: ScoreRed+
	ScoreGet ScoreRed +!
;
: ScoreBlue+
	ScoreGet ScoreBlue +!
;

: RedRook--		RedRook -- ;
: RedKnight--	RedKnight -- ;
: RedBishop--	RedBishop -- ;
: RedQueen--	RedQueen -- ;
	
: BlueRook--	BlueRook -- ;
: BlueKnight--	BlueKnight -- ;
: BlueBishop--	BlueBishop -- ;
: BlueQueen--	BlueQueen -- ;