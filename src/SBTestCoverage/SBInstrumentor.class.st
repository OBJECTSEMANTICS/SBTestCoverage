Class {
	#name : #SBInstrumentor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'blocks'
	],
	#category : #'SBTestCoverage-Core'
}

{ #category : #visiting }
SBInstrumentor >> addBlock: aBlockNode [
	blocks add: (self buildSBBlock: aBlockNode)
]

{ #category : #accessing }
SBInstrumentor >> blocks [ 	
	^ blocks
]

{ #category : #visiting }
SBInstrumentor >> buildGhostNode: anInteger [
	^ RBParser parseExpression: '#metaObject count: ' , anInteger asString , '.nil.'.
]

{ #category : #visiting }
SBInstrumentor >> buildSBBlock: aBlockNode [
	^ SBBlock new
		id: (self nextId);
		numberOfStatements: aBlockNode body statements size;
		yourself
]

{ #category : #initialization }
SBInstrumentor >> initialize [
	super initialize.
	blocks := OrderedCollection new.
]

{ #category : #visiting }
SBInstrumentor >> instrumentBlock: aBlockNode [
	self addBlock: aBlockNode.
	aBlockNode body addNodeFirst: (self buildGhostNode: self nextId)
]

{ #category : #visiting }
SBInstrumentor >> nextId [
	^ blocks size + 1.
]

{ #category : #visiting }
SBInstrumentor >> visitBlockNode: aBlockNode [
	self instrumentBlock: aBlockNode.
	super visitBlockNode: aBlockNode
]

{ #category : #visiting }
SBInstrumentor >> visitMethodNode: aMethodNode [
	self instrumentBlock: aMethodNode.
	super visitMethodNode: aMethodNode
]
