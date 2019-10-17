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

{ #category : #'public - metrics' }
SBClass >> numberOfAllStatements [
	^ self allMethods inject: 0 into: [ :sum :meth | 
		sum + meth numberOfAllStatements 
		 ]
]
