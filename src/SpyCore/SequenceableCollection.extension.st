Extension { #name : #SequenceableCollection }

{ #category : #'*spycore' }
SequenceableCollection >> snapshotAsInteger [ 
	| value |
	value := 0.
	self do: [:v | value := value bitXor: v snapshotAsInteger ].
	^ value
"	^( value \\ 4096) + 1"
]
