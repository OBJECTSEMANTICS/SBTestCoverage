Class {
	#name : #SBTest,
	#superclass : #TestCase,
	#category : #'SBTestCoverage-Tests-Core'
}

{ #category : #'as yet unclassified' }
SBTest >> asserMethodCoverage: profiler toNoExecutedMethods: aNumber [
	self assert: profiler methodCoverage closeTo: ((100 * aNumber / profiler allMethods size) asFloat round: 2)
]

{ #category : #asserting }
SBTest >> assert: aObject class: aClass [
	self assert: aObject className equals: aClass name asString
]

{ #category : #'as yet unclassified' }
SBTest >> assertMethodCoverageOf: profiler on: symbol equals: number [
	|dictMethodCoverage|
	dictMethodCoverage := profiler methodCoverage1.
	self
		assert: (dictMethodCoverage at: symbol)
		closeTo: ((100 * number / profiler allMethods size) asFloat round: 2)
]

{ #category : #asserting }
SBTest >> assertNoExecutedMethods: profiler equals: aNumber [
	self assert: profiler numberOfExecutedMethods equals: aNumber
]

{ #category : #asserting }
SBTest >> assertNumExecutedMethodsOf: profiler on: symbol equals: number [
	| dict |
	dict := profiler calculateExecutedMethodsByClass.
	self assert: (dict at: symbol) equals: number
]

{ #category : #asserting }
SBTest >> assertNumExecutedStatementsOf: profiler on: symbol equals: number [
	| dict |
	dict := profiler calculateExecutedStatementsByClass.
	self assert: (dict at: symbol) equals: number
]

{ #category : #'as yet unclassified' }
SBTest >> assertStatementCoverageOf: profiler on: symbol equals: number [
	| dictMethodCoverage |
	dictMethodCoverage := profiler statementCoverage1.
	self
		assert: (dictMethodCoverage at: symbol)
		equals: number
]

{ #category : #api }
SBTest >> clean: aProfiler [
	aProfiler cleanInstrumentation.
	SBProfiler resetInstance.
]

{ #category : #running }
SBTest >> tearDown [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove.
	super tearDown
]
