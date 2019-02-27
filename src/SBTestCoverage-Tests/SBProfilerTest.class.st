Class {
	#name : #SBProfilerTest,
	#superclass : #SBTest,
	#category : #'SBTestCoverage-Tests-Core'
}

{ #category : #tests }
SBProfilerTest >> testMethodCoverage [
	| profiler |
	"profiler := SBProfiler profile: [ 
		SBCounting new.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler methodCoverage equals: 0."
	
	profiler := SBProfiler profile: [ 
		SBCounting new one.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler methodCoverage equals: 25.
	
	"profiler := SBProfiler profile: [ 
		SBCounting new main.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler methodCoverage equals: 50."
	"
	profiler := SBProfiler profile: [ 
		SBCounting new methWithCondition.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler methodCoverage equals: 25.
	
	profiler := SBProfiler profile: [ 
		SBCounting new methMix.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler methodCoverage equals: 25."
]

{ #category : #tests }
SBProfilerTest >> testProfileOnClass [
	| profiler |
	profiler := SBProfiler profile: [ 
		SBCounting new.	
	] onPackagesMatching:'SBTCEx*'.
	self assert: profiler class: SBProfiler.
	self assert: profiler methodCoverage equals: 0.
	self assert: profiler statementCoverage equals: 0.
]

{ #category : #tests }
SBProfilerTest >> testProfileOnComposeMethod [
	| profiler |
	profiler := SBProfiler profile: [ 
		SBCounting new main.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler methodCoverage equals: 50.
	self assert: profiler statementCoverage equals: 3
]

{ #category : #tests }
SBProfilerTest >> testProfileOnSimpleMethod [
	| profiler |
	profiler := SBProfiler profile: [ 
		SBCounting new one.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler methodCoverage equals: 25.
	self assert: profiler statementCoverage equals: 3
]

{ #category : #tests }
SBProfilerTest >> testStatementCoverage [
	| profiler |
	profiler := SBProfiler profile: [ 
		SBCounting new one.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler statementCoverage equals: 3.
	
	profiler := SBProfiler profile: [ 
		SBCounting new main.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler statementCoverage equals: 3.
	
	profiler := SBProfiler profile: [ 
		SBCounting new methWithCondition.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler statementCoverage equals: 3.
	
	profiler := SBProfiler profile: [ 
		SBCounting new methMix.	
	] onPackagesMatching: 'SBTCEx*'.
	self assert: profiler statementCoverage equals: 3.
]
