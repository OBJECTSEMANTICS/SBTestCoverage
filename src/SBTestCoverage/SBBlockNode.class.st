Class {
	#name : #SBBlockNode,
	#superclass : #Object,
	#instVars : [
		'id',
		'executed',
		'argument',
		'receiver',
		'selector',
		'selectorPart',
		'bodySource'
	],
	#category : #'SBTestCoverage-Core'
}

{ #category : #accessing }
SBBlockNode >> argument [
	^ argument
]

{ #category : #accessing }
SBBlockNode >> argument: anObject [
	argument := anObject
]

{ #category : #accessing }
SBBlockNode >> bodySource [
	^ bodySource
]

{ #category : #accessing }
SBBlockNode >> bodySource: anObject [
	bodySource := anObject
]

{ #category : #accessing }
SBBlockNode >> executed [
	^ executed
]

{ #category : #accessing }
SBBlockNode >> executed: anObject [
	executed := anObject
]

{ #category : #accessing }
SBBlockNode >> id [
	^ id
]

{ #category : #accessing }
SBBlockNode >> id: anObject [
	id := anObject
]

{ #category : #initialization }
SBBlockNode >> initialize [
	super initialize.
	executed := false.
	argument := false.
	receiver := false.
	selector := #none.
	selectorPart := #none.
]

{ #category : #accessing }
SBBlockNode >> receiver [
	^ receiver
]

{ #category : #accessing }
SBBlockNode >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
SBBlockNode >> selector [
	^ selector
]

{ #category : #accessing }
SBBlockNode >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
SBBlockNode >> selectorPart [
	^ selectorPart
]

{ #category : #accessing }
SBBlockNode >> selectorPart: anObject [
	selectorPart := anObject
]
