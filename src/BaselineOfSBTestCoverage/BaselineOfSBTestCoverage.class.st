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
		with: [ spec repository: 'github://ObjectProfile/Spy2/src' ].
		
		spec 
		package: 'SBTestCoverage-Examples';
		package: 'SBTestCoverage' with: [ spec requires: 'Spy2' ];
		package: 'SBTestCoverage-Tests' with: [ spec requires: 'SBTestCoverage' ]
	]
]
