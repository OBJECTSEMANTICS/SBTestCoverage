Class {
	#name : #SBProfiler,
	#superclass : #S2Profiler,
	#category : #'SBTestCoverage-Core'
}

{ #category : #hooks }
SBProfiler class >> spyClassForPackage [ 
	^ SBPackage 
]

{ #category : #'as yet unclassified' }
SBProfiler >> dictCoverage [
	^ Dictionary new
		at: 'methodCoverage' put: self methodCoverage;
		at: 'statementCoverage' put: self statementCoverage;
		at: 'noAllMethods' put: self allMethods size;
		at: 'noAllStatements' put: self numberOfAllStatements;
		at: 'noOfExecutedMethods' put: self numberOfExecutedMethods;
		at: 'noOfExecutedStatements' put: self numberOfExecutedStatements;
		yourself
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
SBProfiler >> profile: aBlock onClass: aClass [

	[ (S2CInstrumentator onClass: aClass) applyOn: self.
		self allMethods do:#installGhosts.
		aBlock value.
	 ] ensure: [ 
		self allMethods do:#uninstall.
		self stop.].
]

{ #category : #profiling }
SBProfiler >> profile: aBlock onPackagesMatching: regex [

	[ (S2CInstrumentator onPackagesMatching: regex) applyOn: self.
		self allMethods do:#installGhosts.
		aBlock value.
	 ] ensure: [ 
		self allMethods do:#uninstall.
		self stop.].
]

{ #category : #'public - metrics' }
SBProfiler >> statementCoverage [
	self numberOfAllStatements == 0 ifTrue: [ ^ 0 ].
	^ (100 * self numberOfExecutedStatements / self numberOfAllStatements ) asFloat.
]
