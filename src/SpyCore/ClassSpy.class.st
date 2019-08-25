"
I represent the profiling data for a class.

My attributes are:
the classes name, 
a metaclass spy, and 
a set of method spies.

For each method in the corresponding class, I create a MethodSpy.

"
Class {
	#name : #ClassSpy,
	#superclass : #Spy,
	#instVars : [
		'methods',
		'className',
		'allSubclassesCache',
		'packageSpy',
		'metaclassSpy'
	],
	#category : #SpyCore
}

{ #category : #hooks }
ClassSpy class >> spyClassForMethod [
	^ MethodSpy 
]

{ #category : #'accessing-computed' }
ClassSpy >> >> aSymbol [
	^ self localMethodAt: aSymbol
]

{ #category : #hooks }
ClassSpy >> afterEachExecution: messageName On: aReceiver with: arguments [
]

{ #category : #hooks }
ClassSpy >> afterEachExecution: messageName on: aReceiver with: arguments [
]

{ #category : #'accessing-computed' }
ClassSpy >> allMethods [
	^ self methods , self metaclassSpy methods
]

{ #category : #'accessing-computed' }
ClassSpy >> allSubclasses [
	allSubclassesCache ifNotNil: [ ^ allSubclassesCache ].
	^ allSubclassesCache := self subclasses inject: #() into: [:sum :cls | sum, {cls}, cls allSubclasses ]
	
	"| coll |
	coll := OrderedCollection new.
	self subclasses do: [:cls | coll add: cls. coll addAll: cls allSubclasses ].
	^ coll"
]

{ #category : #hooks }
ClassSpy >> beforeEachExecution: messageName On: aReceiver with: arguments [
]

{ #category : #hooks }
ClassSpy >> beforeEachExecution: messageName on: aReceiver with: arguments [
]

{ #category : #action }
ClassSpy >> browse [
	self theClass browse
]

{ #category : #contract }
ClassSpy >> checkInvariant [
	self assert: [ className notNil ].
	self assert: [ className isKindOf: Symbol ].

	self assert: [ self profiler notNil ].

	self assert: [ self methods notNil ].
	self assert: [ self methods isCollection ].
	self assert: [ self methods allSatisfy: [:m| m isKindOf: MethodSpy ] ].

	self assert: [ self class spyClassForMethod == self profiler class spyClassForMethod ].
	self assert: [ self class spyClassForMethod == self profiler class spyClassForMethod ].
	self assert: [ self class == self profiler class spyClassForClass ].
]

{ #category : #accessing }
ClassSpy >> className [
	^ className
]

{ #category : #accessing }
ClassSpy >> className: aSymbol [
	className := aSymbol
]

{ #category : #'accessing-computed' }
ClassSpy >> coveredMethods [
	"Return the list of covered methods"

	^ self methods select: #isCovered
]

{ #category : #'accessing-computed' }
ClassSpy >> downwardLookupMethodsNamed: aSelector [
	^ (self allSubclasses select: [:cls | cls hasMethodNamed: aSelector])
			collect: [:cls | cls localMethodAt: aSelector ]
		
]

{ #category : #testing }
ClassSpy >> hasMethodNamed: aSelector [
	^ self localMethods includesKey: aSelector
]

{ #category : #'initialize-release' }
ClassSpy >> initialize [ 
	super initialize.
	 methods := Dictionary new 
]

{ #category : #testing }
ClassSpy >> isClassPresent [
	^ Smalltalk globals includesKey: className 
]

{ #category : #testing }
ClassSpy >> isMeta [
	^ self className includes: $ .
]

{ #category : #testing }
ClassSpy >> isPartiallyCovered [
	^ self methods anySatisfy: #isCovered
]

{ #category : #testing }
ClassSpy >> isSubclassOf: aClassSpy [
	"True of I am a subclass of aClassSpy"
	
	^ self == aClassSpy
		ifTrue: [ true ]
		ifFalse: [ 
			self superclass ifNil: [ ^ false ].
			self superclass isSubclassOf: aClassSpy ]
]

{ #category : #testing }
ClassSpy >> isTestClass [
	"Return true if the real class is a test case"
	
	^ self theClass inheritsFrom: TestCase.
]

{ #category : #'accessing-computed' }
ClassSpy >> localMethodAt: aSelector [
	^ self localMethods at: aSelector
]

{ #category : #'accessing-computed' }
ClassSpy >> localMethodAt: aSelector ifAbsent: aBlock [
	^ self localMethods at: aSelector ifAbsent: aBlock
]

{ #category : #'accessing-computed' }
ClassSpy >> localMethodAt: aSelector put:  value [
	^ self localMethods at: aSelector put: value
]

{ #category : #accessing }
ClassSpy >> localMethods [
	^ methods 
]

{ #category : #'accessing-computed' }
ClassSpy >> lookupMethodNamed: aSelector [
	^ (self hasMethodNamed: aSelector)
			ifTrue: [ self localMethodAt: aSelector ]
			ifFalse: [ self superclass lookupMethodNamed: aSelector ]
]

{ #category : #accessing }
ClassSpy >> metaclassSpy [
	^ metaclassSpy ifNil: 
		[ metaclassSpy := self class new className: self theClass class name asSymbol ; yourself ]
]

{ #category : #'accessing-computed' }
ClassSpy >> methods [ 
	^ methods values
]

{ #category : #'accessing-computed' }
ClassSpy >> nonMetaClassName [
	^ (self isMeta
		ifTrue: [ self className copyFrom: 1 to: ((self className indexOf: $ ) - 1)] 
		ifFalse: [ self className ]) asSymbol
]

{ #category : #'accessing-computed' }
ClassSpy >> numberOfAllMethods [
	^ self allMethods size
]

{ #category : #'accessing-computed' }
ClassSpy >> numberOfCoveredMethods [
	^ self coveredMethods size
]

{ #category : #'accessing-computed' }
ClassSpy >> numberOfMethods [
	^ self methods size
]

{ #category : #accessing }
ClassSpy >> package [
	^ packageSpy 
]

{ #category : #accessing }
ClassSpy >> packageSpy [
	^ packageSpy
]

{ #category : #accessing }
ClassSpy >> packageSpy: anObject [

	packageSpy := anObject.
	metaclassSpy ifNotNil: [ metaclassSpy packageSpy: anObject ]
]

{ #category : #printing }
ClassSpy >> printOn: stream [
	stream nextPut: $<.
	stream nextPutAll: (self className printString).
	stream nextPut: $>
]

{ #category : #'accessing-computed' }
ClassSpy >> profiler [
	^ self package profiler
]

{ #category : #'accessing-computed' }
ClassSpy >> subclasses [
	^ self profiler allClassesSuchThat: [:cls | cls superclass == self]
]

{ #category : #accessing }
ClassSpy >> superclass [
	^ self profiler classAt: self theClass superclass name ifNone: [nil]
]

{ #category : #accessing }
ClassSpy >> theClass [
	^ self isMeta
		ifTrue: [ (Smalltalk at: self nonMetaClassName) class ]
		ifFalse: [ Smalltalk at: self className ]

]

{ #category : #'accessing-computed' }
ClassSpy >> theNonMetaClass [ 
	"Return the non metaclass spy for the receiver"
	
	self isMeta ifFalse: [ ^ self ].
	^ self packageSpy >> self nonMetaClassName
]

{ #category : #testing }
ClassSpy >> understandMethodNamed: aSelector [
	(self hasMethodNamed: aSelector)
		ifTrue: [ ^ true ].
	
	self superclass ifNil: [ ^ false ].
	
	^ self superclass understandMethodNamed: aSelector
]

{ #category : #'accessing-computed' }
ClassSpy >> withAllSubclasses [
	^ {self}, self allSubclasses
]
