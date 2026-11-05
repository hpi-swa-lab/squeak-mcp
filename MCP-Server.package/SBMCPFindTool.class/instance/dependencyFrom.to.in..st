dependencies
dependencyFrom: fromCategory to: toCategory in: aDictionary
	^ aDictionary at: fromCategory -> toCategory ifAbsentPut: [
		Dictionary new
			at: 'from' put: fromCategory;
			at: 'to' put: toCategory;
			at: 'references' put: 0;
			at: 'examples' put: OrderedCollection new;
			at: 'superclasses' put: OrderedCollection new;
			at: 'extends' put: OrderedCollection new;
			yourself]