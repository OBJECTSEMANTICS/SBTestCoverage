Class {
	#name : #SBProfiler,
	#superclass : #S2Profiler,
	#category : #'SBTestCoverage-Core'
}

{ #category : #hooks }
SBProfiler class >> spyClassForPackage [ 
	^ SBPackage 
]

{ #category : #'public - metrics' }
SBProfiler >> methodCoverage [
	self allMethods isEmpty ifTrue: [ ^ 0 ].
	^ (100 * self numberOfExecutedMethods /self allMethods size ) asFloat.
]

{ #category : #'public - metrics' }
SBProfiler >> numberOfAllStatements [
	^ self allMethods
		inject: 0
		into: [ :sum :method | sum + method numberOfAllStatements ].
]

{ #category : #'public - metrics' }
SBProfiler >> numberOfExecutedMethods [
	^ (self allMethods collect: [ :aMethod | aMethod blocks first ] 
	thenSelect: [:aBlock | aBlock wasExecuted]) size
]

{ #category : #'public - metrics' }
SBProfiler >> numberOfExecutedStatements [
	^ self allMethods
		inject: 0
		into: [ :sum :method | sum + method numberOfExecutedStatements ]
]

{ #category : #profiling }
SBProfiler >> profile: aBlock onPackagesMatching: regex [

	[ "(S2CInstrumentator onPackagesMatching: regex) applyOn: self."
		self startOnPackagesMatching: regex.
		aBlock value.
		self allMethods do:#installGhosts.
		"aBlock value."
	 ] ensure: [ 
		self allMethods do:#uninstall.
		self stop.].
]

{ #category : #'public - metrics' }
SBProfiler >> statementCoverage [
	self numberOfAllStatements == 0 ifTrue: [ ^ 0 ].
	^ (100 * self numberOfExecutedStatements / self numberOfAllStatements ) asFloat.
]