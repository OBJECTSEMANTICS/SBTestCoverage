"
I wrap a plain Pharo method and accumulate information during the program execution.

I have a selector name and belong to a ClassSpy.

I containt the hooks used to collect the actual runtime information. Three methods are provided for that purpose:

#beforeRun:with:in: and 
#afterRun:with:in: are executed before and after the corresponding Smalltalk method.

These methods are by default empty; they should be overridden in subclasses of MethodSpy to collect relevant dynamic information. The 

#run:with:in method simply calls #beforeRun:with:in:, followed by the execution of the represented Smalltalk method, and ultimately calls #afterRun:with:in:.

The parameters passed to these methods are: the method name (as a symbol), the list of arguments, and the object that receives the intercepted message.
"
Class {
	#name : #MethodSpy,
	#superclass : #Spy,
	#instVars : [
		'instrumentedMethod',
		'originalMethod',
		'selector',
		'classSpy',
		'outgoingCalls',
		'incomingCalls',
		'executionTime',
		'staticOutgoingCalls'
	],
	#classInstVars : [
		'inMeta'
	],
	#category : #SpyCore
}

{ #category : #public }
MethodSpy class >> isInMeta [
	^ inMeta 
]

{ #category : #public }
MethodSpy class >> notIdentifiedMethod [
	^ self
]

{ #category : #public }
MethodSpy class >> setInMeta [
	inMeta := true
]

{ #category : #public }
MethodSpy class >> setInNonMeta [
	inMeta := false
]

{ #category : #hooks }
MethodSpy class >> spyClassForMethod [
	^ self
]

{ #category : #delegation }
MethodSpy >> = v [
	| vp |
	(v isKindOf: MethodSpy)
		ifTrue: [ vp := v originalMethod ]
		ifFalse: [ vp := v ].
	
	^ self originalMethod == vp
]

{ #category : #accessing }
MethodSpy >> addIncomingCalls: methodSpy [
	^ self incomingCalls add: methodSpy
]

{ #category : #accessing }
MethodSpy >> addOutgoingCalls: methodSpy [
	^ self outgoingCalls add: methodSpy
]

{ #category : #hooks }
MethodSpy >> afterRun: methodName with: listOfArguments in: receiver [

]

{ #category : #'accessing-computed' }
MethodSpy >> allIncomingCalls [
	| answer |
	answer := OrderedCollection new.
	answer addAll: self incomingCalls.
	self incomingCalls do: [:c |
		answer addAll: c allIncomingCalls ].
	^ answer
]

{ #category : #'accessing-computed' }
MethodSpy >> allOutgoingCalls [
	| answer |
	answer := OrderedCollection new.
	self allOutgoingCallsRunning: answer.
	^ answer
]

{ #category : #'accessing-computed' }
MethodSpy >> allOutgoingCallsRunning: collection [
	"collection addAll: self outgoingCalls."
	self outgoingCalls do: [:c |
		(collection anySatisfy: [:v | v == c ] )
			ifFalse: [ collection add: c. 
						 c allOutgoingCallsRunning: collection
						 "collection addAll: (c allOutgoingCallsRunning: collection)" ] ].

]

{ #category : #delegation }
MethodSpy >> at: v [
	^ originalMethod at: v
]

{ #category : #hooks }
MethodSpy >> beforeRun: methodName with: listOfArguments in: receiver [

]

{ #category : #action }
MethodSpy >> browse [
	Smalltalk tools browser fullOnClass: self compiledMethod methodClass selector: self compiledMethod  selector

]

{ #category : #action }
MethodSpy >> browseOverriding [
	"Open a browser on one of the overriding method."

	| methods index |
	
	methods := self overridingMethods.
	methods ifEmpty: [ ^ self ].
	index := UIManager default chooseFrom: (methods collect: #asString).

	index isZero ifTrue: [ ^ self ].
	(methods at: index) browse.  
]

{ #category : #'accessing-computed' }
MethodSpy >> callerClasses [
	"really slow method"
	| sender callers |
	sender := thisContext sender sender sender.
	callers := OrderedCollection new.
	[sender notNil] whileTrue: [ callers add: sender methodClass. sender := sender sender.].
	^ callers
]

{ #category : #'accessing-computed' }
MethodSpy >> callingMethod [
	| t cls |
	"t := thisContext sender sender sender sender."
	t := thisContext sender.
	
	[ t methodClass == MethodSpy or: [ t methodClass inheritsFrom: MethodSpy ] ]
		whileTrue: [ t := t sender ].
	t := t sender.

	cls := t method methodClass.
	^ (cls methodDict includesKey: t selector) 
			ifTrue: [ t method methodClass >> t selector ]
			ifFalse: [ MethodSpy class >> #notIdentifiedMethod ]
]

{ #category : #'accessing-computed' }
MethodSpy >> callingMethodIndirect [
	"Useful if you want to call this method from somewhereelse than the run:with:in: or beforeRun:with:in:"
	| t |
	t := thisContext sender sender sender sender sender.
	(t method methodClass methodDict includesKey: t selector) ifFalse: [  ^ nil ].
	^ t method methodClass >> t selector

]

{ #category : #contract }
MethodSpy >> checkInvariant [
	self assert: [ selector notNil ].
	self assert: [ selector isKindOf: Symbol ].
	self assert: [ originalMethod isKindOf: CompiledMethod ].

	self assert: [ self profiler notNil ].

	self assert: [ self classSpy notNil ].
	self assert: [ self classSpy profiler == self profiler ].
	self assert: [ self classSpy profiler notNil ].	
	self assert: [ self classSpy profiler isKindOf: Profiler ].	

]

{ #category : #accessing }
MethodSpy >> classSpy [
	^ classSpy
]

{ #category : #accessing }
MethodSpy >> classSpy: anObject [
	classSpy := anObject
]

{ #category : #accessing }
MethodSpy >> compiledMethod [
	^ self originalMethod
]

{ #category : #utils }
MethodSpy >> createTemplateForVisualizationNamed: aSymbol [
	self class compile: aSymbol asString, String cr, 
'	| view | 
	view := MOViewRenderer new.
	self ', aSymbol asString, 'On: view.
	view open'.
	
	self class compile: aSymbol, 'On: view
	self error: ''Should define this method''
	'. 
]

{ #category : #action }
MethodSpy >> doesNotUnderstand: aMessage [
Transcript show: 'DNU: ', aMessage printString ; cr.
	^ self originalMethod perform: aMessage selector withArguments: aMessage arguments
]

{ #category : #delegation }
MethodSpy >> endPC [
	^ originalMethod endPC
]

{ #category : #accessing }
MethodSpy >> executionTime [
	^ executionTime 
	
]

{ #category : #accessing }
MethodSpy >> executionTime: v [ 
	^ executionTime  := v
	
]

{ #category : #hooks }
MethodSpy >> flushCache [
	"Tell the interpreter to remove all references to this method from its method lookup cache, if it has one.  This primitive must be called whenever a method is defined or removed.
	NOTE:  Only one of two selective flush methods needs to be used.
	Squeak 2.2 and earlier uses 119 (See Symbol flushCache).
	Squeak 2.3 and later uses 116 (See CompiledMethod flushCache)."

"	<primitive: 116>"
]

{ #category : #delegation }
MethodSpy >> getSourceFor: sel in: class [
	^ originalMethod getSourceFor: sel in: class
]

{ #category : #'accessing-computed' }
MethodSpy >> getSpyOf: callingMethod [
	"Take as argument a compiled method"
	"Return nil if none"
	| clsSpy |
	
	"We are looking for an instance side method"
	callingMethod methodClass isMeta ifFalse: [ 
		clsSpy := self profiler classAt: callingMethod methodClass name ifNone: [ ^ nil ].
		^ clsSpy >> callingMethod selector ].
	
	"We are looking for a class side method"
	" callingMethod methodClass isMeta => true"
	clsSpy := self profiler classAt: callingMethod methodClass soleInstance name ifNone: [ ^ nil ].
	^ clsSpy metaclassSpy >> callingMethod selector 
]

{ #category : #testing }
MethodSpy >> hasClassSpy [ 
	^ self classSpy notNil
]

{ #category : #testing }
MethodSpy >> hasIncomingCalls [
	incomingCalls ifNil: [ ^ false ].
	^ self incomingCalls size > 0 
]

{ #category : #testing }
MethodSpy >> hasLiteral: v [
	^ self originalMethod hasLiteral: v
]

{ #category : #delegation }
MethodSpy >> hasLiteralSuchThat: v [
	^ originalMethod hasLiteralSuchThat: v
]

{ #category : #testing }
MethodSpy >> hasNoIncomingCalls [
	^ self hasIncomingCalls not
]

{ #category : #testing }
MethodSpy >> hasOutgoingCalls [
	outgoingCalls ifNil: [ ^ false ].
	^ self outgoingCalls size > 0 
]

{ #category : #delegation }
MethodSpy >> hash [
	^ self originalMethod hash bitXor: super hash

]

{ #category : #hooks }
MethodSpy >> incomingAndOutgoingCallClass [
	^ IdentitySet
]

{ #category : #accessing }
MethodSpy >> incomingCalls [
	^ incomingCalls ifNil: [ incomingCalls := self incomingAndOutgoingCallClass new ]
]

{ #category : #delegation }
MethodSpy >> initialPC [
	^ originalMethod initialPC
]

{ #category : #'initialize-release' }
MethodSpy >> initialize [
	super initialize.
	executionTime := 0.
	outgoingCalls := nil.
	incomingCalls := nil.
]

{ #category : #installing }
MethodSpy >> install [
	"We do nothing if the method has been supressed"
	(self theClass methodDict includesKey: self selector) ifFalse: [ ^ self ].

	self assert: [ (self theClass methodDict at: self selector) isSpy not ].
	self assert: [ self originalMethod notNil ].
	self assert: [ self instrumentedMethod notNil ].
	self flushCache.
	
	"We update the original method, it may have changed since the uninstall"
	originalMethod := self theClass methodDict at: self selector.
	self theClass methodDict at: self selector put: self instrumentedMethod.
	
]

{ #category : #accessing }
MethodSpy >> instrumentedMethod [
	^ instrumentedMethod
]

{ #category : #accessing }
MethodSpy >> instrumentedMethod: aTemplateMethod [
	instrumentedMethod := aTemplateMethod
]

{ #category : #testing }
MethodSpy >> isAbstract [
	"True if the original method is abstract"

	^ self originalMethod isAbstract
]

{ #category : #delegation }
MethodSpy >> isConflict [
	^ originalMethod isConflict
]

{ #category : #testing }
MethodSpy >> isCovered [
	self subclassResponsibility
]

{ #category : #testing }
MethodSpy >> isMethodExisting [
	^ self theClass methodDict includesKey: self selector
]

{ #category : #testing }
MethodSpy >> isMethodNotExisting [
	^ self isMethodExisting not
]

{ #category : #testing }
MethodSpy >> isNotAMethodExtension [
	"True if I am a class extension"

	^ self originalMethod category first = $*
]

{ #category : #testing }
MethodSpy >> isNotMethodExtension [
	"True if I am a class extension"

	^ self originalMethod category first ~= $*
]

{ #category : #testing }
MethodSpy >> isNotQuick [
	^ self isQuick not
]

{ #category : #testing }
MethodSpy >> isRequired [
	^ self originalMethod isRequired
]

{ #category : #testing }
MethodSpy >> isRequired: marker [
	^ self originalMethod isRequired: marker
]

{ #category : #testing }
MethodSpy >> isSpy [
	^ true
]

{ #category : #testing }
MethodSpy >> isTest [
	
	^ (self asString findString: 'test' startingAt: 0 caseSensitive: true) > 0 and: [(self classSpy isTestClass )]
]

{ #category : #testing }
MethodSpy >> isUnary [
	^ self selector isUnary
]

{ #category : #delegation }
MethodSpy >> last [
	^ originalMethod last
]

{ #category : #delegation }
MethodSpy >> literalAt: v [
	^ originalMethod literalAt: v
]

{ #category : #delegation }
MethodSpy >> literals [
	^ originalMethod literals
]

{ #category : #delegation }
MethodSpy >> methodClass [
	^ originalMethod methodClass
]

{ #category : #testing }
MethodSpy >> notCovered [
	^ self isCovered not
]

{ #category : #'accessing-computed' }
MethodSpy >> numberOfCalls [
	^ originalMethod messages size
]

{ #category : #'accessing-computed' }
MethodSpy >> numberOfLinesOfCode [
	^ originalMethod  numberOfLinesOfCode

]

{ #category : #delegation }
MethodSpy >> objectForDataStream: v [
	^ originalMethod objectForDataStream: v
]

{ #category : #accessing }
MethodSpy >> originalMethod [
	originalMethod isSpy ifTrue: [ ^ originalMethod originalMethod ].
	^ originalMethod
]

{ #category : #accessing }
MethodSpy >> originalMethod: aCompiledMethod [
	self assert: [ aCompiledMethod isSpy not ].
	originalMethod := aCompiledMethod 
]

{ #category : #accessing }
MethodSpy >> outgoingCalls [
	^ outgoingCalls ifNil: [ outgoingCalls := self incomingAndOutgoingCallClass new ]
]

{ #category : #'accessing-computed' }
MethodSpy >> overridingMethods [
	"Return the list of overriding methods"

	^ self classSpy allSubclasses
		select: [ :cls | cls hasMethodNamed: self selector ]
		thenCollect: [ :cls | cls >> self selector ]
]

{ #category : #'accessing-computed' }
MethodSpy >> package [
	^ self classSpy packageSpy
]

{ #category : #delegation }
MethodSpy >> pragmas [
	^ originalMethod pragmas
]

{ #category : #printing }
MethodSpy >> printOn: stream [
	stream nextPut: $<.
	self classSpy ifNotNil:[ stream nextPutAll: (self theClass name asString).].
	stream nextPutAll: ('>>').
	self selector ifNotNil:[stream nextPutAll: (self selector asString).].
	stream nextPut: $>
]

{ #category : #'accessing-computed' }
MethodSpy >> profiler [
	self package ifNil: [ ^ nil ].
	^ self package profiler
]

{ #category : #delegation }
MethodSpy >> readDataFrom: v1 size: v2 [
	^ originalMethod readDataFrom: v1 size: v2
]

{ #category : #delegation }
MethodSpy >> refersToLiteral: v [
	^ originalMethod refersToLiteral: v
]

{ #category : #hooks }
MethodSpy >> returnValue: value [
]

{ #category : #hooks }
MethodSpy >> run: methodName with: listOfArguments in: receiver [
	| v |

	self beforeRun: methodName with: listOfArguments in: receiver.
	self classSpy ifNotNil: [
		classSpy beforeEachExecution: methodName On: receiver with: listOfArguments ].
	
	v := originalMethod valueWithReceiver: receiver arguments: listOfArguments.
	self afterRun: methodName with: listOfArguments in: receiver.

	self classSpy ifNotNil: [ 
		classSpy afterEachExecution: methodName On: receiver with: listOfArguments ].
	self returnValue: v.

	^ v
]

{ #category : #accessing }
MethodSpy >> selector [
	^ selector
]

{ #category : #hooks }
MethodSpy >> selector: sel [
	selector := sel
]

{ #category : #action }
MethodSpy >> setIncomingAndOutgoing [
	"Set the calling and called methods properly. CAUTION:this method has to be called only within run:with:in: or beforeRun:with:in:"
	
	| callingMethod spyCallingMethod|
	callingMethod := self callingMethodIndirect.
	(callingMethod notNil and: [  callingMethod isSpy ])
	 ifTrue: 
		[ spyCallingMethod := self getSpyOf: callingMethod.
		  spyCallingMethod ifNotNil: 
			[ self addIncomingCalls: spyCallingMethod.
		 	  spyCallingMethod addOutgoingCalls: self ] ].
]

{ #category : #'accessing-computed' }
MethodSpy >> sourceCode [
	^ originalMethod getSourceFromFile 
]

{ #category : #delegation }
MethodSpy >> sourcePointer [
	^ originalMethod sourcePointer
]

{ #category : #accessing }
MethodSpy >> staticOutgoingCallsToSelf [
	^ staticOutgoingCalls ifNil: [ staticOutgoingCalls := OrderedCollection new ]
]

{ #category : #delegation }
MethodSpy >> storeDataOn: v [
	^ originalMethod storeDataOn: v
]

{ #category : #delegation }
MethodSpy >> storeOn: s [
	^ originalMethod storeOn: s
]

{ #category : #delegation }
MethodSpy >> theClass [
	^ originalMethod methodClass
]

{ #category : #installing }
MethodSpy >> uninstall [

	self theClass methodDict at: self selector put: self originalMethod.
	self flushCache
]

{ #category : #utils }
MethodSpy >> useTime: aTally parents: parents [

	aTally time ifNil: [ ^ self ].
	
	executionTime := aTally time.
	
]

{ #category : #delegation }
MethodSpy >> veryDeepCopyWith: v [
	^ originalMethod veryDeepCopyWith: v
]

{ #category : #'accessing-computed' }
MethodSpy >> withAllOutgoingCalls [
	| answer |
	answer := OrderedCollection new.
	answer add: self.
	self allOutgoingCallsRunning: answer.
	^ answer
]
