Class {
	#name : #SBBlock,
	#superclass : #Object,
	#instVars : [
		'id',
		'executed',
		'numberOfStatements'
	],
	#category : #'SBTestCoverage-Core'
}

{ #category : #accessing }
SBBlock >> executed [
	executed := true.
]

{ #category : #accessing }
SBBlock >> id [
	^ id
]

{ #category : #accessing }
SBBlock >> id: anObject [
	id := anObject
]

{ #category : #initialization }
SBBlock >> initialize [
	super initialize.
	executed := false.
	numberOfStatements := 0
]

{ #category : #accessing }
SBBlock >> numberOfStatements [
	^ numberOfStatements
]

{ #category : #accessing }
SBBlock >> numberOfStatements: anObject [
	numberOfStatements := anObject
]

{ #category : #accessing }
SBBlock >> wasExecuted [
	^ executed.
]
