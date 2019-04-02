Class {
	#name : #SBTest,
	#superclass : #TestCase,
	#category : #'SBTestCoverage-Tests-Core'
}

{ #category : #'as yet unclassified' }
SBTest >> asserMethodCoverage: profiler toNoExecutedMethods: aNumber [
	self assert: profiler methodCoverage closeTo: (100 * aNumber / profiler allMethods size) asFloat
]

{ #category : #asserting }
SBTest >> assert: aObject class: aClass [
	self assert: aObject className equals: aClass name asString
]

{ #category : #asserting }
SBTest >> assertNoExecutedMethods: profiler equals: aNumber [
	self assert: profiler numberOfExecutedMethods equals: aNumber
]

{ #category : #running }
SBTest >> tearDown [ 
	S2Lock value: false.
	S2Context value: nil
]