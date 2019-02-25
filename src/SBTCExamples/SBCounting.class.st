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
SBCounting >> methWithCondition [
	^ 2 = 1
		ifTrue: [
			3 ]
		ifFalse: [ 
			4 ]
]

{ #category : #'accessing structure variables' }
SBCounting >> one [
	^ 1
]
