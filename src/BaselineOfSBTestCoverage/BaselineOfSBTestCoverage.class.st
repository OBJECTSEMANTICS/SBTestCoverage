Class {
	#name : #BaselineOfSBTestCoverage,
	#superclass : #BaselineOf,
	#category : #BaselineOfSBTestCoverage
}

{ #category : #baselines }
BaselineOfSBTestCoverage >> baseline: spec [
	 <baseline>
	 spec for: #common do: [ 
		 spec
			 baseline: 'Spy2'
			 with: [ spec repository: 'github://ObjectProfile/Spy2:v1.0/src' ].
		 spec
			 package: 'SBTCExamples';
			 package: 'SBTestCoverage' with: [ spec requires: 'Spy2' ];
			 package: 'SBTestCoverage-Tests'
			 with: [ spec requires: 'SBTestCoverage' ] ]
]
