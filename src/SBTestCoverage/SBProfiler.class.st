Class {
	#name : #SBProfiler,
	#superclass : #S2Profiler,
	#category : #'SBTestCoverage-Core'
}

{ #category : #hooks }
SBProfiler class >> spyClassForPackage [ 
	^ SBPackage 
]

{ #category : #profiling }
SBProfiler >> profile: aBlock onPackagesMatching: regex [

	[ 	self startOnPackagesMatching: regex.
		aBlock value.
		"self afterProfiling." "Not implemented"
		self allMethods do:#installGhosts.
		"self beforeProfiling." "Not implementd"
		aBlock value.
		"self afterProfiling."
		"(S2Instrumentator onPackagesMatching: regex) classes.
		self removeFromPackagesMatching: regex.	"
		
	 ] ensure: [ self stop.
	self allMethods do:#uninstall.
		"profiler allMethods do:#uninstall."
		"self removeFromPackagesMatching: regex" ].
]
