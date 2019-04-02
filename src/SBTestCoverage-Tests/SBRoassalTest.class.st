Class {
	#name : #SBRoassalTest,
	#superclass : #SBTest,
	#category : #'SBTestCoverage-Tests-Core'
}

{ #category : #tests }
SBRoassalTest >> testCoverageRTElement [
	| profiler |
	profiler := SBProfiler profile: [ 
		RTElement new.
	] onClass: RTElement.
	"profiler>>#RTElement>>#center."
	self assertNoExecutedMethods: profiler equals: 2.
	self assert: profiler numberOfExecutedStatements equals: 3.
	
	profiler := SBProfiler profile: [ 
		RTElement new hasNestedElements.
	] onClass: RTElement.
	self assertNoExecutedMethods: profiler equals: 4.
	self assert: profiler numberOfExecutedStatements equals: 6.
	
	profiler := SBProfiler profile: [ 
		RTElement new incomingEdges.
	] onClass: RTElement.
	self assertNoExecutedMethods: profiler equals: 3.
	self assert: profiler numberOfExecutedStatements equals: 6.
	
]

{ #category : #tests }
SBRoassalTest >> testCoverageRTTheme [
	| profiler |
	profiler := SBProfiler profile: [ 
		RTTheme new textFont.
	] onClass: RTTheme.
	self assertNoExecutedMethods: profiler equals: 2.
	self assert: profiler numberOfExecutedStatements equals: 2.
	"
	profiler := SBProfiler profile: [ 
		RTElement new hasNestedElements.
	] onClass: RTElement.
	self assertNoExecutedMethods: profiler equals: 4.
	self assert: profiler numberOfExecutedStatements equals: 6.
	
	profiler := SBProfiler profile: [ 
		RTElement new incomingEdges.
	] onClass: RTElement.
	self assertNoExecutedMethods: profiler equals: 3.
	self assert: profiler numberOfExecutedStatements equals: 6.
	"
]

{ #category : #tests }
SBRoassalTest >> testMethodCoverageRTBox [
	| profiler |
	profiler := SBProfiler profile: [ 
		RTBox new width: 20.
	] onPackagesMatching: 'Roassal2-Co*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	
]

{ #category : #tests }
SBRoassalTest >> testMethodCoverageRTGroup [
	| profiler |
	profiler := SBProfiler profile: [ 
		RTGroup new attributeAt: #foo ifAbsentPut: 20.
	] onPackagesMatching: 'Roassal2-Co*'.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	
]
