Extension { #name : #Number }

{ #category : #'*spycore' }
Number >> asTruncFloat [
	^ (((self * 100) truncated) / 100 ) asFloat
]
