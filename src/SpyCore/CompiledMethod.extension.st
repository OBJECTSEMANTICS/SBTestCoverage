Extension { #name : #CompiledMethod }

{ #category : #'*spycore' }
CompiledMethod >> addOutgoingCalls: aSpyMethod [
	"Do nothing"
]

{ #category : #'*spycore-testing' }
CompiledMethod >> allIncomingCalls [
	^ #()
]

{ #category : #'*spycore-copying' }
CompiledMethod >> copyFor: aBehavior [
	| copy numberOfLiterals superRef |
	numberOfLiterals := self numLiterals.
	copy := self copy.
	superRef := (self literalAt: numberOfLiterals) copy.
	superRef value: aBehavior.
	copy literalAt: numberOfLiterals put: superRef.
	^ copy
]

{ #category : #'*spycore-testing' }
CompiledMethod >> hasMethodSpyAsLiteral [
	"True if one of my literals has a method spy"
	^ self literals anySatisfy: [ :l | (l isKindOf: MethodSpy) ]
]

{ #category : #'*spycore-testing' }
CompiledMethod >> incomingCalls [
	^ #()
]

{ #category : #'*spycore-testing' }
CompiledMethod >> isSpy [
	"True if I am an instrumented method"

	"^ self isTemplateMethod"
	^ self hasMethodSpyAsLiteral
]

{ #category : #'*spycore-testing' }
CompiledMethod >> isTemplateMethod [
	^ Profiler templateMethods anySatisfy: [ :cm | (self size = cm size) 
													and: [ (self initialPC to: self endPC) allSatisfy: [ :i | 
															(self at: i) = (cm at: i) ] ] ]
]

{ #category : #'*spycore-copying' }
CompiledMethod >> methodSpy [
	(self literalsDo: [ :l | (l isKindOf: MethodSpy)
							ifTrue: [ ^ l ] ]).
	self error: 'There is no original method'
]

{ #category : #'*spycore-copying' }
CompiledMethod >> originalMethod [
	^ self methodSpy originalMethod
]

{ #category : #'*spycore-accessingpragmas' }
CompiledMethod >> pragmaAt: aKey [
	"Answer the pragma with selector aKey, or nil if none."
	| propertiesOrSelector |
	self isSpy ifFalse: 
		[ ^(propertiesOrSelector := self penultimateLiteral) isMethodProperties
			ifTrue: [propertiesOrSelector at: aKey ifAbsent: [nil]]
			ifFalse: [nil] ].
	self methodClass == Profiler class ifTrue: [ ^ #() ].
	^ self originalMethod pragmaAt: aKey
		
]

{ #category : #'*spycore-accessingpragmas' }
CompiledMethod >> pragmas [
	| selectorOrProperties |
	^(selectorOrProperties := self penultimateLiteral) isMethodProperties
		ifTrue: [selectorOrProperties pragmas]
		ifFalse: [#()]
]

{ #category : #'*spycore-copying' }
CompiledMethod >> replaceLiteral: anObject by: anotherObject [
	1 to: self numLiterals do: [ :i | 
		((self literalAt: i) = anObject)
			ifTrue: [ self literalAt: i put: anotherObject ]
	]
]

{ #category : #'*spycore-copying' }
CompiledMethod >> replaceLiterals: associations [
	associations do: [:assoc | self replaceLiteral: assoc key by: assoc value ]
]

{ #category : #'*spycore' }
CompiledMethod >> withAllIncomingCalls [
	^ Array with: self 
]
