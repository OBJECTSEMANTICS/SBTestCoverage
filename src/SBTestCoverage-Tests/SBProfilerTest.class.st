Class {
	#name : #SBProfilerTest,
	#superclass : #SBTest,
	#category : #'SBTestCoverage-Tests-Core'
}

{ #category : #running }
SBProfilerTest >> tearDown [ 
	super tearDown
]

{ #category : #tests }
SBProfilerTest >> testMethodCoverage [
	| profiler |
	profiler := SBProfiler
		profile: [ SBCounting new ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNumExecutedMethodsOf: profiler on: #SBCounting equals: 0.
	self assertMethodCoverageOf: profiler on: #SBCounting equals: 0.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new one ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNumExecutedMethodsOf: profiler on: #SBCounting equals: 1.
	self assertMethodCoverageOf: profiler on: #SBCounting equals: ((1/7) asFloat  * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new anAssignment ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNumExecutedMethodsOf: profiler on: #SBCounting equals: 1.
	self assertMethodCoverageOf: profiler on: #SBCounting equals: ((1/7) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new main ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNumExecutedMethodsOf: profiler on: #SBCounting equals: 2.
	self assertMethodCoverageOf: profiler on: #SBCounting equals: ((2/7) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithCondition ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNumExecutedMethodsOf: profiler on: #SBCounting equals: 1.
	self assertMethodCoverageOf: profiler on: #SBCounting equals: ((1/7) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methMix ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNumExecutedMethodsOf: profiler on: #SBCounting equals: 1.
	self assertMethodCoverageOf: profiler on: #SBCounting equals: ((1/7) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithComposeBlocks ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNumExecutedMethodsOf: profiler on: #SBCounting equals: 1.
	self assertMethodCoverageOf: profiler on: #SBCounting equals: ((1/7) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(2 6 8 13 5 9 11 13) ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNumExecutedMethodsOf: profiler on: #SBCounting equals: 1.
	self assertMethodCoverageOf: profiler on: #SBCounting equals: ((1/7) asFloat * 100 round: 3).
	self clean: profiler
]

{ #category : #tests }
SBProfilerTest >> testProfileOnPackagesMatching [
	| profiler |
	profiler := SBProfiler
		profile: [ SBCounting new ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler class: SBProfiler.
	self assertMethodCoverageOf: profiler on: #SBCounting equals: 0.
	self assert: profiler statementCoverage1 isEmpty.
	self clean: profiler
]

{ #category : #tests }
SBProfilerTest >> testStatementCoverage [
	| profiler |
	profiler := SBProfiler
		profile: [ SBCounting new ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfAllStatements equals: 27.
	self assert: profiler statementCoverage1 isEmpty.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new one ]
		onPackagesMatching: 'SBTCEx*'.
	self
		assertNumExecutedStatementsOf: profiler
		on: #SBCounting
		equals: 1.
	self assertStatementCoverageOf: profiler on: #SBCounting equals: ((1 / 27) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new anAssignment ]
		onPackagesMatching: 'SBTCEx*'.
	self
		assertNumExecutedStatementsOf: profiler
		on: #SBCounting
		equals: 2.
	self assertStatementCoverageOf: profiler on: #SBCounting equals: ((2 / 27) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new main ]
		onPackagesMatching: 'SBTCEx*'.
	self
		assertNumExecutedStatementsOf: profiler
		on: #SBCounting
		equals: 2.
	self assertStatementCoverageOf: profiler on: #SBCounting equals: ((2 / 27) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithCondition ]
		onPackagesMatching: 'SBTCEx*'.
	self
		assertNumExecutedStatementsOf: profiler
		on: #SBCounting
		equals: 2.
	self assertStatementCoverageOf: profiler on: #SBCounting equals: ((2 / 27) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methMix ]
		onPackagesMatching: 'SBTCEx*'.
	self
		assertNumExecutedStatementsOf: profiler
		on: #SBCounting
		equals: 5.
	self assertStatementCoverageOf: profiler on: #SBCounting equals: ((5 / 27) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithComposeBlocks ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 7.
	self assertStatementCoverageOf: profiler on: #SBCounting equals: ((7 / 27) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(2 6 8 13 5 9 11 13) ]
		onPackagesMatching: 'SBTCEx*'.
	self
		assertNumExecutedStatementsOf: profiler
		on: #SBCounting
		equals: 6.
	self assertStatementCoverageOf: profiler on: #SBCounting equals: ((6 / 27) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(1 4 6 7) ]
		onPackagesMatching: 'SBTCEx*'.
	self
		assertNumExecutedStatementsOf: profiler
		on: #SBCounting
		equals: 6.
	self assertStatementCoverageOf: profiler on: #SBCounting equals: ((6 / 27) asFloat * 100 round: 3).
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(4 6 12) ]
		onPackagesMatching: 'SBTCEx*'.
	self
		assertNumExecutedStatementsOf: profiler
		on: #SBCounting
		equals: 4.
	self assertStatementCoverageOf: profiler on: #SBCounting equals: ((4 / 27) asFloat * 100 round: 3).
	self clean: profiler
]
