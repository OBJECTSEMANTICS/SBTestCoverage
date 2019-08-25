"
I am a superclass to Profiler, PackageSpy, ClassSpy and MethodSpy.

"
Class {
	#name : #Spy,
	#superclass : #Object,
	#classInstVars : [
		'currentTestCase',
		'currentTestMethod',
		'currentTestMethodSpy'
	],
	#category : #SpyCore
}

{ #category : #util }
Spy class >> generate: profilerName [
	"Public method to create a new profiler"
	
	^ self generate: profilerName category: profilerName asString
]

{ #category : #util }
Spy class >> generate: profilerName category: aCategory [
	| profiler methodSpy classSpy packageSpy test |
	self assert: [ profilerName first isUppercase ].
	self assert: [ aCategory notEmpty ].
	
	profiler := Profiler subclass: profilerName asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		category: aCategory.
		
	methodSpy := MethodSpy subclass: (profilerName, 'Method') asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		category: aCategory.
	
	classSpy := ClassSpy subclass: (profilerName, 'Class') asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		category: aCategory.

	packageSpy := PackageSpy subclass: (profilerName, 'Package') asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		category: aCategory.
		
	profiler class compile: 'spyClassForPackage', String cr, String tab, ' ^ ', packageSpy name classified: 'hooks'.
	packageSpy class compile: 'spyClassForClass', String cr, String tab, ' ^ ', classSpy name classified: 'hooks'.
	classSpy class compile: 'spyClassForMethod', String cr, String tab, ' ^ ', methodSpy name classified: 'hooks'.
	methodSpy compile: 'beforeRun: methodName with: listOfArguments in: receiver
	"This method is executed before each method of the profiled application.
	 Insert here the instrumentation you would like to perform during the profiling."' classified: 'hooks'.
	profiler compile: 'registryName', String cr, String tab, '^ #', profilerName classified: 'hooks'. 
	
	test := AbstractSpyTest subclass: (profilerName, 'Test') asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		category: aCategory.
	test compile: 'profilerClass', String cr, String tab,  '^  ', profilerName asSymbol classified: 'hooks'.

	self generateVisualizationTemplateOn: profiler
]

{ #category : #util }
Spy class >> generateVisualizationTemplateOn: profilerClass [
	profilerClass compile: 'visualizeOn: view
	"This is a generated visualization"
	
	self setInteractionForClassSpyOn: view.
	view nodes: self allClasses forEach: [ :each | 
		self setInteractionForMethodSpyOn: view.
		view nodes: each methods.
		view gridLayout gapSize: 2.
	].
	view edgesFrom: #superclass.
	view treeLayout
	' classified: 'visualization'
]

{ #category : #visualization }
Spy >> visualizeOn: view [
	self subclassResponsibility
]
