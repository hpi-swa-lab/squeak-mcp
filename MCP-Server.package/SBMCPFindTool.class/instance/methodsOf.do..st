dependencies
methodsOf: categories do: aBlock
	"Evaluate aBlock with behavior, selector, owning category and whether it is an extension method, for every method that belongs to one of categories: the methods of their classes except extensions of other packages, and their extension methods (*category) on other classes."
	SystemNavigation default allBehaviorsDo: [:behavior | | classCategory |
		classCategory := behavior theNonMetaClass category.
		behavior organization categories do: [:methodCategory | | isExtension owner |
			isExtension := methodCategory notEmpty and: [methodCategory first = $*].
			owner := isExtension
				ifTrue: [categories
					detect: [:each | self category: each ownsExtension: methodCategory]
					ifNone: [nil]]
				ifFalse: [(categories includes: classCategory) ifTrue: [classCategory]].
			owner ifNotNil: [
				(behavior organization listAtCategoryNamed: methodCategory) do: [:selector |
					aBlock value: behavior value: selector value: owner value: isExtension]]]]