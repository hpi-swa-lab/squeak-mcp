dependencies
dependenciesOf: categories scope: scope limit: limit
	"What the classes and extension methods of categories need from other class categories: method references (also in blocks), superclasses and extended classes. The latter two are needed at load time."
	| dependencies sorted |
	dependencies := Dictionary new.
	self methodsOf: categories do: [:behavior :selector :owner :isExtension | | targets extended |
		targets := Dictionary new.
		(behavior compiledMethodAt: selector) allLiteralsDo: [:literal |
			(literal isVariableBinding and: [literal value isBehavior]) ifTrue: [
				targets at: literal value theNonMetaClass category ifAbsentPut: [literal value theNonMetaClass name]]].
		targets keysAndValuesDo: [:target :className |
			(target ~= owner and: [self isCategory: target inScope: scope]) ifTrue: [ | dependency |
				dependency := self dependencyFrom: owner to: target in: dependencies.
				dependency at: 'references' put: (dependency at: 'references') + 1.
				(dependency at: 'examples') size < self class maxDependencyExamples ifTrue: [
					(dependency at: 'examples') add: behavior name, '>>', selector, ' uses ', className]]].
		extended := behavior theNonMetaClass category.
		(isExtension and: [extended ~= owner and: [self isCategory: extended inScope: scope]]) ifTrue: [
			((self dependencyFrom: owner to: extended in: dependencies) at: 'extends') add: behavior name, '>>', selector]].
	categories do: [:category |
		(SystemOrganization listAtCategoryNamed: category) do: [:className | | superclass |
			superclass := (Smalltalk at: className) superclass.
			(superclass notNil and: [superclass category ~= category and: [self isCategory: superclass category inScope: scope]]) ifTrue: [
				((self dependencyFrom: category to: superclass category in: dependencies) at: 'superclasses') add: className, ' < ', superclass name]]].
	sorted := dependencies values asArray sort: [:a :b |
		(a at: 'from') < (b at: 'from') or: [(a at: 'from') = (b at: 'from') and: [(self weightOf: a) >= (self weightOf: b)]]].
	^ Dictionary new
		at: 'categories' put: categories;
		at: 'count' put: sorted size;
		at: 'dependencies' put: ((sorted first: (limit min: sorted size)) collect: [:each |
			each
				at: 'examples' put: (each at: 'examples') asArray;
				at: 'superclasses' put: (each at: 'superclasses') asArray;
				at: 'extends' put: (each at: 'extends') asArray;
				yourself]);
		yourself