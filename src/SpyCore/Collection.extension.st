Extension { #name : #Collection }

{ #category : #'*spycore' }
Collection >> amountOfElementsToReach80OfTheSum [
	"Return the number of elements for which the sum reach 80 of the total sum"
	
	"
	#(1 2 3 4 10) amountOfElementsToReach80OfTheSum = 3 
	#(1 2 3 4 1000) amountOfElementsToReach80OfTheSum = 1
	#(1 2 3 4 500 1000) amountOfElementsToReach80OfTheSum = 2 
	"
	
	
	| nbElements c sum sum80 tt |
	nbElements := 0.
	c := self asSortedCollection reverse.
	sum := self sum.
	sum80 := (sum * 0.8) asInteger.
	tt := 0.
	c do: [ :i | 
		tt := tt + i.
		nbElements := nbElements + 1.
		(tt >= sum80) ifTrue: [ ^ nbElements ] ].
	^ 0
]

{ #category : #'*spycore' }
Collection >> asLinedText [

	| str |
	str := WriteStream on: String new.
	self do: [ :v | str nextPutAll: v printString; cr ].
	Workspace openContents: str contents 
]

{ #category : #'*spycore' }
Collection >> coefficient: yValues [
	"receiver is a collection x values"
	
	^ (self ssXY: yValues) / self ssXX
]

{ #category : #'*spycore' }
Collection >> commated [
	"return a string with a comma between each value"

	| str |
	str := WriteStream on: String new.
	self do: [:v | str nextPutAll: (v printString) ] separatedBy: [ str nextPut: $, ].
	^ str contents
]

{ #category : #'*spycore' }
Collection >> frequencyTable [

	| answer |
	answer := Dictionary new.
	self asSet do: [ :v | answer at: v put: 0 ].
	self do: [:v | answer at: v put: (answer at: v) + 1 ].
	^ answer
]

{ #category : #'*spycore' }
Collection >> percentageOfElementsToReach80OfTheSum [
	"Return the % of elements for which the sum reach 80 of the total sum"
	
	"
	#(1 2 3 4 10) percentageOfElementsToReach80OfTheSum = 60 
	#(1 2 3 4 1000) percentageOfElementsToReach80OfTheSum = 20 
	#(1 2 3 4 500 1000) percentageOfElementsToReach80OfTheSum = 33.3 
	"

	^ (self amountOfElementsToReach80OfTheSum * 100 / self size) asFloat
]

{ #category : #'*spycore' }
Collection >> squeeze [
	"Reduce the size by two by removing one of two elements. "

	"
	#(1 2 3 4 5 6 7 8 9 10) squeeze
	"

	| answer |
	answer := OrderedCollection new: self size / 2.
	1 to: self size do: [ :i |
		(i \\ 2) = 1 ifTrue: [ answer add: (self at: i) ].
	].
	^ answer
]

{ #category : #'*spycore' }
Collection >> ssXX [
	"Return the sum of square. Works only on a collection of numbers"

	"
	{ 0 .
	   2.39789527279837 .
	   3.04452243772342 } ssXX
	=>   5.145715101176377
	"
	^ self squared sum - (self sum squared / self size)
]

{ #category : #'*spycore' }
Collection >> ssXY [
	"Return the sum of square. Works only on a collection of points"

	"
	{ 0 @ 0.24 . 
	   2.39789527279837 @ 0.57 .
	   3.04452243772342 @ 0.6} ssXY
	=>  0.6355774441838813	
	"
	^ (self collect: [ :p | p x * p y ]) sum - ((self collect: #x) sum * (self collect: #y) sum/ self size)
]

{ #category : #'*spycore' }
Collection >> ssXY: yValues [
	"Return the sum of square. Works only on a collection of numbers"

	"
	{ 0 . 2.39789527279837 . 3.04452243772342 } ssXY: {0.24 . 0.57 . 0.6 }
	=>  0.6355774441838813	
	"
	^ (self with: yValues collect: [ :x :y | x * y ]) sum - (self sum * yValues sum/ self size)
]

{ #category : #'*spycore' }
Collection >> standardDeviation [	
	"Returns the Standard Deviation, as calculated by Octave and SpreadSheets:	 the square root of the bias-corrected variance.	http://mathworld.wolfram.com/StandardDeviation.html"	
	|mean|	
	mean:= self average.	
	^ ((self sum:[:each | (each - mean) squared]) / (self size - 1)) sqrt.
]

{ #category : #'*spycore' }
Collection >> toNumbers [
	| str |
	str := WriteStream on: String new.
	self do: [:v | str nextPutAll: v printString; cr ].
	^ Workspace openContents: str contents
]

{ #category : #'*spycore' }
Collection >> valueAtZeroFor: yValues [
	"receiver is a collection x values"
	
	^ yValues average - ((self coefficient: yValues) * self average)
]
