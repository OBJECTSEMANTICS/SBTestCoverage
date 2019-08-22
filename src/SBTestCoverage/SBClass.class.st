Class {
	#name : #SBClass,
	#superclass : #ClassSpy,
	#instVars : [
		'methodCoverage',
		'lineCoverage'
	],
	#category : #'SBTestCoverage-Core'
}

{ #category : #hooks }
SBClass class >> spyClassForMethod [ 
	^ SBMethod
]
