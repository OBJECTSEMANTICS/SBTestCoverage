Class {
	#name : #SBProfiler,
	#superclass : #S2Profiler,
	#classInstVars : [
		'instance'
	],
	#category : #'SBTestCoverage-Core'
}

{ #category : #'as yet unclassified' }
SBProfiler class >> profile: aBlock onClass: aClass [
	instance
		ifNil: [ instance := self new profile: aBlock onClass: aClass ].
	^ instance
]

{ #category : #'public - profiling' }
SBProfiler class >> profile: aBlock onPackagesMatching: regex [
	instance ifNil: [ instance := self new profile: aBlock onPackagesMatching: regex  ].
	^ instance
]

{ #category : #'as yet unclassified' }
SBProfiler class >> profileInstrumented: aBlock onClass: aClass [
	^ self new profileInstrumented: aBlock onClass: aClass
]

{ #category : #hooks }
SBProfiler class >> spyClassForPackage [ 
	^ SBPackage 
]

{ #category : #'as yet unclassified' }
SBProfiler >> cleanBlocks: blocks [
	blocks do: [ :aBlock | aBlock noExecuted ]
]

{ #category : #'as yet unclassified' }
SBProfiler >> cleanBlocksOfMethods [
	self allMethods do: [ :aMethod | 
		aMethod blocks do: [ :aBlock | aBlock noExecuted ]	
	]
]

{ #category : #'as yet unclassified' }
SBProfiler >> cleanInstrumentation [
	self allMethods do: #uninstall.
	self stop
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

{ #category : #'as yet unclassified' }
SBProfiler >> executeBlock: aBlock [
	self cleanBlocksOfMethods.
	aBlock value
]

{ #category : #'as yet unclassified' }
SBProfiler >> injectCodeToMethods [
	self allMethods select: #isNotMethodExtension thenDo: #installGhosts.
]

{ #category : #'public - metrics' }
SBProfiler >> methodCoverage [
	self allMethods isEmpty
		ifTrue: [ ^ 0 ].
	^ ((100 * self numberOfExecutedMethods / self allMethods size) asFloat) round: 2
]

{ #category : #'public - metrics' }
SBProfiler >> numberOfAllStatements [
	^ self allMethods
		inject: 0
		into: [ :sum :method | sum + method numberOfAllStatements ].
]

{ #category : #'public - metrics' }
SBProfiler >> numberOfExecutedMethods [
	| methodsWithBlocks |
	methodsWithBlocks := self allMethods select: [ :aMethod | aMethod blocks isNotEmpty ].
	^ (methodsWithBlocks 
		collect: [ :aMethod | aMethod blocks first ]
		thenSelect: [ :aBlock | aBlock wasExecuted ]) size 
]

{ #category : #'public - metrics' }
SBProfiler >> numberOfExecutedStatements [
	^ self allMethods
		inject: 0
		into: [ :sum :method | sum + method numberOfExecutedStatements ]
]

{ #category : #profiling }
SBProfiler >> profile: aBlock onClass: aClass [
	"[" (S2CInstrumentator onClass: aClass) applyOn: self.
	self injectCodeToMethods.
	"self allMethods do:#installGhosts."
	aBlock value "]
		ensure: [ self allMethods do: #uninstall.
			self stop ]"
]

{ #category : #profiling }
SBProfiler >> profile: aBlock onPackagesMatching: regex [
	"[" (S2CInstrumentator onPackagesMatching: regex) applyOn: self.
	self injectCodeToMethods.
	"self allMethods do: #installGhosts."
	aBlock value "]
		ensure: [ self allMethods do: #uninstall.
			self stop ]"
]

{ #category : #'as yet unclassified' }
SBProfiler >> profileInstrumented: aBlock onClass: aClass [
	(S2CInstrumentator onClass: aClass) applyOn: self.
	self injectCodeToMethods.
	"self allMethods do: #installGhosts."
	aBlock value
]

{ #category : #profiling }
SBProfiler >> profileInstrumented: aBlock onPackagesMatching: regex [
	(S2CInstrumentator onPackagesMatching: regex) applyOn: self.
	self injectCodeToMethods.
	aBlock value	
]

{ #category : #'public - metrics' }
SBProfiler >> statementCoverage [
	self numberOfAllStatements == 0
		ifTrue: [ ^ 0 ].
	^ ((100 * self numberOfExecutedStatements / self numberOfAllStatements)
		asFloat) round: 2
]
