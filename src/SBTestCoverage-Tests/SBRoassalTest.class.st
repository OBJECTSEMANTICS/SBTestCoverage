Class {
	#name : #SBRoassalTest,
	#superclass : #SBTest,
	#category : #'SBTestCoverage-Tests-Core'
}

{ #category : #tests }
SBRoassalTest >> testCoverageRTColorPaletteExample [
	| profiler |
	profiler := SBProfiler
		profile: [ | v |
			v := RTView new.
			v @ RTDraggableView.
			RTCPDiverging new viewOn: v.
			v ]
		onPackagesMatching: 'Roassal2'.
	self assert: profiler numberOfExecutedMethods > 0.
	self assert: profiler numberOfExecutedStatements > 0
]

{ #category : #tests }
SBRoassalTest >> testCoverageRTDynamicStackedGrapherWithRTComposer [
	| profiler |
	profiler := SBProfiler
		profile: [ | composer a b |
			composer := RTComposer new.
			a := RTDynamicStackedGrapher new.
			a
				minY: -200;
				maxY: 200.
			a view: composer view.
			a y: #yourself.
			a build.
			composer group: #first.
			b := RTDynamicStackedGrapher new.
			b
				minY: -200;
				maxY: 200.
			b view: composer view.
			b y: #yourself.
			b build.
			composer group: #second.
			composer move: #first onTheLeftOf: #second.
			composer nameGroup: #first as: 'aFirstName'.
			composer nameGroup: #second as: 'aSecondName'.
			composer setGeneralTitle: 'aGeneralTitle'.
			composer view
				addMenu: 'Left'
				callback: [ a add: 400 atRandom - 200 ].
			composer view
				addMenu: 'Right'
				callback: [ b add: 400 atRandom - 200 ].
			composer view ]
		onPackagesMatching: 'Roassal2'.
	self assert: profiler numberOfExecutedMethods > 0.
	self assert: profiler numberOfExecutedStatements > 0
]

{ #category : #tests }
SBRoassalTest >> testCoverageRTElement [
	| profiler |
	profiler := SBProfiler profile: [ 
		RTElement new.
	] onClass: RTElement.
	"profiler>>#RTElement>>#center."
	self assertNoExecutedMethods: profiler equals: 2.
	self assert: profiler numberOfExecutedStatements equals: 3.
	
	profiler := SBProfiler profile: [ 
		RTElement new hasNestedElements.
	] onClass: RTElement.
	self assertNoExecutedMethods: profiler equals: 4.
	self assert: profiler numberOfExecutedStatements equals: 6.
	
	profiler := SBProfiler profile: [ 
		RTElement new incomingEdges.
	] onClass: RTElement.
	self assertNoExecutedMethods: profiler equals: 3.
	self assert: profiler numberOfExecutedStatements equals: 6.
	
]

{ #category : #tests }
SBRoassalTest >> testCoverageRTExperimentalSelectionExample [
	| profiler |
	profiler := SBProfiler
		profile:
			[ | energy sankey nodes nodeAt colors d color form lineColor textColor |
			energy := RTExperimentalExample new sankeyData.
			colors := RTColorPalette qualitative colors: 20 scheme: 'FlatUI1'.
			d := Dictionary new.
			color := [ :n | 
			| k i |
			k := n.
			i := k indexOf: Character space.
			i isZero
				ifFalse: [ k := k copyFrom: 1 to: i - 1 ].
			d
				at: k
				ifAbsentPut: [ i := d size + 1.
					i > colors size
						ifTrue: [ i := i // colors size ].
					colors at: i ] ].
			sankey := RTSankeyBuilder new.
			form := [ :n | 
			| e |
			e := sankey view elements elementFromModel: n.
			e ifNil: [ e := sankey view edges elementFromModel: n ].
			(e attributes at: #value) asString , ' TWh' ].
			sankey shape width: 15.
			lineColor := TRTheme current blue trans.
			textColor := Color black.
			sankey lineShape color: lineColor.
			nodes := energy at: 'nodes'.
			nodeAt := [ :n | nodes at: n + 1 ].
			sankey shape box
				borderColor: Color black;
				borderWidth: 1;
				width: 15;
				color: color.
			(sankey interaction
				popupText: [ :n | n , String cr , (form value: n) ])
				backgroundColor: Color white;
				alphaPopupBackground: 1;
				borderColor: Color gray.
			(sankey interactionEdge
				popupText: [ :ass | ass key , ' → ' , ass value , String cr , (form value: ass) ])
				backgroundColor: Color white;
				alphaPopupBackground: 1;
				borderColor: Color gray.
			sankey labelShape text
				text: [ :n | n ];
				color: textColor.
			sankey
				extent: 960 @ 500;
				iterations: 32;
				nodePadding: 10;
				nodes: nodes;
				links: (energy at: 'links');
				linkFrom: [ :l | nodeAt value: (l at: 'source') ];
				linkTo: [ :l | nodeAt value: (l at: 'target') ];
				linkValue: [ :l | l at: 'value' ].
			sankey build.
			sankey view ]
		onPackagesMatching: 'Roassal2'.
	self assert: profiler numberOfExecutedMethods > 0.
	self assert: profiler numberOfExecutedStatements > 0
]

{ #category : #tests }
SBRoassalTest >> testCoverageRTSunburstBuilderExample [
	| profiler |
	profiler := SBProfiler
		profile: [ | p b lb |
			p := RTPalette c3.
			b := RTSunburstBuilder new.
			b layout sunburstWithRadius: 100.
			b
				angularSpacing: 1;
				radialSpacing: 5.
			b shape
				color: [ p first ];
				if: [ :cls | '*Array*' match: cls name ] color: [ p second ];
				if: [ :cls | '*Set*' match: cls name ] color: [ p third ];
				if: [ :cls | '*Hash*' match: cls name ] color: [ p fourth ].
			b explore: Collection using: #subclasses.
			b build.
			lb := RTLegendBuilder new.
			lb view: b view.
			lb
				addText: 'Visualizing the collection Pharo collection class library'.
			lb addColor: p second text: 'Array-like classes'.
			lb addColor: p third text: 'Set-like classes'.
			lb addColor: p fourth text: 'Hash-classes classes'.
			lb build.
			b view ]
		onPackagesMatching: 'Roassal2'.
	self assert: profiler methodCoverage > 0.
	self assert: profiler statementCoverage > 0
]

{ #category : #tests }
SBRoassalTest >> testCoverageRTTheme [
	| profiler |
	profiler := SBProfiler profile: [ 
		RTTheme new textFont.
	] onClass: RTTheme.
	self assertNoExecutedMethods: profiler equals: 2.
	self assert: profiler numberOfExecutedStatements equals: 2.
	"
	profiler := SBProfiler profile: [ 
		RTElement new hasNestedElements.
	] onClass: RTElement.
	self assertNoExecutedMethods: profiler equals: 4.
	self assert: profiler numberOfExecutedStatements equals: 6.
	
	profiler := SBProfiler profile: [ 
		RTElement new incomingEdges.
	] onClass: RTElement.
	self assertNoExecutedMethods: profiler equals: 3.
	self assert: profiler numberOfExecutedStatements equals: 6.
	"
]

{ #category : #tests }
SBRoassalTest >> testMethodCoverageRTBox [
	| profiler |
	profiler := SBProfiler profile: [ 
		RTBox new trachelShapeClass.
	] onClass: RTBox.
	self assertNoExecutedMethods: profiler equals: 1.
	self asserMethodCoverage: profiler toNoExecutedMethods: 1.
	
]

{ #category : #tests }
SBRoassalTest >> testMethodCoverageRTGroup [
	| profiler |
	profiler := SBProfiler profile: [ 
		RTGroup new attributeAt: #foo ifAbsentPut: 20.
	] onClass: RTGroup.
	self assertNoExecutedMethods: profiler equals: 2.
	self asserMethodCoverage: profiler toNoExecutedMethods: 2.
	
]
