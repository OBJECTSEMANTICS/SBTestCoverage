Class {
	#name : #SBBlock,
	#superclass : #SBObject,
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

{ #category : #'as yet unclassified' }
SBBlock >> noExecuted [
	executed := false.
	
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
