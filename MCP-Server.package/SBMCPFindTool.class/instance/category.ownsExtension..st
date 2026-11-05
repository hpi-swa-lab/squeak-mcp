dependencies
category: aClassCategory ownsExtension: aMethodCategory
	"Like Monticello: *presenter-core and *presenter-core-text belong to Presenter-Core, ignoring case"
	| package |
	package := aClassCategory asLowercase.
	^ (aMethodCategory allButFirst asLowercase in: [:name |
		name = package or: [name beginsWith: package, '-']])