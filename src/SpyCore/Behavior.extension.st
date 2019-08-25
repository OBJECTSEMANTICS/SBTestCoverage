Extension { #name : #Behavior }

{ #category : #'*spycore' }
Behavior >> classSpy [ 
	| spys |
	spys := self spys.
	spys ifEmpty: [ self error: 'no spy installed'. ^ self].
	^ self spys first classSpy
]

{ #category : #'*spycore' }
Behavior >> hasSpy [
	^ self methodDict values anySatisfy: [ :spy | spy isTemplateMethod ]
]

{ #category : #'*spycore' }
Behavior >> profiler [
	^ self classSpy profiler
]

{ #category : #'*spycore' }
Behavior >> removeSpys [
	| v |
	(self == Profiler class) ifTrue: [ ^ self ].
	
	self isMeta ifFalse: [ self class removeSpys ].
	self methodDict keys do: 
		[ :k | 
		v := self methodDict at: k.
		v isSpy ifTrue: 
			[ self methodDict 
				at: k
				put: v originalMethod ] ]
]

{ #category : #'*spycore' }
Behavior >> spyFor: aSelector [
	| v |
	v := self methodDict at: aSelector.
	self assert: [ v isSpy ].
	^ v
]

{ #category : #'*spycore' }
Behavior >> spys [
	^ (self methodDict values select: [ :spy | spy isTemplateMethod ]) collect: #methodSpy
]
