"
I represent the profiling data for a package.

Each instance has a name and contains a set of class spies, that is, for each class in the corresponding package, an instance of ClassSpy is created.
"
Class {
	#name : #PackageSpy,
	#superclass : #Spy,
	#instVars : [
		'packageName',
		'classes',
		'profiler'
	],
	#category : #SpyCore
}

{ #category : #hooks }
PackageSpy class >> spyClassForClass [
	^ ClassSpy
]

{ #category : #accessing }
PackageSpy >> >> aSymbol [
	"we are accessing a method defined in a metaclass"
	(aSymbol includes: $ ) ifTrue: [ ^ (self >> aSymbol substrings first asSymbol) metaclassSpy ].
	
	^ self classAt: aSymbol
]

{ #category : #enumerating }
PackageSpy >> allClassesSuchThat: aBlock [
	^ self classes select: aBlock
]

{ #category : #'accessing-computed' }
PackageSpy >> allCoveredMethods [
	^ self allMethods select: #isCovered
]

{ #category : #'accessing-computed' }
PackageSpy >> allMethods [
	| coll |
	coll := OrderedCollection new.
	self classes do: [:cls | coll addAll: cls allMethods ].
	^ coll
]

{ #category : #enumerating }
PackageSpy >> allMethodsSuchThat: aBlock [
	^ self allMethods select: aBlock
]

{ #category : #contract }
PackageSpy >> checkInvariant [
	self assert: [ packageName notNil ].
	self assert: [ packageName isKindOf: ByteString ].
	self assert: [ self profiler notNil ].

	self assert: [ self classes notNil ].
	self assert: [ self classes allSatisfy: [ :c | c isKindOf: self class spyClassForClass ] ].
	self assert: [ self classes allSatisfy: [ :c | c package == self ] ].
	self assert: [ self classes allSatisfy: [ :c | c profiler == self profiler ]].
	
	self classes do: #checkInvariant
]

{ #category : #accessing }
PackageSpy >> classAt: aSymbol [
	^ classes at: aSymbol ifAbsent: [ self error: 'Class ', aSymbol, ' not found']
]

{ #category : #accessing }
PackageSpy >> classAt: aSymbol ifNone: aBlock [
	^ classes at: aSymbol ifAbsent: aBlock
	
]

{ #category : #accessing }
PackageSpy >> classAt: aSymbol put: aClassType [
	self assert: [aSymbol isSymbol].
	
	aClassType className: aSymbol.
	"self class globalTypesAt: aClassType className put: aClassType."
	^ classes at: aSymbol put: aClassType
]

{ #category : #accessing }
PackageSpy >> classes [ 
	^ classes
]

{ #category : #enumerating }
PackageSpy >> classesDo: aBlockOrSymbol [
	^ self classes do: aBlockOrSymbol
]

{ #category : #'accessing-computed' }
PackageSpy >> coveredClasses [
	^ self classes select: #isCovered
]

{ #category : #testing }
PackageSpy >> hasClassNamed: className [
	^ self classes includesKey: className asSymbol
]

{ #category : #'initialize-release' }
PackageSpy >> initialize [ 
	super initialize.
	classes := Dictionary new 
]

{ #category : #accessing }
PackageSpy >> packageName [
	^ packageName
]

{ #category : #accessing }
PackageSpy >> packageName: nameAsString [
	packageName  := nameAsString asString
]

{ #category : #printing }
PackageSpy >> printOn: stream [
	stream nextPutAll: '<<'.
	self packageName ifNotNil:[ stream nextPutAll: (self packageName asString).].
	stream nextPutAll: '>>'.
]

{ #category : #accessing }
PackageSpy >> profiler [
	^ profiler
]

{ #category : #accessing }
PackageSpy >> profiler: anObject [
	profiler := anObject
]

{ #category : #visualization }
PackageSpy >> viewBasicOn: view [
	view nodes: self classes forEach: [:each|
		view shape rectangle
			size: 15;
			fillColor: [:method |
				method isCovered 
					ifTrue: [ Color lightGray ]
					ifFalse: [ Color white ].
				].
		view nodes: (each methods sortedAs: #isCovered).
		view gridLayout gapSize: 2].
	view edgesFrom: #superclass.
	view treeLayout
]

{ #category : #visualization }
PackageSpy >> viewMethodOrderingOn: view [
	| tcls allMethods |
	tcls := self classes select: #isCovered.
	allMethods := self allMethods.
	view nodes: tcls forEach: [:each|
		[
		view shape rectangle
			size: 15;
			linearFillColor: #lastTimeStamp within: allMethods.
		view interaction item: 'inspect' action: #inspect.
		view nodes: (each methods).
		view gridLayout gapSize: 2
		] on: Error do: [:ex |  ex haltOnce ]].
	view edgesFrom: #superclass.
	view treeLayout
]
