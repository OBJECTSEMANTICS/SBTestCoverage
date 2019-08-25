Extension { #name : #BlockClosure }

{ #category : #'*spycore' }
BlockClosure >> getNumberOfGC [
	^ SmalltalkImage current vm fullGCCount 
]

{ #category : #'*spycore' }
BlockClosure >> numberOfGC [
	"Number of times the garbage collection has been fully activated"
	| v |
	v := self getNumberOfGC.
	self value.
	^ self getNumberOfGC - v
]
