Extension { #name : #Integer }

{ #category : #'*spycore' }
Integer >> setOfDivBy2 [
	"
	342432 setOfDivBy2
	"
	| answer b |
	answer := OrderedCollection new.
	 
	
	b := [ :n | (n = 1) ifFalse: [ answer add: n. b value: (n / 2) asInteger ] ].
	b value: self.
	answer add: 1.
	^ answer
]
