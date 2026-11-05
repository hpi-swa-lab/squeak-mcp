searching
selectorsContaining: aString scope: scope limit: limit
	"Implemented selectors containing aString (ignoring case), with their number of implementors in scope. One pass over all classes, rather than one implementors search per selector."
	| implementors selectors |
	implementors := Bag new.
	SystemNavigation default allBehaviorsDo: [:behavior |
		behavior selectorsDo: [:selector |
			((selector includesSubstring: aString caseSensitive: false)
				and: [self isMethod: (MethodReference class: behavior selector: selector) inScope: scope])
					ifTrue: [implementors add: selector]]].
	selectors := implementors asSet asSortedCollection.
	^ Dictionary new
		at: 'count' put: selectors size;
		at: 'selectors' put: ((selectors first: (limit min: selectors size)) collect: [:each |
			Dictionary new
				at: 'selector' put: each;
				at: 'implementors' put: (implementors occurrencesOf: each);
				yourself]) asArray;
		yourself