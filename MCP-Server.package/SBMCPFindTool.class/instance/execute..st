executing
execute: arguments
	| kind query scope limit methods |
	kind := self from: arguments get: 'kind' ifAbsent: [''].
	query := (self from: arguments get: 'query' ifAbsent: ['']) withBlanksTrimmed.
	scope := self from: arguments get: 'scope' ifAbsent: [''].
	limit := self integerFrom: arguments get: 'limit' ifAbsent: [self class defaultLimit].
	(self class kinds includes: kind) ifFalse: [
		^ self errorResult: 'kind must be one of ', (self class kinds inject: '' into: [:all :each | all isEmpty ifTrue: [each] ifFalse: [all, ', ', each]])].
	query isEmpty ifTrue: [^ self errorResult: 'query parameter is required'].

	kind = 'dependencies' ifTrue: [
		^ (self categoriesMatching: query)
			ifEmpty: [self errorResult: 'No class category named ', query, ' or starting with ', query, '-']
			ifNotEmpty: [:categories | self successResult: (self dependenciesOf: categories scope: scope limit: limit)]].
	kind = 'selectors' ifTrue: [
		^ self successResult: (self selectorsContaining: query scope: scope limit: limit)].
	methods := self methodsFor: kind query: query arguments: arguments.
	methods isString ifTrue: [^ self errorResult: methods].
	methods := (methods select: [:each | self isMethod: each inScope: scope])
		asSortedCollection: [:a :b | (self nameOf: a) <= (self nameOf: b)].
	^ self successResult: (Dictionary new
		at: 'count' put: methods size;
		at: 'methods' put: ((methods first: (limit min: methods size)) collect: [:each |
			self describe: each kind: kind query: query]) asArray;
		yourself)