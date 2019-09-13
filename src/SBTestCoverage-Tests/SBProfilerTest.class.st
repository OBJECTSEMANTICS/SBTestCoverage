Class {
	#name : #SBProfilerTest,
	#superclass : #SBTest,
	#category : #'SBTestCoverage-Tests-Core'
}

{ #category : #tests }
SBProfilerTest >> testMethodCoverage [
	| profiler |
	profiler := SBProfiler
		profile: [ SBCounting new ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 0.
	self asserMethodCoverage: profiler toNoExecutedMethods: 0.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new one ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new anAssignment ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new main ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 2.
	self asserMethodCoverage: profiler toNoExecutedMethods: 2.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithCondition ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methMix ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithComposeBlocks ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(2 6 8 13 5 9 11 13) ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	self clean: profiler
]

{ #category : #tests }
SBProfilerTest >> testProfileOnPackagesMatching [
	| profiler |
	profiler := SBProfiler
		profile: [ SBCounting new ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler class: SBProfiler.
	self assert: profiler methodCoverage equals: 0.
	self assert: profiler statementCoverage equals: 0.
	self clean: profiler.
]

{ #category : #tests }
SBProfilerTest >> testStatementCoverage [
	| profiler |
	profiler := SBProfiler
		profile: [ SBCounting new ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfAllStatements equals: 27.
	self assert: profiler statementCoverage equals: 0.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new one ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 1.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new anAssignment ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 2.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new main ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 2.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithCondition ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 2.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methMix ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 5.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithComposeBlocks ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 7.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(2 6 8 13 5 9 11 13) ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 6.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(1 4 6 7) ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 6.
	self clean: profiler.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(4 6 12) ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 4.
	self clean: profiler.
]
