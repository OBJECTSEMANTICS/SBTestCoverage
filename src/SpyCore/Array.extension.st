Extension { #name : #Array }

{ #category : #'*spycore' }
Array >> listHash [ 
	| value |
	value := 0.
	self do: [:v | value := value bitXor: v identityHash ].
	^( value \\ 4096) + 1
]
