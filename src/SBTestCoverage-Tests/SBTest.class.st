Class {
	#name : #SBTest,
	#superclass : #TestCase,
	#category : #'SBTestCoverage-Tests-Core'
}

{ #category : #asserting }
SBTest >> assert: aObject class: aClass [
	self assert: aObject className equals: aClass name asString
]

{ #category : #running }
SBTest >> tearDown [ 
	S2Lock value: false.
	S2Context value: nil
]
