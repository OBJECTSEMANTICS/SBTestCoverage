Class {
	#name : #SBInstrumentor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'blocks',
		'id'
	],
	#category : #'SBTestCoverage-Core'
}

{ #category : #accessing }
SBInstrumentor >> blocks [ 	
	^ blocks
]

{ #category : #'as yet unclassified' }
SBInstrumentor >> buildLTBlockNode: aBlockNode [
	|node|
	node := SBBlockNode new.
	node id: id.
	node bodySource: aBlockNode formattedCode.
	(aBlockNode parent isNil not and:[ aBlockNode parent isMessage]) ifTrue:[
		|message|	
		message := aBlockNode parent.
		(message receiver = aBlockNode) 
			ifTrue:[ node receiver: true.]
			ifFalse:[
				((message arguments anySatisfy:#isBlock) and:[  message arguments size= message selectorParts size]) ifTrue:[
					node argument: true.
					(message arguments) with: (message selectorParts) do:[ :arg :sp|
						(arg = aBlockNode) ifTrue:[ node selectorPart: sp value].].
				].
		].
		node selector: message selector.
	].
	^ node.
]

{ #category : #initialization }
SBInstrumentor >> initialize [
	super initialize.
	id := 0.
	blocks := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
SBInstrumentor >> instrumentBlock: aBlockNode [
	|ghost  instrumentBlock|
	instrumentBlock := self buildLTBlockNode: aBlockNode.
	ghost := RBParser parseExpression: '#metaObject count: ',id asString,'.nil.'.
	id := id + 1.
	aBlockNode body addNodeFirst: ghost.
	^ instrumentBlock.
]

{ #category : #visiting }
SBInstrumentor >> visitBlockNode: aBlockNode [
	self visitArgumentNodes: aBlockNode arguments.
	blocks add: (self instrumentBlock: aBlockNode).
	self visitNode: aBlockNode body.
]
