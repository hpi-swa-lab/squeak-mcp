executing
execute: arguments
	| categoryPrefix matchingCategories results |
	categoryPrefix := self from: arguments get: 'category' ifAbsent: [''].
	categoryPrefix isEmpty ifTrue: [
		^ self errorResult: 'category parameter is required'].
	
	matchingCategories := SystemOrganization categories
		select: [:cat | cat beginsWith: categoryPrefix].
		
	matchingCategories isEmpty ifTrue: [
		^ self errorResult: 'No category found matching: ', categoryPrefix].
		
	results := OrderedCollection new.
	matchingCategories do: [:cat |
		(SystemOrganization listAtCategoryNamed: cat) do: [:className |
			| cls |
			cls := Smalltalk at: className ifAbsent: [nil].
			cls ifNotNil: [
				results add: (Dictionary new
					at: 'name' put: cls name;
					at: 'superclass' put: (cls superclass ifNil: ['nil'] ifNotNil: [:s | s name]);
					at: 'category' put: cat;
					yourself)]]].
	^ self successResult: results asArray