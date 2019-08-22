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
	profiler := SBProfiler
		profile: [ SBCounting new one ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	profiler := SBProfiler
		profile: [ SBCounting new anAssignment ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	profiler := SBProfiler
		profile: [ SBCounting new main ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 2.
	self asserMethodCoverage: profiler toNoExecutedMethods: 2.
	profiler := SBProfiler
		profile: [ SBCounting new methWithCondition ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	profiler := SBProfiler
		profile: [ SBCounting new methMix ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	profiler := SBProfiler
		profile: [ SBCounting new methWithComposeBlocks ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	profiler := SBProfiler
		profile:
			[ SBCounting new methWithArguments: #(2 6 8 13 5 9 11 13) ]
		onPackagesMatching: 'SBTCEx*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1
]

{ #category : #tests }
SBProfilerTest >> testMethodCoverageOnClass [
	| profiler |
	profiler := SBProfiler
		profile: [ SBCounting new ]
		onClass: SBCounting.
	self assertNoExecutedMethods: profiler equals: 0.
	self asserMethodCoverage: profiler toNoExecutedMethods: 0.
	profiler := SBProfiler
		profile: [ SBCounting new one ]
		onClass: SBCounting.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	profiler := SBProfiler
		profile: [ SBCounting new anAssignment ]
		onClass: SBCounting.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	profiler := SBProfiler
		profile: [ SBCounting new main ]
		onClass: SBCounting.
	self assertNoExecutedMethods: profiler equals: 2.
	self asserMethodCoverage: profiler toNoExecutedMethods: 2.
	profiler := SBProfiler
		profile: [ SBCounting new methWithCondition ]
		onClass: SBCounting.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	profiler := SBProfiler
		profile: [ SBCounting new methMix ]
		onClass: SBCounting.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	profiler := SBProfiler
		profile: [ SBCounting new methWithComposeBlocks ]
		onClass: SBCounting.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(2 6 8 13 5 9 11 13) ]
		onClass: SBCounting.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1
]

{ #category : #tests }
SBProfilerTest >> testProfileOnClass [
	| profiler |
	profiler := SBProfiler
		profile: [ SBCounting new ]
		onClass: SBCounting.
	self assert: profiler class: SBProfiler.
	self assert: profiler methodCoverage equals: 0.
	self assert: profiler statementCoverage equals: 0
]

{ #category : #tests }
SBProfilerTest >> testProfileOnPackagesMatching [
	| profiler |
	profiler := SBProfiler profile: [ 
		SBCounting new.	
	] onPackagesMatching:'SBTCEx*'.
	self assert: profiler class: SBProfiler.
	self assert: profiler methodCoverage equals: 0.
	self assert: profiler statementCoverage equals: 0.
]

{ #category : #tests }
SBProfilerTest >> testStatementCoverage [
	| profiler |
	profiler := SBProfiler
		profile: [ SBCounting new ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfAllStatements equals: 27.
	self assert: profiler statementCoverage equals: 0.
	profiler := SBProfiler
		profile: [ SBCounting new one ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 1.
	profiler := SBProfiler
		profile: [ SBCounting new anAssignment ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 2.
	profiler := SBProfiler
		profile: [ SBCounting new main ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 2.
	profiler := SBProfiler
		profile: [ SBCounting new methWithCondition ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 2.
	profiler := SBProfiler
		profile: [ SBCounting new methMix ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 5.
	profiler := SBProfiler
		profile: [ SBCounting new methWithComposeBlocks ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 7.
	profiler := SBProfiler
		profile:
			[ SBCounting new methWithArguments: #(2 6 8 13 5 9 11 13) ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 6.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(1 4 6 7) ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 6.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(4 6 12) ]
		onPackagesMatching: 'SBTCEx*'.
	self assert: profiler numberOfExecutedStatements equals: 4
]

{ #category : #tests }
SBProfilerTest >> testStatementCoverageOnClass [
	| profiler |
	profiler := SBProfiler
		profile: [ SBCounting new ]
		onClass: SBCounting.
	self assert: profiler numberOfAllStatements equals: 27.
	self assert: profiler statementCoverage equals: 0.
	profiler := SBProfiler
		profile: [ SBCounting new one ]
		onClass: SBCounting.
	self assert: profiler numberOfExecutedStatements equals: 1.
	profiler := SBProfiler
		profile: [ SBCounting new anAssignment ]
		onClass: SBCounting.
	self assert: profiler numberOfExecutedStatements equals: 2.
	profiler := SBProfiler
		profile: [ SBCounting new main ]
		onClass: SBCounting.
	self assert: profiler numberOfExecutedStatements equals: 2.
	profiler := SBProfiler
		profile: [ SBCounting new methWithCondition ]
		onClass: SBCounting.
	self assert: profiler numberOfExecutedStatements equals: 2.
	profiler := SBProfiler
		profile: [ SBCounting new methMix ]
		onClass: SBCounting.
	self assert: profiler numberOfExecutedStatements equals: 5.
	profiler := SBProfiler
		profile: [ SBCounting new methWithComposeBlocks ]
		onClass: SBCounting.
	self assert: profiler numberOfExecutedStatements equals: 7.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(2 6 8 13 5 9 11 13) ]
		onClass: SBCounting.
	self assert: profiler numberOfExecutedStatements equals: 6.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(1 4 6 7) ]
		onClass: SBCounting.
	self assert: profiler numberOfExecutedStatements equals: 6.
	profiler := SBProfiler
		profile: [ SBCounting new methWithArguments: #(4 6 12) ]
		onClass: SBCounting.
	self assert: profiler numberOfExecutedStatements equals: 4
]
