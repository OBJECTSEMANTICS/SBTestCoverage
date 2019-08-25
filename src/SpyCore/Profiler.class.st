"
I obtain runtime information by profiling the execution of a block of Smalltalk code.

I offer a number of public class methods to interface with the profiling.

profile: aBlock inPackagesNamed: packageNames accepts as first parameter a block and as second parameter a collection of package names.

The effect of calling this method is to
(i) instrument the specified packages;
(ii) execute the provided block;
(iii) uninstrument the targeted packages; and
(iv) return the collected data in the form of an instance of the Profiler class which contains instances of PackageSpy, ClassSpy and MethodSpy, essentially mirroring the structure of the program.
"
Class {
	#name : #Profiler,
	#superclass : #Spy,
	#instVars : [
		'packages',
		'totalExecutionTime',
		'allClassesAsDictionaryCache',
		'allMethodsCache',
		'counter',
		'unitTestResult',
		'packagesToTest',
		'allNonAbstractMethodsCache'
	],
	#category : #SpyCore
}

{ #category : #gathering }
Profiler class >> allSpysForPackagesMatching: regexpAsString [
	"
	self allSpysForPackagesMatching: 'Mondrian*'.
	"
	| classes answer |
	classes := self classesForPackagesMatching: regexpAsString.
	answer := OrderedCollection new.
	classes do: [:cls | answer addAll: (cls methods select: #isSpy)].
	^ answer
]

{ #category : #'public - benchmark' }
Profiler class >> benchmarkForPackageNamed: nameAsString [
	"Run twice all the test of the package specified as argument. The first time without instrumentation, and the second time with"

	| classes sunitClasses overhead times2 times1 result |
	classes := (RPackageSet"PackageInfo" named: nameAsString) classesAndMetaClasses.
	sunitClasses := classes select: [ :cls | cls inheritsFrom: TestCase ].
	times1 := Time
		millisecondsToRun: [ sunitClasses do: [ :cls | cls buildSuite run ] ].
	self installOnPackageNamed: nameAsString.
	times2 := Time
		millisecondsToRun: [ sunitClasses do: [ :cls | cls buildSuite run ] ].
	self removeFromPackageNamed: nameAsString.
	overhead := ((times2 - times1) * 100) asFloat / times1.
	result := 'Time without profiling: ' , times1 printString , '     '
		, 'Time with profiling: ' , times2 printString , '     '
		, 'Overhead = ' , overhead printString.
	Transcript
		show: result;
		cr.
	self inform: result.
	^ result
]

{ #category : #'public - benchmark' }
Profiler class >> benchmarkForPackagesMatching: regexpAsString [
	"Run twice all the test of the package specified as argument. The first time without instrumentation, and the second time with"
	
	
	| classes sunitClasses overhead times2 times1 result |
	classes := self classesForPackagesMatching: regexpAsString.
	sunitClasses := classes select: [:cls | cls inheritsFrom: TestCase ].
	
	times1 := Time millisecondsToRun: [ sunitClasses do: [:cls | cls buildSuite run ] ].
	
	self installOnPackagesMatching: regexpAsString.	
	times2 := Time millisecondsToRun: [ sunitClasses do: [:cls | cls buildSuite run ] ].
	self removeFromPackagesMatching: regexpAsString.	
		
	overhead := (times2 - times1 * 100) asFloat / times1.
	result := 'Time without profiling: ', times1 printString, '     ',
		'Time with profiling: ', times2 printString, '     ',
		'Overhead = ', overhead printString.

	Transcript show: result; cr.
	self inform: result.
	^ result
]

{ #category : #gathering }
Profiler class >> classesForPackagesMatching: regexpAsString [
	"Return the list of classes defines in the packages matching one of the regular expressions"
	"Traits are excluded"

	| packages classes |
	packages := (RPackageOrganizer default packages select: [:p | regexpAsString match: p name asString ]).
	classes := packages inject: #() 
						into: [:sum :el | sum, (el classes reject: #isTrait) asOrderedCollection ].
	^ classes
]

{ #category : #util }
Profiler class >> classesForPackagesNamed: packageNames [
	"Return the list of classes contained in the packages named as the argument"

	| packages classes |
	packages := self packageInfoFromNames: packageNames.
	classes := packages inject: #() 
						into: [:sum :el | sum, (el classesAndMetaClasses reject: #isTrait) asArray ].
						
	^ classes
]

{ #category : #util }
Profiler class >> currentTestCase [ 
	^ currentTestCase


]

{ #category : #util }
Profiler class >> currentTestCase: aTestCase [
	^ currentTestCase := aTestCase

]

{ #category : #util }
Profiler class >> currentTestMethod [ 
	^ currentTestMethod


]

{ #category : #util }
Profiler class >> currentTestMethod: aSelector [ 
	^ currentTestMethod := aSelector


]

{ #category : #util }
Profiler class >> currentTestMethodSpy: aSelector [ 
	^ currentTestMethodSpy := aSelector


]

{ #category : #hooks }
Profiler class >> defaultRun [
	"Tell on what the profiler has to be run per default"
	^ #package 
]

{ #category : #'public - profiling' }
Profiler class >> evaluateBlock: aBlock [
	aBlock value.
]

{ #category : #'public - installing removing' }
Profiler class >> forClass: aClass [
	| profiler classSpy packageSpy |
	self installOnClass: aClass.
	profiler := self new.
	classSpy := profiler spyForClass: aClass.
	packageSpy := self spyClassForPackage new.
	packageSpy classAt: aClass name put: classSpy.
	classSpy packageSpy:  packageSpy.
	packageSpy packageName: 'Smalltalk'.
	profiler addPackage: packageSpy.
	
	^ profiler
]

{ #category : #gathering }
Profiler class >> gather [

	^ self new gather
]

{ #category : #gathering }
Profiler class >> gatherForClassCategory: nameAsString [
	"Return a profiler"
	^ self new gatherForClassCategory: nameAsString 
]

{ #category : #gathering }
Profiler class >> gatherForPackageNamed: nameAsString [
	"Return a profiler"
	
	^ self new gatherForPackageNamed: nameAsString 
]

{ #category : #gathering }
Profiler class >> gatherForPackagesMatching: regexpAsString [
	"Return a profiler"
	
	^ self new gatherForPackagesMatching: regexpAsString
]

{ #category : #gathering }
Profiler class >> gatherForSeveralPackagesMatching: collectionOfRegExp [
	"Return a profiler"
	
	^ self new gatherForSeveralPackagesMatching: collectionOfRegExp
]

{ #category : #'private - method template' }
Profiler class >> generateTemplates [
	"
	self generateTemplates
	"
	| argString parameterString |
	self class compileSilently: 'with0Arg ', String cr, (self templateCode expandMacrosWith: '#()') classified: 'private - method template'.
	1 to: 15 do: [ :i |
		parameterString := ''.
		argString := '{'.
		1 to: i do: [ :ii | 
			parameterString := parameterString, 'arg: ', 'v', ii printString, ' '.
			argString := argString, 'v', ii printString, '.'].
		
		argString := argString allButLast, '}'.

		self class 
				compile: 'with', i printString, parameterString, String cr, (self templateCode expandMacrosWith: argString)
				classified: 'private - method template'.
	]
]

{ #category : #'private - installing' }
Profiler class >> install [
	" Install on all classes"
	self installOnClasses: Smalltalk allClasses
]

{ #category : #'private - installing' }
Profiler class >> installOnBehavior: aBehavior [
	| dict cm templateMethod metaObject |
	aBehavior flushCache.

	"We do nothing for traits"
	aBehavior isTrait
		ifTrue: [ ^ self ].
	dict := aBehavior methodDict.
	dict keys
		do: [ :k | 
			k flushCache.
			cm := dict at: k.
			cm isSpy
				ifFalse: [ "Using template method"
					"Using method wrapper"
					"			(cm isCompiledMethod and: [ self shouldInstallOnCompiledMethod: cm])
			 	ifTrue: [dict at: k put: (self spyClassForMethod new originalMethod: cm; selector: k; yourself)]
"
					templateMethod := self templateMethodForNumberOfArguments: cm numArgs.
					templateMethod := templateMethod copyFor: aBehavior.
					metaObject := self spyClassForMethod new
						originalMethod: cm;
						selector: k;
						instrumentedMethod: templateMethod;
						yourself.
					templateMethod
						replaceLiterals:
							{(templateMethod selector -> k).
							(#metaObject -> metaObject).
							(#selector -> k)}.
					dict at: k put: templateMethod ] ]
]

{ #category : #'private - installing' }
Profiler class >> installOnClass: aClass [
	"Transcript show: 'instrumenting ', aClass name printString ;cr."

	(self isDangerous: aClass instanceSide)
		ifTrue: [ ^ self ].
	self
		installOnBehavior: aClass instanceSide;
		installOnBehavior: aClass classSide.
	^ self new spyForClass: aClass
]

{ #category : #'private - installing' }
Profiler class >> installOnClassCategory: nameAsString [
	| classNames classesAndTraits classes |
	classNames := SystemOrganization listAtCategoryNamed: nameAsString.
	classesAndTraits := classNames collect: [:clsName | Smalltalk at: clsName].
	classes := classesAndTraits reject: #isTrait.

	self installOnClasses: classes
]

{ #category : #'private - installing' }
Profiler class >> installOnClassCategoryMatching: regexpAsString [
	(SystemOrganization categoriesMatching: regexpAsString)
		do: [:cat | self installOnClassCategory: cat]
]

{ #category : #'private - installing' }
Profiler class >> installOnClasses: classes [
	classes do: [:cls | self installOnClass: cls ].

]

{ #category : #'private - installing' }
Profiler class >> installOnPackageNamed: nameAsString [
	| classes |
	classes := (RPackageSet "PackageInfo" named: nameAsString) classes.
	classes := classes reject: #isTrait.
	classes
		do: [ :cls | 
			self assert: [ cls hasSpy not ].
			self installOnClass: cls theNonMetaClass ]
]

{ #category : #'private - installing' }
Profiler class >> installOnPackagesMatching: regexpAsString [

	| classes |
	classes := self classesForPackagesMatching: regexpAsString.
	classes do: [:cls | self installOnClass: cls ]
]

{ #category : #'private - installing' }
Profiler class >> installOnPackagesNamed: strings [
	| classes |
	self
		assert: [ strings isString not ]
		description: 'A collection of String must be passed to #installOnPackagesNamed:'.
	self
		assert: [ strings allSatisfy: #isString ]
		description: 'A collection of String must be passed to #installOnPackagesNamed:'.
	strings
		do: [ :packageName | 
			classes := (RPackageSet "PackageInfo" named: packageName) classes.
			classes := classes reject: #isTrait.
			classes do: [ :cls | self installOnClass: cls theNonMetaClass ] ]
]

{ #category : #util }
Profiler class >> isDangerous: aClass [
	| isDangerous |
	self
		assert: [ aClass instanceSide == aClass ]
		description: 'Can only be called on non meta class'.
	"	(aClass inheritsFrom: Spy) ifTrue: [ ^ true ].
	true ifTrue: [ ^ false ].	"

	"Cannot instrument a configuration"
	(aClass name beginsWith: 'ConfigurationOf')
		ifTrue: [ ^ true ].

	"Can instrument the scenario example, even it belongs to Spy"
	(aClass category beginsWith: 'Spy-ScenarioExample')
		ifTrue: [ ^ false ].

	"	({ByteSymbol . String . Symbol . MethodReference . MorphicToolBuilder} includes: aClass)
		ifTrue: [ ^ true ]."
	(#('Spy-Core' 'Announcements' 'Balloon' 'Collections' 'CollectionsTests' 'Compiler' 'CompilerTests' 'Compression' 'DeprecatedPreferences' 'Exceptions' 'Files' 'FixUnderscores' 'FreeType' 'FreeTypeSubPixelAntiAliasing' 'FreeTypeTests' 'Gofer' 'Graphics' 'GraphicsTests' 'HostMenus' 'Kernel' 'KernelTests' 'MCDirtyPackage' 'MenuRegistration' 'Monticello' 'MonticelloConfigurations' 'MonticelloGUI' 'MonticelloMocks' 'Morphic' 'MorphicTests' 'Multilingual' 'MultilingualTests' 'ObjectMetaTools' 'PackageInfo' 'PinesoftEnhancementsForFreetype' 'Polymorph' 'PreferenceBrowser' 'ST80' 'SUnit' 'SUnitGUI' 'ScriptLoader' 'ScriptLoader11' 'Settings' 'System' 'Tests' 'ToolBuilder' 'Tools' 'ToolsTest' 'Traits' 'TrueType' 'VB')
		anySatisfy: [ :cat | aClass category beginsWith: cat ])
		ifTrue: [ ^ true ].
	"'Network' 'NetworkTests' "
	^ false
	"	^ aClass isCollection
		or: [ ((Smalltalk specialObjectsArray select: #isBehavior) includes: aClass) ]
"
]

{ #category : #util }
Profiler class >> isNotDangerous: aClass [
	^ (self isDangerous: aClass) not
]

{ #category : #util }
Profiler class >> log: aString [
	Transcript show: 'Running: ', aString asString; cr.
]

{ #category : #util }
Profiler class >> nonDangerousClasses [
	^ Smalltalk allClasses select: [:cls | Profiler isNotDangerous: cls ]
]

{ #category : #util }
Profiler class >> packageInfoFromNames: packageNames [
	"Return the list of the package info corresponding to the list of packages names (as strings)"

	^ packageNames collect: [ :na | RPackageSet"PackageInfo" named: na ]
]

{ #category : #util }
Profiler class >> packageInfosMatching: regexpAsString [
	"Return the list of package info for which their names match the argument
	
	Profiler packageInfosMatching: 'Kernel*'
	"
	
	^ MCWorkingCopy allManagers  select: [:p | regexpAsString match: p package name]
]

{ #category : #util }
Profiler class >> packageNamesMatching: regexpAsString [
	"Return the list of package names for which their names match the argument
	
	Profiler packageNamesMatching: 'Kern*'
	"
	
	^ (self packageInfosMatching: regexpAsString) collect: #packageName
]

{ #category : #'public - profiling' }
Profiler class >> profile: aBlock [

	| profiler messageTally tally |
	self 
		assert: [ self new getTimeAndCallGraph ] 
		description: 'profile: can be invoked only if getTimeAndCallGraph return true'.
	
	profiler := self new.
	'Profiling' displayProgressAt: Display center from:1 to: 5 during: [:bar |
		bar value: 1.
		tally := (profiler tallyOn: aBlock).
		Smalltalk garbageCollect.
		[  bar value: 2.
			"self installOnClasses: tally allInvolvedClasses."
			self installOnPackagesNamed: tally allInvolvedPackageNames.
			profiler beforeProfiling.
			bar value: 3.
			aBlock value.

			bar value: 4.
			profiler gatherForPackagesNamed: tally allInvolvedPackageNames.
			profiler afterProfiling ]
		ensure: [ self removeFromPackagesNamed:  tally allInvolvedPackageNames ].

		bar value: 5.
		profiler setTimeInfoFromTally: tally.
		tally close ].

	^ profiler
]

{ #category : #'public - profiling' }
Profiler class >> profile: aBlock forClassNamed: className [
	| messageTally profiler packageSpy cls classSpy packageName |
	cls := Smalltalk at: className.
	profiler := self new.
	Transcript
		show: 'profiling...';
		cr.
	[ self installOnClass: cls.
	
	profiler beforeProfiling.
	classSpy := profiler spyForClass: cls.
	packageSpy := self spyClassForPackage new.
	packageSpy classAt: className put: classSpy.
	classSpy packageSpy: packageSpy.
	profiler addPackage: packageSpy.
	aBlock value.
	profiler afterProfiling ]
		ensure: [ self removeFromClass: cls ].
	Transcript
		show: 'ended...';
		cr.
	^ profiler
]

{ #category : #'public - profiling' }
Profiler class >> profile: aBlock inClassCategory: classCategory [

	| profiler messageTally tally |
	
	Transcript show: 'profiling...'; cr.
	profiler := self new.
	[
		self installOnClassCategory: classCategory.
		profiler beforeProfiling.
		profiler := self gatherForClassCategory: classCategory.
		self evaluateBlock: aBlock.
		profiler afterProfiling ]
	ensure: [ self removeFromClassCategory: classCategory ].
	Transcript show: 'ended...'; cr.
	profiler setIfNecessaryTimeAndCallGraphFrom: aBlock.
	profiler checkInvariant.
	^ profiler
]

{ #category : #'public - profiling' }
Profiler class >> profile: aBlock inPackage: packageName [

	| messageTally tally profiler packageSpy |
	Transcript show: 'profiling...'; cr.
	[
		self installOnPackageNamed: packageName.
		profiler := self gatherForPackageNamed: packageName.
		profiler beforeProfiling.
		aBlock value.
		profiler afterProfiling. ]
	ensure: [ self removeFromPackageNamed: packageName ].
	Transcript show: 'ended...'; cr.
	profiler setIfNecessaryTimeAndCallGraphFrom: aBlock.
	profiler checkInvariant.
	
	^ profiler
]

{ #category : #'public - profiling' }
Profiler class >> profile: aBlock inPackagesMatching: regexp [

	| profiler messageTally tally |
	
	Transcript show: 'profiling...'; cr.
	[
		self installOnPackagesMatching: regexp.
		profiler := self gatherForPackagesMatching: regexp.
		profiler beforeProfiling.
		aBlock value.
		
		profiler afterProfiling  ]
	ensure: [ self removeFromPackagesMatching: regexp ].
	Transcript show: 'ended...'; cr.
	profiler setIfNecessaryTimeAndCallGraphFrom: aBlock.
	profiler checkInvariant.
	^ profiler
]

{ #category : #'public - profiling' }
Profiler class >> profile: aBlock inSeveralPackagesMatching: collectionOfRegExp [

	| profiler |
	
	Transcript show: 'profiling...'; cr.
	[
		collectionOfRegExp do: [ :regexp |
			self installOnPackagesMatching: regexp ].
		
		"A bit awkward. Hopefully with Spy2 this will be removed"
		profiler := self gatherForSeveralPackagesMatching: collectionOfRegExp.
		profiler beforeProfiling.
		aBlock value.
		
		profiler afterProfiling  ]
	ensure: [ collectionOfRegExp do: [ :regexp | self removeFromPackagesMatching: regexp ] ].
	Transcript show: 'ended...'; cr.
	profiler setIfNecessaryTimeAndCallGraphFrom: aBlock.
	profiler checkInvariant.
	^ profiler
]

{ #category : #'public - profiling' }
Profiler class >> profile: aBlock onClass: cls [
^ self profile: aBlock forClassNamed: cls name
]

{ #category : #'public - profiling' }
Profiler class >> profile: aBlock onPackagesMatching: regexp [
 ^ self profile: aBlock inPackagesMatching: regexp. 
]

{ #category : #'public - profiling' }
Profiler class >> profileWithProgressBar: aBlock inPackage: packageName [

	| messageTally tally profiler packageSpy |

	('Profiling package ',packageName,'...')
		displayProgressAt: Display center
		from: 0 to: 4
		during: [:bar |
		[	bar value:0.
			self installOnPackageNamed: packageName.
			bar value:1.
			aBlock value.
			bar value:2.
			profiler := self gatherForPackageNamed: packageName ]

		ensure: [ self removeFromPackageNamed: packageName ].
		bar value:4.].
	profiler setIfNecessaryTimeAndCallGraphFrom: aBlock.
	profiler checkInvariant.
	
	^ profiler
]

{ #category : #'private - installing' }
Profiler class >> remove [
	" Install on all classes"
	self removeFromClasses: Smalltalk allClasses
]

{ #category : #'private - installing' }
Profiler class >> removeFrom: class [
	class flushCache.
	class selectors do: [:k | k flushCache ].
	class removeSpys
]

{ #category : #'private - installing' }
Profiler class >> removeFromClass: class [
	Profiler class == class ifTrue: [ ^ self ].
	^ self removeFrom: class
]

{ #category : #'private - installing' }
Profiler class >> removeFromClassCategory: nameAsString [
	| classNames classesAndTraits classes |
	classNames := SystemOrganization listAtCategoryNamed: nameAsString.
	classesAndTraits := classNames collect: [:clsName | Smalltalk at: clsName].
	classes := classesAndTraits reject: #isTrait.
	self removeFromClasses: ((classes collect: #theNonMetaClass), (classes collect: #theMetaClass))

]

{ #category : #'private - installing' }
Profiler class >> removeFromClassCategoryMatching: regexpAsString [
	(SystemOrganization categoriesMatching: regexpAsString)
		do: [:cat | self removeFromClassCategory: cat]
]

{ #category : #'private - installing' }
Profiler class >> removeFromClasses: classes [
	^ classes do: [:cls | self 
							removeFromClass: cls theNonMetaClass;
							removeFromClass: cls theMetaClass ].
]

{ #category : #'private - installing' }
Profiler class >> removeFromPackage: packageName [
	((RPackageSet"PackageInfo" named: packageName) classesAndMetaClasses
		reject: #isTrait) do: [ :cls | self removeFrom: cls ]
]

{ #category : #'private - installing' }
Profiler class >> removeFromPackageNamed: nameAsString [
	((RPackageSet "PackageInfo" named: nameAsString) classesAndMetaClasses
		reject: #isTrait)
		do: [ :cls | 
			cls ~~ Profiler class
				ifTrue: [ cls removeSpys ] ]
]

{ #category : #'private - installing' }
Profiler class >> removeFromPackagesMatching: regexpAsString [
	| classes |
	classes := self classesForPackagesMatching: regexpAsString.
	classes do: [:cls | cls removeSpys ]
	
]

{ #category : #'private - installing' }
Profiler class >> removeFromPackagesNamed: strings [
	self assert: [ strings isString not ] description: 'A collection of String must be passed to #removeFromPackagesNamed:'.
	self assert: [ (strings allSatisfy: #isString) ] description: 'A collection of must should be passed to #removeFromPackagesNamed:'.

	strings do: [ :packageName | self removeFromPackageNamed: packageName ]
	
]

{ #category : #'public - running tests' }
Profiler class >> runTestsForClassCategory: classCategory [
	
	| classes sunitClasses packages regexpAsString packageSpy profiler package testResult |

	classes := TestCase withAllSubclasses.
	sunitClasses := classes select: [:cls | cls category = classCategory ].
	profiler := self profile: [ testResult := self runningUnitTests: sunitClasses. ] inClassCategory: classCategory.
	
	profiler setIfNecessaryTimeAndCallGraphFrom: [ self runningUnitTests: sunitClasses].
	profiler checkInvariant.
	
	profiler unitTestResult: testResult.
	^ profiler
]

{ #category : #'public - running tests' }
Profiler class >> runTestsForPackageNamed: packageName [
	| classes sunitClasses packages regexpAsString packageSpy profiler testResult |
	classes := (RPackageSet"PackageInfo" named: packageName) classesAndMetaClasses.
	sunitClasses := classes select: [ :cls | cls inheritsFrom: TestCase ].
	[ self installOnPackageNamed: packageName.
	testResult := self runningUnitTests: sunitClasses.
	profiler := self gatherForPackageNamed: packageName.
	profiler unitTestResult: testResult ]
		ensure: [ self removeFromPackageNamed: packageName ].
	^ profiler
]

{ #category : #'public - running tests' }
Profiler class >> runTestsForPackages: packageNames [

	| sunitClasses profiler testResult |
	sunitClasses := self unitTestsForPackagesNamed: packageNames.

	self installOnPackagesNamed: packageNames.
	[
		profiler := self new.
		profiler gatherForPackagesNamed: packageNames.
		profiler packagesToTest: packageNames.

		profiler beforeProfiling.
		testResult := self runningUnitTests: sunitClasses.
		profiler afterProfiling.
		profiler unitTestResult:  testResult. ] 
	ensure: [ self removeFromPackagesNamed: packageNames ].	

	profiler setIfNecessaryTimeAndCallGraphFrom: [ self runningUnitTests: sunitClasses ].
	profiler checkInvariant.
	^ profiler
]

{ #category : #'public - running tests' }
Profiler class >> runTestsForPackagesMatching: regexpAsString [
	"Profile the test execution of a list of packages"

	^ self runTestsForPackages: (self packageNamesMatching: regexpAsString)

]

{ #category : #'public - running tests' }
Profiler class >> runningUnitTests: sunitClasses [
	^ self runningUnitTests: sunitClasses atEachTestEvaluate: []
]

{ #category : #'public - running tests' }
Profiler class >> runningUnitTests: sunitClasses atEachTestEvaluate: ablock [
	| ind result fileStream |
	ind := 0.
	fileStream := (FileStream forceNewFileNamed: 'doutput.txt'  ).
	result := TestResult new.
	'Running tests' 
		displayProgressFrom: 0 to: (sunitClasses size)
		during: [:bar | 
			(sunitClasses reject: #isAbstract) do: [:cls | 
				self log: 'running ', cls name printString.
				fileStream nextPutAll: 'running ', cls name printString, String cr.
				self currentTestCase: cls.
				cls buildSuite tests 
					do: [:t | 
							fileStream nextPutAll: 'test method  ', t printString, String cr.
							self currentTestMethod: t. 
							"Transcript show: result printString; cr."
							t run: result ].
				self currentTestMethod: nil.
				ind := ind + 1.
				bar value: ind ] ].
	^ result
]

{ #category : #util }
Profiler class >> shouldInstallOnClass: aClass [
	| isDangerous |
	self assert: [ aClass theNonMetaClass == aClass ] description: 'Can only be called on non meta class'.
	
	^ (self isNotDangerous: aClass)
]

{ #category : #util }
Profiler class >> shouldInstallOnCompiledMethod: compiledMethod [
	^ (compiledMethod pragmaAt: #nospy) isNil
]

{ #category : #hooks }
Profiler class >> spyClassForClass [
	^ self spyClassForPackage spyClassForClass
]

{ #category : #hooks }
Profiler class >> spyClassForMethod [
	^ self spyClassForPackage spyClassForClass spyClassForMethod
]

{ #category : #hooks }
Profiler class >> spyClassForPackage [
	^ PackageSpy
]

{ #category : #'private - method template' }
Profiler class >> templateCode [
	^ '^ #metaObject run: #selector with: <1s> in: self  '
		
"	^ '^ MethodSpy isInMeta
		ifTrue: [ #metaObject originalMethod valueWithReceiver: self arguments: <1s> ]
		ifFalse: [ #metaObject run: #selector with: <1s> in: self ] '"
]

{ #category : #'private - method template' }
Profiler class >> templateMethodForNumberOfArguments: numberOfArguments [
	^ Profiler class>> (#(
			#with0Arg
			#with1arg:
			#with2arg:arg:
			#with3arg:arg:arg:
			#with4arg:arg:arg:arg:
			#with5arg:arg:arg:arg:arg:
			#with6arg:arg:arg:arg:arg:arg:
			#with7arg:arg:arg:arg:arg:arg:arg:
			#with8arg:arg:arg:arg:arg:arg:arg:arg:
			#with9arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with10arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with11arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with12arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with13arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with14arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with15arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			) at: (numberOfArguments + 1))
]

{ #category : #'private - method template' }
Profiler class >> templateMethods [
	^ #(
			#with0Arg
			#with1arg:
			#with2arg:arg:
			#with3arg:arg:arg:
			#with4arg:arg:arg:arg:
			#with5arg:arg:arg:arg:arg:
			#with6arg:arg:arg:arg:arg:arg:
			#with7arg:arg:arg:arg:arg:arg:arg:
			#with8arg:arg:arg:arg:arg:arg:arg:arg:
			#with9arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with10arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with11arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with12arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with13arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with14arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with15arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			) collect: [:k | self class >> k ]
]

{ #category : #hooks }
Profiler class >> testMethodsToIgnore [
	"This is intended to be temporary. There are some strange bugs that are hard to track down"
	^ #(testNestingOfFormBuilder testNestedCycle)
]

{ #category : #util }
Profiler class >> unitTestsForPackagesNamed: packageNames [
	"Return the list of unit tests contained in the packages named as the argument"

	^ (self classesForPackagesNamed: packageNames) select: [:cls | cls inheritsFrom: TestCase ].
]

{ #category : #'public - profiling' }
Profiler class >> viewProfiling: aBlock [

	(self profile: aBlock) visualize 
]

{ #category : #'public - profiling' }
Profiler class >> viewProfiling: aBlock inPackage: packageName [

	(self profile: aBlock inPackage: packageName) visualize
]

{ #category : #'public - profiling' }
Profiler class >> viewProfiling: aBlock inPackagesMatching: regexp [

	(self profile: aBlock inPackagesMatching: regexp) visualize
]

{ #category : #'private - method template' }
Profiler class >> with0Arg [
	^ #metaObject
		run: #selector
		with: #()
		in: self
]

{ #category : #'private - method template' }
Profiler class >> with10arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with11arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with12arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with13arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 arg: v13 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12.v13} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with14arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 arg: v13 arg: v14 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12.v13.v14} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with15arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 arg: v13 arg: v14 arg: v15 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12.v13.v14.v15} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with1arg: v1 [ 
^ #metaObject run: #selector with: {v1} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with2arg: v1 arg: v2 [ 
^ #metaObject run: #selector with: {v1.v2} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with3arg: v1 arg: v2 arg: v3 [ 
^ #metaObject run: #selector with: {v1.v2.v3} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with4arg: v1 arg: v2 arg: v3 arg: v4 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with5arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with6arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5.v6} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with7arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5.v6.v7} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with8arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8} in: self  
]

{ #category : #'private - method template' }
Profiler class >> with9arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 [ 
^ #metaObject run: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9} in: self  
]

{ #category : #'accessing - read only' }
Profiler >> >> aSymbol [
	"Fetching a class"
	
	"we are accessing a method defined in a metaclass"
	(aSymbol includes: $ ) ifTrue: [ ^ (self >> aSymbol substrings first asSymbol) metaclassSpy ].
	
	^ self classAt: aSymbol
]

{ #category : #adding }
Profiler >> addPackage: aPackageSpy [
	self assert: [ aPackageSpy class == self class spyClassForPackage ].
	
	self packages add: aPackageSpy.
	aPackageSpy profiler: self.
]

{ #category : #hooks }
Profiler >> afterProfiling [ 

]

{ #category : #'accessing - read only' }
Profiler >> allClasses [
	| answer |
	answer := OrderedCollection new.
	self packages do: [:p | 
		answer addAll: p classes ].
	^ answer
]

{ #category : #'accessing - read only' }
Profiler >> allClassesAsDictionary [
	| answer |
	allClassesAsDictionaryCache ifNotNil: [ ^ allClassesAsDictionaryCache ].
	answer := Dictionary new.
	self packages do: [:p | p classes do: [:c | answer at: c className put: c]].
	^ allClassesAsDictionaryCache := answer
]

{ #category : #'accessing - read only' }
Profiler >> allClassesSuchThat: aBlock [
	^ self allClasses select: aBlock
]

{ #category : #'accessing - read only' }
Profiler >> allMethods [
	"Return the list of all the methods"
	
	allMethodsCache ifNotNil: [ ^ allMethodsCache ].
	
	allMethodsCache := OrderedCollection new.
	self packages do: [:p | 
		allMethodsCache addAll: p allMethods ].
	^ allMethodsCache 
]

{ #category : #'accessing - read only' }
Profiler >> allNonAbstractMethods [
	"Return the list of non abstract methods"
	
	allNonAbstractMethodsCache ifNotNil: [ ^ allNonAbstractMethodsCache ].
	^ allNonAbstractMethodsCache := self allMethods reject: #isAbstract
]

{ #category : #'accessing - read only' }
Profiler >> allNonMetaClasses [
	^ self allClasses reject: #isMeta
]

{ #category : #hooks }
Profiler >> beforeProfiling [
	MethodSpy setInNonMeta

	
]

{ #category : #contract }
Profiler >> checkInvariant [
	self assert: [ self packages notNil ].
	self assert: [ self packages allSatisfy: [ :p | p isKindOf: self class spyClassForPackage ] ].
	self assert: [ self packages allSatisfy: [ :p | p profiler notNil ]].
	self assert: [ self packages allSatisfy: [ :p | p profiler == self ]].

	self packages do: #checkInvariant.
]

{ #category : #'accessing - read only' }
Profiler >> classAt: aSymbol [
	^ self allClassesAsDictionary at: aSymbol ifAbsent: [ self error: 'Class ', aSymbol, ' not found']
]

{ #category : #'accessing - read only' }
Profiler >> classAt: aSymbol ifNone: aBlock [
	^ self allClassesAsDictionary at: aSymbol ifAbsent: aBlock
	
]

{ #category : #'accessing - read only' }
Profiler >> coveredMethods [ 
	"Return the list of covered methods"

	^ self allMethods select: #isCovered
]

{ #category : #gathering }
Profiler >> fillClassType: classType with: methodDictionary [
	| compiledMethod methodSpy |

	classType theClass == Profiler class
		ifTrue: [ ^ self ].

	methodDictionary associationsDo: 
		[:assoc | 
			compiledMethod := (classType theClass >> assoc key).
			compiledMethod isSpy
				ifTrue: [ methodSpy := compiledMethod methodSpy.
							methodSpy classSpy: classType.
							classType localMethodAt: assoc key put: methodSpy ] ].

]

{ #category : #gathering }
Profiler >> gather [

	^ self gatherForClasses: self class nonDangerousClasses.

]

{ #category : #gathering }
Profiler >> gatherForClassCategory: nameAsString [
	"Return a profiler"
	| package cls classNames classType answer |
	package := self packageForClassCategory: nameAsString.
	package packageName: nameAsString.

	self addPackage: package.

	^ self
]

{ #category : #gathering }
Profiler >> gatherForClasses: classes [

	| package classType profiler |

	package := self class spyClassForPackage new.
	package packageName: 'Global profiling'.

	classes do: [:cls |
		classType := self spyForClass: cls.
		classType packageSpy: package.
		package classAt: cls name put: classType].
	
	self addPackage: package.
	^ package
]

{ #category : #gathering }
Profiler >> gatherForPackageNamed: nameAsString [
	"Return a profiler"

	| classes classType package |
	package := self class spyClassForPackage new.
	package packageName: nameAsString.
	self addPackage: package.
	classes := (RPackageSet named: nameAsString) classes reject: #isTrait.
	classes
		do: [ :cls | 
			classType := self spyForClass: cls.
			classType packageSpy: package.
			package profiler: self.
			package classAt: cls name put: classType ].
	^ self
]

{ #category : #gathering }
Profiler >> gatherForPackagesMatching: regexpAsString [
	"Return a profiler"

	| tpackages |
	tpackages := RPackageOrganizer default packages
		select: [ :p | regexpAsString match: p name asString ].
	tpackages
		do: [ :pak | 
			| class package |
			package := self class spyClassForPackage new.
			package packageName: pak packageName.
			self addPackage: package.
			(pak classesAndMetaClasses reject: #isTrait)
				do: [ :cls | 
					class := self spyForClass: cls.
					class packageSpy: package.
					package classAt: cls name asSymbol put: class ] ].
	^ self
]

{ #category : #gathering }
Profiler >> gatherForPackagesNamed: packagesNames [
	"Return a profiler"

	| classType packageInfos |
	packageInfos := RPackageSet allPackages
		select: [ :p | packagesNames includes: p externalName ].
	packageInfos
		do: [ :pak | 
			| class package |
			package := self class spyClassForPackage new.
			package packageName: pak packageName.
			self addPackage: package.
			(pak classes reject: #isTrait)
				do: [ :cls | 
					class := self spyForClass: cls.
					class packageSpy: package.
					package classAt: cls name put: class ] ].
	^ self
]

{ #category : #gathering }
Profiler >> gatherForSeveralPackagesMatching: collectionOfRegExp [
	"Return a profiler"
	
	| tpackages |
	collectionOfRegExp do: [ :regexpAsString | 
		tpackages := (RPackageOrganizer default packages select: [:p | regexpAsString match: p name asString ]).

		tpackages do: [ :pak | 
			| class package |
			package := self class spyClassForPackage new.
			package packageName: pak packageName.
			self addPackage: package.

			(pak classesAndMetaClasses reject: #isTrait) do: [:cls|
				class := self spyForClass: cls.
				class packageSpy: package.
				package classAt: cls name asSymbol put: class ] ] ].

	^ self
]

{ #category : #hooks }
Profiler >> getTimeAndCallGraph [
	^ false
]

{ #category : #testing }
Profiler >> hasUnitTestResult [
	^ unitTestResult notNil
]

{ #category : #'initialize-release' }
Profiler >> initialize [ 
	super initialize.
	packages := nil.
	
]

{ #category : #installing }
Profiler >> install [
	self allMethods asSet do: #install
]

{ #category : #'accessing - read only' }
Profiler >> noncoveredMethods [ 
	"Return the list of noncovered methods"

	^ self allMethods reject: #isCovered
]

{ #category : #'accessing - read only' }
Profiler >> numberOfClasses [
	^ self allClasses size
]

{ #category : #'accessing - read only' }
Profiler >> numberOfMethods [
	^ self allMethods size
]

{ #category : #'accessing - read only' }
Profiler >> numberOfNonAbstractMethods [
	"Return the number of non abstract methods, including the one of the metaclass "

	^ self allNonAbstractMethods size
]

{ #category : #gathering }
Profiler >> packageForClassCategory: nameAsString [
	| package classNames classType |
	package := self class spyClassForPackage new.

	classNames := SystemOrganization listAtCategoryNamed: nameAsString.
	
	classNames do: [:clsName |
		| cls |
		cls := Smalltalk at: clsName.
		cls isTrait ifFalse: 
			[classType := self spyForClass: cls.
			classType packageSpy: package.
			package classAt: clsName put: classType]].
	
	^ package
]

{ #category : #accessing }
Profiler >> packages [
	^ packages ifNil: [ packages := OrderedCollection new ]
]

{ #category : #accessing }
Profiler >> packagesToTest: aCollectionOfStrings [
	packagesToTest := aCollectionOfStrings
]

{ #category : #'accessing - read only' }
Profiler >> profilings [
	^ self class profilingOf: self class
]

{ #category : #actions }
Profiler >> remove [
	^ self class remove
]

{ #category : #actions }
Profiler >> removeFromRegistry [
	self class registry removeKey: (self class registry keyAtValue: self )
]

{ #category : #'time and call graph' }
Profiler >> setIfNecessaryTimeAndCallGraphFrom: aBlock [

	self getTimeAndCallGraph ifTrue: [ self setTimeAndCallGraphFrom: aBlock ]

]

{ #category : #visualization }
Profiler >> setInteractionForClassSpyOn: view [
	view interaction 
		item: 'inspect' action: [ :el | el inspect ];
		item: 'browse' action: [ :m | m browse ]

]

{ #category : #visualization }
Profiler >> setInteractionForMethodSpyOn: view [
	view interaction 
		item: 'inspect' action: [ :el | el inspect ];
		item: 'browse' action: [ :m | m browse ]

]

{ #category : #'time and call graph' }
Profiler >> setTimeAndCallGraphFrom: aBlock [
	| tally |
	tally := (self tallyOn: aBlock).
	self setTimeInfoFromTally: tally.
	tally close.
]

{ #category : #util }
Profiler >> setTimeInfoFromTally: aTally [
	"Set to ech method of the profiler, what is the total execution time"
	"public method"
	
	totalExecutionTime := aTally time.
	self setTimeInfoFromTally: aTally parents: {aTally}.
]

{ #category : #util }
Profiler >> setTimeInfoFromTally: aTally parents: tallies [
	
	| sons mClass method newTallies callerTally parentTally callerMethod callerClass |

	mClass := self classAt: aTally method methodClass name ifNone: [nil].
	mClass ifNotNil: [
		method := mClass localMethodAt: aTally method selector ifAbsent: [nil].

		method ifNotNilDo: [:e | 
			method useTime: aTally parents: tallies.
			parentTally := tallies last.
			callerClass := self classAt: parentTally method methodClass name ifNone: [nil].
			callerClass ifNotNil: [
				callerMethod := callerClass localMethodAt: parentTally method selector ifAbsent: [nil].
				callerMethod ifNotNil: [ 
					callerMethod addOutgoingCalls: method.
					method addIncomingCalls: callerMethod.
					"self assert: [callerMethod outgoingCalls includes: method] "] 
			]]].

	sons := aTally receivers.
	newTallies := tallies , {aTally}.
	sons do: [:e | self setTimeInfoFromTally: e parents: newTallies].

]

{ #category : #gathering }
Profiler >> spyForClass: aClass [
	| classType |
	classType := self class spyClassForClass new.
	classType className: aClass name.
	self fillClassType: classType with: aClass methodDict.
	self fillClassType: classType metaclassSpy with: aClass class methodDict.
	^ classType

]

{ #category : #installing }
Profiler >> uninstall [
	self allMethods do: #uninstall
]

{ #category : #accessing }
Profiler >> unitTestResult [
	^ unitTestResult
]

{ #category : #accessing }
Profiler >> unitTestResult: testResult [
	unitTestResult := testResult
]
