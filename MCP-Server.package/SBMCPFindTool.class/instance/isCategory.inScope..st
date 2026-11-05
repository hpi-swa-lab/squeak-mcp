dependencies
isCategory: aCategory inScope: scope
	scope isEmpty ifTrue: [^ true].
	^ aCategory notNil and: [aCategory asString asLowercase beginsWith: scope asLowercase]