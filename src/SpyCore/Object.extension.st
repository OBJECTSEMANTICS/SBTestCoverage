Extension { #name : #Object }

{ #category : #'*spycore' }
Object >> receiverVariableSnapshots [
	"Return an array of the variables's snapshots"

	| index value answer |
	index := self class instSize.
	answer := Array new: self class instSize.
	[ index > 0 ]
		whileTrue: 
			[ answer at: index put:  (self instVarAt: index) snapshotAsInteger.
			  index := index - 1].
	^ answer

]

{ #category : #'*spycore' }
Object >> snapshotAsInteger [
	| index value |
	index := self class instSize.
	value := self identityHash.
	[index > 0]
		whileTrue: 
			[ value := value bitXor: (self instVarAt: index) identityHash.
			  index := index - 1].
	^ value

]
