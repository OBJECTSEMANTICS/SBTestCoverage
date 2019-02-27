Class {
	#name : #SBCounting,
	#superclass : #Object,
	#category : #SBTCExamples
}

{ #category : #accessing }
SBCounting >> main [
	^ self one
]

{ #category : #'as yet unclassified' }
SBCounting >> methMix [
	| aBoolean number |
	aBoolean := 2 == 3.
	aBoolean
		ifTrue: [ number := 3 ]
		ifFalse: [ number := 5 ].
	number := number + 1.
	^ number
]

{ #category : #'as yet unclassified' }
SBCounting >> methWithCondition [
	^ 2 = 1
		ifTrue: [ 3 ]
		ifFalse: [ 4 ]
]

{ #category : #'accessing structure variables' }
SBCounting >> one [
	^ 1.
]
