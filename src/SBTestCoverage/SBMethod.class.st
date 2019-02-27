Class {
	#name : #SBMethod,
	#superclass : #S2Method,
	#instVars : [
		'blocks',
		'executed'
	],
	#category : #'SBTestCoverage-Core'
}

{ #category : #accessing }
SBMethod >> blocks [
	^ blocks
]

{ #category : #enumerating }
SBMethod >> count: aNumber [
	self halt.
	blocks detect:[:block| block id = aNumber] ifFound:[ :block | 
		self updateStateFirstBlock.
		block executed]
]

{ #category : #initialization }
SBMethod >> initialize [ 	
	super initialize.
	blocks := OrderedCollection new.
	executed := false.
]

{ #category : #'as yet unclassified' }
SBMethod >> installGhosts [
	| rbMethodNode newMethod aClass |
	[ rbMethodNode := RBParser
		parseMethod: self originalMethod sourceCode.
	blocks := SBInstrumentor new
		visitNode: rbMethodNode;
		blocks.
	aClass := self originalMethod methodClass.
	newMethod := aClass compile: rbMethodNode printString notifying: nil.
	aClass >> newMethod replaceLiterals: {(#metaObject -> self)} ]
		on: Error
		do: [ :e | self halt. self uninstall ]
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

{ #category : #hooks }
SBMethod >> run: methodName with: listOfArguments in: receiver [
	| result |
	[ 
		S2Lock unlock.
		self updateStateFirstBlock.
		result := originalMethod valueWithReceiver: receiver arguments: listOfArguments.
	] ensure: [ 
		S2Lock lock.
	].
	^ result.
]

{ #category : #installing }
SBMethod >> uninstall [
	self originalMethod methodClass methodDict at: self selector put: self originalMethod
]

{ #category : #'as yet unclassified' }
SBMethod >> updateStateFirstBlock [
	executed := true.
	blocks ifNotEmpty: [ blocks first execute. ]
]
