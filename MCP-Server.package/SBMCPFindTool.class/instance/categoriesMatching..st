dependencies
categoriesMatching: aString
	"The class category aString and its subcategories, e.g. Presenter-Core and Presenter-Core-Text for Presenter-Core"
	^ (SystemOrganization categories select: [:each |
		each = aString or: [each beginsWith: aString, '-']]) asArray