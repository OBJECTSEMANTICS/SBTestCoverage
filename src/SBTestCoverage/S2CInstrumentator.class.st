Class {
	#name : #S2CInstrumentator,
	#superclass : #Object,
	#category : #'SBTestCoverage-Core'
}

{ #category : #'private - template method' }
S2CInstrumentator >> installOnMethod: method [
	| spyMethod|
	self assert: [ method isSpy not ] description: 
	'Trying to instrument a previously instrumented method.
	To clean up Spy please run: S2Profiler remove'.

	spyMethod := self profiler createSpy: method.
	spyMethod originalMethod: method.
	
	method selector flushCache.
]
