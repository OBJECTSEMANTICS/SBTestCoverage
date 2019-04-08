Class {
	#name : #SBMethod,
	#superclass : #S2Method,
	#instVars : [
		'blocks'
	],
	#category : #'SBTestCoverage-Core'
}

{ #category : #accessing }
SBMethod >> blocks [
	^ blocks
]

{ #category : #enumerating }
SBMethod >> count: aNumber [
	blocks detect:[:block| block id = aNumber] ifFound:[ :block | 
		self updateStateFirstBlock.
		block executed]
]

{ #category : #initialization }
SBMethod >> initialize [ 	
	super initialize.
	blocks := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
SBMethod >> installGhosts [
	| rbMethodNode newMethod aClass |
	"self selector = #pic ifTrue: [ self halt ]."
	self originalMethod sourceCode size > 20000 
	ifTrue: [ self uninstall ]
	ifFalse: [[ 
	rbMethodNode := RBParser
		parseMethod: self originalMethod sourceCode.
	blocks := SBInstrumentor new
		visitNode: rbMethodNode;
		blocks.
	aClass := self originalMethod methodClass.
	newMethod := aClass compile: rbMethodNode printString notifying: nil.
	aClass >> newMethod replaceLiterals: {(#metaObject -> self)} ]
		on: Error
		do: [ :e | self uninstall ]]
]

{ #category : #'public - metrics' }
SBMethod >> numberOfAllStatements [
	^ self blocks inject:0 into:[:sum :block| sum + block numberOfStatements].
	
]

{ #category : #'public - metrics' }
SBMethod >> numberOfExecutedStatements [
	^ (self blocks select: #wasExecuted)
		inject: 0
		into: [ :sum :block | sum + block numberOfStatements ]
]

{ #category : #installing }
SBMethod >> uninstall [
	self originalMethod methodClass methodDict at: self selector put: self originalMethod
]

{ #category : #'as yet unclassified' }
SBMethod >> updateStateFirstBlock [
	blocks ifNotEmpty: [ blocks first executed. ]
]
