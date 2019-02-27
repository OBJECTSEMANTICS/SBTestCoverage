Class {
	#name : #SBClass,
	#superclass : #S2Class,
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
