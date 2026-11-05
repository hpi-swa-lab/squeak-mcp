searching
isMethod: aMethodReference inScope: scope
	"Methods of classes in a category starting with scope, and extension methods in a matching *category."
	| prefix |
	scope isEmpty ifTrue: [^ true].
	prefix := scope asLowercase.
	^ (aMethodReference actualClass theNonMetaClass category asString asLowercase beginsWith: prefix)
		or: [aMethodReference category asString asLowercase beginsWith: '*', prefix]