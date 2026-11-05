private
testsNamed: aString
	"The tests for Class>>selector, a test class, or a class category and its subcategories. Answer nil if there is no such thing."
	| categories |
	(aString includesSubstring: '>>') ifTrue: [ | class selector |
		class := Smalltalk classNamed: (aString copyUpTo: $>).
		selector := (aString copyAfterLast: $>) copyWithout: $#.
		^ (class notNil and: [class isTestClass and: [class canUnderstand: selector asSymbol]])
			ifTrue: [{class selector: selector asSymbol}]
			ifFalse: [nil]].
	(Smalltalk classNamed: aString) ifNotNil: [:class |
		^ class isTestClass ifTrue: [class buildSuite tests] ifFalse: [nil]].
	categories := SystemOrganization categories select: [:each |
		each = aString or: [each beginsWith: aString, '-']].
	categories isEmpty ifTrue: [^ nil].
	^ categories gather: [:category |
		((SystemOrganization listAtCategoryNamed: category)
			collect: [:each | Smalltalk at: each])
			inject: OrderedCollection new
			into: [:tests :class |
				(class isTestClass and: [class isAbstract not])
					ifTrue: [tests addAll: class buildSuite tests].
				tests]]