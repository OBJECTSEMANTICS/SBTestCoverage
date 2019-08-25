Extension { #name : #MessageTally }

{ #category : #'*spycore' }
MessageTally >> allMethodNames [
	"Return the list of methods name reported by message tally"

	| answer |
	answer := Set new.
	self allMethodsNamesIn: answer.
	^ answer
]

{ #category : #'*spycore' }
MessageTally >> allMethodNamesScopedTo: aPackageRegExp [
	"Return the list of methods name reported by message tally"

	| answer |
	answer := Set new.
	self allMethodsNamesIn: answer scopedTo: aPackageRegExp.
	^ answer
]

{ #category : #'*spycore' }
MessageTally >> allMethods [
	"Return all the methods that are reported by message tally"
	
	| answer |
	answer := Set new.
	self allMethodsIn: answer.
	^ answer
]

{ #category : #'*spycore' }
MessageTally >> allMethodsIn: collection [
	collection add: self method.
	self receivers do: [ :t | t allMethodsIn: collection ]
]

{ #category : #'*spycore' }
MessageTally >> allMethodsNamesIn: collection [
	collection add: (self method methodClass name, '>>', self method selector).
	self receivers do: [ :t | t allMethodsNamesIn: collection ]
]

{ #category : #'*spycore' }
MessageTally >> allMethodsNamesIn: collection scopedTo: aPackageRegExp [
	"aPackageRegExp may be 'XML*' for example."

	(aPackageRegExp match: self method methodClass theNonMetaClass category)
		ifTrue: 
			[ collection add: (self method methodClass name, '>>', self method selector) ].

	self receivers do: [ :t | t allMethodsNamesIn: collection scopedTo: aPackageRegExp ]
]

{ #category : #'*spycore' }
MessageTally >> fullReport [
	^ String streamContents: [:strm |
		self report: strm ]
]

{ #category : #'*spycore' }
MessageTally >> talliesFor: aCompiledMethod [
	^ self talliesFor: aCompiledMethod in: OrderedCollection new
]

{ #category : #'*spycore' }
MessageTally >> talliesFor: aCompiledMethod in: collection [
	(self method == aCompiledMethod) 
		ifTrue: [ collection add: self ].

	self receivers do: [ :t | t talliesFor: aCompiledMethod in: collection ].
	^ collection
]

{ #category : #'*spycore' }
MessageTally >> timeFor: aCompiledMethod [
	^ (self talliesFor: aCompiledMethod) inject: 0 into: [ :sum :el | (((sum + el tally) * 10000 / self tally) asInteger / 100) asFloat ].
	
"	| v |
	v := receivers inject: 0 into: [ :sum :el | sum + (el timeFor: aCompiledMethod) ].
	^ v + ((method == aCompiledMethod)
			ifTrue: [ time ]
			ifFalse: [ 0 ]).
"
]
