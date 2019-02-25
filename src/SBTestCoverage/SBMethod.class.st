Class {
	#name : #SBMethod,
	#superclass : #S2Method,
	#instVars : [
		'blocks',
		'behavior',
		'executed',
		'executions'
	],
	#category : #'SBTestCoverage-Core'
}

{ #category : #enumerating }
SBMethod >> count: aNumber [
	blocks do:[ :aBlock |
		(aBlock id= aNumber) ifTrue:[ aBlock executed: true].
	].
]

{ #category : #initialization }
SBMethod >> initialize [ 	
	super initialize.
	executions := 0.
	blocks := OrderedCollection new.
	behavior := Behavior new.
	executed := false.
]

{ #category : #'as yet unclassified' }
SBMethod >> installGhosts [
	 | rbMethodNode instrumentor newSel aClass|

	aClass := self originalMethod  methodClass.
	[rbMethodNode := RBParser parseMethod: self originalMethod sourceCode.
	instrumentor := SBInstrumentor new.
	instrumentor visitNode: rbMethodNode.
	blocks := instrumentor blocks.
	
	newSel := (aClass compile: rbMethodNode printString notifying: nil).
	(aClass >> newSel) replaceLiterals: {(#metaObject -> self)}.
	
	 ]
		on: Error
		do: [ :e |  self uninstall ]
]

{ #category : #hooks }
SBMethod >> run: methodName with: listOfArguments in: receiver [
	| result |
	[ 
		S2Lock unlock.
		executed := true.
		executions := executions + 1.
		result := originalMethod valueWithReceiver: receiver arguments: listOfArguments.
	] ensure: [ 
		S2Lock lock.
	].
	^ result.
]

{ #category : #installing }
SBMethod >> uninstall [
	behavior methodDict at: self selector put: self instrumentedMethod.
]
