Class {
	#name : #BaselineOfSBTestCoverage,
	#superclass : #BaselineOf,
	#category : #BaselineOfSBTestCoverage
}

{ #category : #baselines }
BaselineOfSBTestCoverage >> baseline: spec [ 
	<baseline>
	spec for: #common 
	do: [ 
		spec baseline: 'Spy2'
		with: [ spec repository: 'https://github.com/ObjectProfile/Spy2/src' ].
		
		spec 
		package: 'SBTestCoverage-Examples';
		package: 'SBTestCoverage-Core' with: [ spec requires: #('Spy2') ]
	]
]
